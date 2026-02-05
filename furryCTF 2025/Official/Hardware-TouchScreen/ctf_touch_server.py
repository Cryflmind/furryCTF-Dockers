#!/usr/bin/env python3
import socketserver, socket, threading, time, json, argparse

# === Minimal Smart-Frame Protocol (SFP, classic) constants ===
ECHO_ON              = 0x20
ECHO_OFF             = 0x21
SCAN_REPORTING       = 0x22
COORDINATE_REPORTING = 0x23
ENTER_POINT_MODE     = 0x25
TRACKING_MODE        = 0x26
CONTINUOUS_MODE      = 0x27
EXIT_POINT_MODE      = 0x28
ADD_EXIT_MODIFIER    = 0x29
TOUCH_SCANNING_ON    = 0x2A
TOUCH_SCANNING_OFF   = 0x2B
GET_FIRMWARE_VERSION_REPORT = 0x34
SOFTWARE_RESET       = 0x3C
CLEAR_TOUCH_BUFFER   = 0x3D
REPORT_TRANSFER_OFF  = 0x43
REPORT_TRANSFER_ON   = 0x44
RESET                = 0x45
GET_ONE_REPORT       = 0x46
GET_STATE_REPORT     = 0x47
GET_FRAME_SIZE       = 0x37

# SFP report headers / trailers

TOUCH_COORD_HEADER   = 0xFE  # FE X Y FF
ADD_EXIT_HEADER      = 0xFD  # FD X Y FF
NON_CONTIG_HEADER    = 0xFC  # FC T FF
STATE_HEADER         = 0xF2  # F2 NS SRM SOM STS SUE SRT SHF FF
FRAME_SIZE_HEADER    = 0xF4  # F4 X Y FF
NULL_REPORT_HEADER   = 0xF5  # F5 FF
FIRMWARE_VERSION_REPORT_HEADER = 0xF6  # F6 V1 V2 V3 V4 FF
TRAILER              = 0xFF

DEFAULT_FRAME_X = 79
DEFAULT_FRAME_Y = 59

def u8(n):
    return max(0, min(255, int(n)))

class TouchScript:
    # Holds a scripted sequence of touch events loaded from JSON.
    # Each event: {type: 'touch'|'exit'|'noncontig', x:int, y:int, t:int?}
    def __init__(self, cfg):
        self.events = list(cfg.get('events', []))
        self.loop = bool(cfg.get('loop', False))
        self.delay_ms = int(cfg.get('stream_delay_ms', 60))
        self._idx = 0
        self.lock = threading.Lock()

    def clear(self):
        with self.lock:
            self._idx = 0

    def next_report(self):
        with self.lock:
            if not self.events:
                return None
            if self._idx >= len(self.events):
                if self.loop:
                    self._idx = 0
                else:
                    return None
            ev = self.events[self._idx]
            self._idx += 1

        etype = ev.get('type', 'touch')
        if etype == 'touch':
            x = u8(ev.get('x', 0))
            y = u8(ev.get('y', 0))
            return (TOUCH_COORD_HEADER, [x, y], TRAILER)
        elif etype == 'exit':
            x = u8(ev.get('x', 0))
            y = u8(ev.get('y', 0))
            return (ADD_EXIT_HEADER, [x, y], TRAILER)
        elif etype == 'noncontig':
            t = u8(ev.get('t', ev.get('id', 1)))
            return (NON_CONTIG_HEADER, [t], TRAILER)
        elif etype == 'multi':
            pts = []
            for (x, y) in ev.get('points', []):
                pts.extend([u8(x), u8(y)])
            return (TOUCH_COORD_HEADER, pts, TRAILER)
        else:
            return self.next_report()

class DeviceState:
    def __init__(self, cfg):
        self.echo = bool(cfg.get('echo', False))
        self.reporting_method = 1  # 1=coordinate, 2=scan
        self.touch_mode = cfg.get('mode', 'tracking').lower()
        self.SOM_values = {
            ('tracking', False): 1, ('enter', False): 2, ('continuous', False): 3, ('exit', False): 4,
            ('tracking', True): 5,  ('enter', True): 6,  ('continuous', True): 7,  ('exit', True): 8,
        }
        self.add_exit = bool(cfg.get('add_exit', False))
        self.scanning_on = bool(cfg.get('touch_scanning_on', False))
        self.report_transfer_on = bool(cfg.get('report_transfer_on', False))
        self.hw_flow = False
        self.frame_x = int(cfg.get('frame', {}).get('x', DEFAULT_FRAME_X))
        self.frame_y = int(cfg.get('frame', {}).get('y', DEFAULT_FRAME_Y))
        self.script = TouchScript(cfg)
        self.streaming_mode = bool(cfg.get('streaming_mode', False))
        self.buffer = []

    def build_state_report(self):
        NS = 6
        SRM = 1 if self.reporting_method == 1 else 2
        som_key = (self.touch_mode if self.touch_mode in ('tracking','enter','continuous','exit') else 'tracking', self.add_exit)
        SOM = self.SOM_values.get(som_key, 1)
        STS = 2 if self.scanning_on else 1
        SUE = 1
        SRT = 2 if self.report_transfer_on else 1
        SHF = 1
        return bytes([STATE_HEADER, NS, SRM, SOM, STS, SUE, SRT, SHF, TRAILER])

    def build_firmware_version_report(self):
        firmware_version = ">w< There's nothing you want here~"
        firmware_version_hex = [ord(c) for c in firmware_version]
        return bytes([FIRMWARE_VERSION_REPORT_HEADER, len(firmware_version_hex)] + firmware_version_hex + [TRAILER])
    
    def build_frame_size_report(self):
        return bytes([FRAME_SIZE_HEADER, u8(self.frame_x), u8(self.frame_y), TRAILER])

    def build_null_report(self):
        return bytes([NULL_REPORT_HEADER, TRAILER])

    def maybe_queue_next_from_script(self):
        nxt = self.script.next_report()
        if nxt:
            self.buffer.append(nxt)

    def pop_buffer_or_null(self):
        if self.buffer:
            h, payload, t = self.buffer.pop(0)
            return bytes([h] + payload + [t])
        self.maybe_queue_next_from_script()
        if self.buffer:
            h, payload, t = self.buffer.pop(0)
            return bytes([h] + payload + [t])
        return self.build_null_report()

class SFPHandler(socketserver.BaseRequestHandler):
    def setup(self):
        self.state = self.server.state
        
        if self.state.streaming_mode:
            t = threading.Thread(target=self._streamer, daemon=True)
            t.start()

    def _streamer(self):
        while True:
            time.sleep(self.state.script.delay_ms / 1000.0)
            if self.state.report_transfer_on and self.state.scanning_on and self.state.reporting_method == 1:
                self.state.maybe_queue_next_from_script()
                if self.state.buffer:
                    pkt = self.state.pop_buffer_or_null()
                    try:
                        self.request.sendall(pkt)
                    except Exception:
                        break

    def handle(self):
        conn = self.request
        conn.settimeout(300)
        while True:
            try:
                data = conn.recv(1024)
                if not data:
                    break
            except (socket.timeout, ConnectionResetError):
                break

            if self.state.echo:
                try:
                    conn.sendall(data)
                except Exception:
                    break

            for b in data:
                self._handle_byte(b, conn)

    def _handle_byte(self, b, conn):
        s = self.state
        if b == ECHO_ON: s.echo = True; return
        if b == ECHO_OFF: s.echo = False; return
        if b in (SOFTWARE_RESET, RESET):
            s.touch_mode = 'tracking'; s.add_exit = False; s.reporting_method = 1
            s.scanning_on = False; s.report_transfer_on = False; s.buffer.clear()
            time.sleep(0.12); return
        if b == CLEAR_TOUCH_BUFFER: s.buffer.clear(); return

        if b == COORDINATE_REPORTING: s.reporting_method = 1; return
        if b == SCAN_REPORTING: s.reporting_method = 2; return
        

        if b == TRACKING_MODE: s.touch_mode = 'tracking'; return
        if b == ENTER_POINT_MODE: s.touch_mode = 'enter'; return
        if b == CONTINUOUS_MODE: s.touch_mode = 'continuous'; return
        if b == EXIT_POINT_MODE: s.touch_mode = 'exit'; return
        if b == ADD_EXIT_MODIFIER: s.add_exit = True; return
        if b == TOUCH_SCANNING_ON: s.scanning_on = True; return
        if b == TOUCH_SCANNING_OFF: s.scanning_on = False; return

        if b == REPORT_TRANSFER_ON:
            s.report_transfer_on = True
            
            if not s.streaming_mode:
                s.maybe_queue_next_from_script()
                if s.buffer:
                    pkt = s.pop_buffer_or_null()
                    try: conn.sendall(pkt)
                    except Exception: pass
            return
        if b == REPORT_TRANSFER_OFF: s.report_transfer_on = False; return

        if b == GET_FIRMWARE_VERSION_REPORT:
            try: conn.sendall(s.build_firmware_version_report())
            except Exception: pass
            return

        if b == GET_STATE_REPORT:
            try: conn.sendall(s.build_state_report())
            except Exception: pass
            return
        if b == GET_FRAME_SIZE:
            try: conn.sendall(s.build_frame_size_report())
            except Exception: pass
            return
        if b == GET_ONE_REPORT:
            pkt = s.pop_buffer_or_null()
            try: conn.sendall(pkt)
            except Exception: pass
            return

class TouchServer(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    def __init__(self, addr, handler, state):
        super().__init__(addr, handler)
        self.state = state

def main():
    ap = argparse.ArgumentParser(description='CTF Smart-Frame (SFP) touch device emulator')
    ap.add_argument('--host', default='0.0.0.0')
    ap.add_argument('--port', type=int, default=2233)
    ap.add_argument('--config', required=True)
    args = ap.parse_args()

    with open(args.config, 'r', encoding='utf-8') as f:
        cfg = json.load(f)

    state = DeviceState(cfg)
    print(f'[+] Listening on {args.host}:{args.port} | frame={state.frame_x}x{state.frame_y} | streaming={state.streaming_mode} | echo={state.echo}')
    print(f'    Scripted events: {len(state.script.events)} | loop={state.script.loop} | delay={state.script.delay_ms}ms')

    with TouchServer((args.host, args.port), SFPHandler, state) as srv:
        try:
            srv.serve_forever()
        except KeyboardInterrupt:
            print('\n[!] Shutting down')

if __name__ == '__main__':
    main()
