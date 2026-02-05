import ast
import subprocess
import tempfile
import os
import time
import threading
from flask import Flask, render_template, request, jsonify
from flask_socketio import SocketIO, emit
import secrets

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', secrets.token_hex(32))
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024
socketio = SocketIO(app, cors_allowed_origins="*")

active_processes = {}

banned = ['os','sys','subprocess','shlex','pty','popen','shutil','platform','ctypes','cffi','io','importlib','linecache','inspect','builtins',\
        'yaml','fcntl','functools','itertools','operator','readline','getpass','pprint','pipes','pathlib','pdb','Path','codecs','fileinput',\
        'mmap','runpy','difflib','tempfile','glob','gc','threading','multiprocessing','dis','logging','_thread','atexit','urllib','request',\
        'self','modules','help','warnings','pydoc','load_module','object','bytes','weakref','reprlib','encode','future','uuid','multi','posix',\
        'CGIHTTPServer','cgitb','compileall','dircache','doctest', 'dumbdbm', 'filecmp','ftplib','gzip','getopt','gettext','httplib','popen2',\
        'imputil','macpath','mailbox','mailcap','mhlib','mimetools','mimetypes','modulefinder','netrc','new','optparse','SimpleHTTPServer',\
        'posixfile','profile','pstats','py_compile','pyclbr','rexec','SimpleXMLRPCServer', 'site', 'smtpd', 'socket', 'SocketServer',\
        'sysconfig', 'tabnanny', 'tarfile', 'telnetlib','Tix', 'trace', 'turtle', 'urllib', 'urllib2','user', 'uu', 'webbrowser', 'whichdb',\
        'zipfile', 'zipimport','eval','exec','compile','input','__import__','open','file','execfile','reload','globals','items','keys',\
         'values','getline','getlines','isinstance','__build_class__','help','type','super','getattr','setattr','vars','property',\
        'staticmethod','classmethod','dir','object','read_text','__subclasses__','fileno','get_data','locals','get','_current_frames',\
        'f_locals','f_globals','f_back','settrace','setprofile','tb_frame','__traceback__','tb_next','_getframe','f_code','co_consts',\
        'co_names','basicConfig','get_objects','startswith','dumps','request','urlopen','response','get_content','decode','self',\
        'modules','environ','breakpointhook','set_trace','interaction','gi_frame','stdout','stderr','stdin','StringIO','fork_exec',\
        'path','_Printer__filenames','system','popen','spawn','execv','execl','execve','execlp','execvp','chdir','kill','remove','unlink','rmdir','mkdir','makedirs',\
        'removedirs','read','write','readlines','writelines','load','loads','dump','dumps','get_data','get_source','get_code','load_module',\
        'exec_module','items','keys','values','getline','getlines','__globals__','__dict__','__build_class__','help','type','super',\
        'getattr','setattr','vars','property','staticmethod','classmethod','dir','object','read_text','__subclasses__','__bases__',\
        '__class__','fileno','ACCESS_READ','locals','get','_current_frames','f_locals','f_globals','f_back','settrace','setprofile',\
        'tb_frame','__traceback__','tb_next','_getframe','f_code','co_consts','co_names','basicConfig','get_objects','interaction',\
        'startswith','request','urlopen','response','get_content','decode','self','modules','environ','breakpointhook','set_trace',\
        'gi_frame','stdout','stderr','stdin','StringIO','reload','fork_exec','path','_Printer__filenames','__class__','__base__','__bases__',\
        '__mro__','__subclasses__','__globals__','__builtins__','__getattribute__','__getattr__','__setattr__','__delattr__','__call__',\
        '__dict__','__reduce_ex__','__getitem__','__loader__','__doc__','__weakref__','__enter__','__exit__','__sub__','__mul__',\
        '__floordiv__','__truediv__','__mod__','__pow__','__lt__','__le__','__eq__','__ne__','__ge__','__gt__','__iadd__','__isub__',\
        '__imul__','__ifloordiv__','__idiv__','__itruediv__','__future__','__imod__','__ipow__','__ilshift__','__irshift__','__iand__',\
        '__ior__','__ixor__','.txt','txt','ag.txt','ag.t','g.t','__main__','__prepare__','__init_subclass__','currentframe','cmd','shell','bash',\
        'import','@','__name__']

def remove_non_ascii(text: str) -> str:
    return ''.join(char for char in text if ord(char) < 128)

class PythonRunner:

    def __init__(self, code, args=""):
        self.code = code
        self.args = args
        self.process = None
        self.output = []
        self.running = False
        self.temp_file = None
        self.start_time = None

    def extract_names(self, node):
        names = []
        while True:
            if isinstance(node, ast.Attribute):
                names.append(node.attr)
                node = node.value
            elif isinstance(node, ast.Call):
                node = node.func
            elif isinstance(node, ast.Subscript):
                node = node.value
            elif isinstance(node, ast.Name):
                names.append(node.id)
                break
            else:
                break
        return list(reversed(names))

    def validate_code(self):
        try:
            if len(self.code) > int(os.environ.get('MAX_CODE_SIZE', 1024)):
                return False, "代码过长"

            tree = ast.parse(self.code)

            banned_modules = ['os','sys','subprocess','shlex','pty','popen','shutil','platform','ctypes','cffi','io','importlib','linecache','inspect','builtins',\
                              'yaml','fcntl','functools','itertools','operator','readline','getpass','pprint','pipes','pathlib','pdb','Path','codecs','fileinput',\
                            'mmap','runpy','difflib','tempfile','glob','gc','threading','multiprocessing','dis','logging','_thread','atexit','urllib','request',\
                            'self','modules','help','warnings','pydoc','load_module','object','bytes','weakref','reprlib','encode','future','uuid','multi','posix',\
                            'CGIHTTPServer','cgitb','compileall','dircache','doctest', 'dumbdbm', 'filecmp','ftplib','gzip','getopt','gettext','httplib','popen2',\
                            'imputil','macpath','mailbox','mailcap','mhlib','mimetools','mimetypes','modulefinder','netrc','new','optparse','SimpleHTTPServer',\
                            'posixfile','profile','pstats','py_compile','pyclbr','rexec','SimpleXMLRPCServer', 'site', 'smtpd', 'socket', 'SocketServer',\
                            'sysconfig', 'tabnanny', 'tarfile', 'telnetlib','Tix', 'trace', 'turtle', 'urllib', 'urllib2','user', 'uu', 'webbrowser', 'whichdb',\
                            'zipfile', 'zipimport','__main__','__prepare__','__init_subclass__','currentframe','timeit']

            banned_functions = ['eval','exec','compile','input','__import__','open','file','execfile','reload','globals','items','keys','values','getline',\
                                'getlines','isinstance','__build_class__','help','type','super','getattr','setattr','vars','property','staticmethod',\
                                'classmethod','dir','object','read_text','__subclasses__','fileno','get_data','locals','get','_current_frames','f_locals',\
                                'f_globals','f_back','settrace','setprofile','tb_frame','__traceback__','tb_next','_getframe','f_code','co_consts',\
                                'co_names','basicConfig','get_objects','startswith','dumps','request','urlopen','response','get_content','decode','self',\
                                'modules','environ','breakpointhook','set_trace','interaction','gi_frame','stdout','stderr','stdin','StringIO','fork_exec',\
                                'path','_Printer__filenames','f','__main__','__prepare__','__init_subclass__','currentframe','timeit']

            banned_methods = ['system','popen','spawn','execv','execl','execve','execlp','execvp','chdir','kill','remove','unlink','rmdir','mkdir','makedirs',\
                              'removedirs','read','write','readlines','writelines','load','loads','dump','dumps','get_data','get_source','get_code','load_module',\
                            'exec_module','items','keys','values','getline','getlines','__globals__','__dict__','__build_class__','help','type','super',\
                            'getattr','setattr','vars','property','staticmethod','classmethod','dir','object','read_text','__subclasses__','__bases__',\
                            '__class__','fileno','ACCESS_READ','locals','get','_current_frames','f_locals','f_globals','f_back','settrace','setprofile',\
                            'tb_frame','__traceback__','tb_next','_getframe','f_code','co_consts','co_names','basicConfig','get_objects','interaction',\
                            'startswith','request','urlopen','response','get_content','decode','self','modules','environ','breakpointhook','set_trace',\
                            'gi_frame','stdout','stderr','stdin','StringIO','reload','fork_exec','path','_Printer__filenames','f','__main__','__prepare__',\
                            '__init_subclass__','currentframe','timeit']

            dangerous_attributes = ['__class__','__base__','__bases__','__mro__','__subclasses__','__globals__','__builtins__','__getattribute__',\
                                    '__getattr__','__setattr__','__delattr__','__call__','__dict__','__reduce_ex__','__getitem__','__loader__',\
                                    '__doc__','__weakref__','__enter__','__exit__','__sub__','__mul__','__floordiv__','__truediv__','__mod__',\
                                    '__pow__','__lt__','__le__','__eq__','__ne__','__ge__','__gt__','__iadd__','__isub__','__imul__','__ifloordiv__',\
                                    '__idiv__','__itruediv__','__future__','__imod__','__ipow__','__ilshift__','__irshift__','__iand__','__ior__',\
                                    '__ixor__','__main__','__prepare__','__init_subclass__','__name__']

            banned_functions += banned_modules + dangerous_attributes
            banned_methods += banned_modules + dangerous_attributes

            for node in ast.walk(tree):

                if isinstance(node, ast.Import):
                    for name in node.names:
                        if name.name.split('.')[0] in banned_modules:
                            return False, f"禁止导入模块: {name.name}"

                elif isinstance(node, ast.ImportFrom):
                    if node.module and node.module.split('.')[0] in banned_modules:
                        return False, f"禁止从模块导入: {node.module}"

                elif isinstance(node, ast.Call):
                    chain = self.extract_names(node)
                    for name in chain:
                        if name in banned_functions or name in banned_methods:
                            return False, f"禁止调用: {name}"

                elif isinstance(node, ast.Attribute):
                    chain = self.extract_names(node)
                    for name in chain:
                        if name in dangerous_attributes:
                            return False, f"禁止访问危险属性: {name}"

                elif isinstance(node, ast.Subscript):
                    chain = self.extract_names(node)
                    if '__subclasses__' in chain:
                        return False, "禁止访问__subclasses__"

                elif isinstance(node, ast.With):
                    for item in node.items:
                        if isinstance(item.context_expr, ast.Call):
                            chain = self.extract_names(item.context_expr)
                            if 'open' in chain:
                                return False, "禁止文件操作"

            return True, "代码验证通过"

        except SyntaxError as e:
            return False, f"语法错误: {str(e)}"
        except Exception as e:
            return False, f"验证错误: {str(e)}"

    def create_script(self):
        try:
            self.temp_file = tempfile.NamedTemporaryFile(mode='w', suffix='.py', dir='/tmp', delete=False)

            wrapper = """
import sys
import os
if(os.environ.get('GZCTF_FLAG', '')!=''):
    flag_content = os.environ.get('GZCTF_FLAG', '')
    try:
        with open('/flag.txt', 'w') as f:
            f.write(flag_content)
    except:
        pass
else:
    with open('/flag.txt', 'r') as f:
        flag_content=f.read()
os.environ['GZCTF_FLAG'] = ''
def safe_exec():
    try:
        flag_content = ""
{indented_code}
        return 0
    except SystemExit as e:
        return e.code if isinstance(e.code, int) else 0
    except Exception as e:
        print(f"执行错误: {{e}}", file=sys.stderr)
        return 1

sys.argv = ['sandbox.py']
exit_code = safe_exec()
exit()
"""
            indented_code = '\n'.join(['        ' + line for line in self.code.split('\n')]).replace('flag.txt','').replace("GZCTF_FLAG","").replace("@","")
            while True:
                save_code = indented_code
                indented_code = remove_non_ascii(indented_code).replace('flag.txt','').replace("GZCTF_FLAG","").replace("@","")
                for _ in banned:
                    indented_code = indented_code.replace(_,"")
                if(save_code==indented_code):
                    break
            self.temp_file.write(wrapper.format(indented_code=indented_code))
            self.temp_file.flush()
            os.chmod(self.temp_file.name, 0o755)
            return self.temp_file.name

        except Exception as e:
            raise Exception(f"创建脚本失败: {str(e)}")

    def run(self):
        try:
            is_valid, message = self.validate_code()
            if not is_valid:
                self.output.append(f"验证失败: {message}")
                return False

            script_path = self.create_script()
            cmd = ['python', script_path]
            if self.args:
                cmd.extend(self.args.split())

            self.process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE, text=True, bufsize=1, universal_newlines=True)
            self.running = True
            self.start_time = time.time()

            def read_output():
                while self.process and self.process.poll() is None:
                    try:
                        line = self.process.stdout.readline()
                        if line:
                            socketio.emit('output', {'data': line})
                    except:
                        break

                stdout, stderr = self.process.communicate()
                if stdout:
                    socketio.emit('output', {'data': stdout})
                if stderr:
                    socketio.emit('output', {'data': stderr})
                socketio.emit('process_end', {'pid': self.process.pid})

            threading.Thread(target=read_output, daemon=True).start()
            return True

        except Exception as e:
            self.output.append(f"运行失败: {str(e)}")
            return False

    def send_input(self, data):
        if self.process and self.process.poll() is None:
            try:
                self.process.stdin.write(data + '\n')
                self.process.stdin.flush()
                return True
            except:
                return False
        return False

    def terminate(self):
        if self.process and self.process.poll() is None:
            self.process.terminate()
            self.process.wait(timeout=5)
            self.running = False
            if self.temp_file:
                try:
                    os.unlink(self.temp_file.name)
                except:
                    pass
            return True
        return False

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/run', methods=['POST'])
def run_code():
    data = request.json
    code = data.get('code', '')
    args = data.get('args', '')
    runner = PythonRunner(code, args)
    pid = secrets.token_hex(8)
    active_processes[pid] = runner
    success = runner.run()
    if success:
        return jsonify({'success': True,'pid': pid,'message': '进程已启动'})
    else:
        return jsonify({'success': False,'message': '启动失败'})

@app.route('/api/terminate', methods=['POST'])
def terminate_process():
    data = request.json
    pid = data.get('pid')
    if pid in active_processes:
        active_processes[pid].terminate()
        del active_processes[pid]
        return jsonify({'success': True})
    return jsonify({'success': False,'message': '进程不存在'})

@app.route('/api/send_input', methods=['POST'])
def send_input():
    data = request.json
    pid = data.get('pid')
    input_data = data.get('input', '')
    if pid in active_processes:
        success = active_processes[pid].send_input(input_data)
        return jsonify({'success': success})
    return jsonify({'success': False})

@socketio.on('connect')
def handle_connect():
    emit('connected', {'data': 'Connected'})

@socketio.on('disconnect')
def handle_disconnect():
    pass

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=False, allow_unsafe_werkzeug=True)
