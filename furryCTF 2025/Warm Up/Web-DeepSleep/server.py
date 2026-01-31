#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sys
import json
import logging
import pexpect
import os

import tornado.ioloop
import tornado.web

reload(sys)
sys.setdefaultencoding('utf-8')

PORT = 8000
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger('DeepSleepAPI')

class DeepSleepProcess(object):
    def __init__(self, program="DeepSleep.py"):
        try:
            self.child = pexpect.spawn("python -u " + program, timeout=5)
            self.child.setecho(False)
            
            try:
                index = self.child.expect([pexpect.EOF, pexpect.TIMEOUT, '.+'], timeout=5)
                if index == 2:
                    welcome = self.child.after
                    logger.info("[DeepSleep Init] 欢迎信息: %s", welcome)
                else:
                    logger.warning("[DeepSleep Init] 未收到欢迎信息")
            except Exception as e:
                logger.error("[DeepSleep Init] 初始化异常: %s", str(e))
        except Exception as e:
            logger.error("[DeepSleep Process] 启动失败: %s", str(e))
            raise RuntimeError("DeepSleep 进程启动失败")


    def ask(self, question_unicode):
        BLACKLIST = ['flag', 'cat', 'import', 'eval', 'exec', 'system', 'os.', 'subprocess','open', 'read', 'write', 'rm', 'delete', 'shutdown', 'reboot', 'python','php', 'bash', 'shell', 'command', 'curl', 'wget', 'ftp', 'telnet','ssh', 'scp', 'chmod', 'chown', 'sudo', 'su', 'admin', 'root', 'password','token', 'key', 'secret', 'config', 'env', 'environment', 'proc', 'sys','dev', 'etc', 'var', 'tmp', 'home', 'bin', 'sbin', 'usr', 'lib', 'etc','os','ls']
        try:
            try:
                self.child.read_nonblocking(size=4096, timeout=0.1)
            except:
                pass
            for banned in BLACKLIST:
                question_unicode=question_unicode.replace(banned,"")
            while("flag" in question_unicode):
                question_unicode=question_unicode.replace("flag","")
            question_str = question_unicode.encode('utf-8')
            logger.debug("[ask] 发送: %r", question_str)
            self.child.sendline(question_str)

            self.child.expect('\n', timeout=2)
            response = self.child.before.strip()
            
            logger.debug("[ask] 原始响应: %r", response)
            
            try:
                response_unicode = response.decode('utf-8')
            except:
                response_unicode = response
            
            logger.info("[ask] DeepSleep 返回: %s", response_unicode)
            
            return response_unicode

        except pexpect.TIMEOUT:
            return u"与 DeepSleep 通信超时"
        except pexpect.EOF:
            return u"DeepSleep 进程已退出"
        except Exception as e:
            return u"与 DeepSleep 通信出错: " + unicode(e)

try:
    deep_sleep = DeepSleepProcess("DeepSleep.py")
    logger.info("DeepSleep 进程初始化成功")
except Exception as e:
    logger.error("DeepSleep 初始化失败: %s", str(e))
    deep_sleep = None

class BaseHandler(tornado.web.RequestHandler):
    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.set_header("Access-Control-Allow-Headers", "Content-Type, X-Requested-With")
        self.set_header("Content-Type", "application/json; charset=utf-8")

    def options(self):
        self.set_status(204)
        self.finish()

class MainHandler(BaseHandler):
    def get(self):
        try:
            with open(os.path.join(BASE_DIR, 'DeepSleep.html'), 'rb') as f:
                content = f.read()
            
            self.set_header('Content-Type', 'text/html; charset=utf-8')
            self.write(content)
            
        except IOError:
            self.set_status(404)
            self.write({
                'status': 'error',
                'message': 'DeepSleep.html 文件未找到'
            })
        except Exception as e:
            self.set_status(500)
            self.write({
                'status': 'error',
                'message': '加载 DeepSleep.html 出错: ' + str(e)
            })
    
    def post(self):
        """处理用户查询请求"""
        try:
            data = tornado.escape.json_decode(self.request.body)
            user_input = data.get('input', u'无输入')
            
            if not isinstance(user_input, unicode):
                user_input = user_input.decode('utf-8', 'ignore')
            
            logger.info("收到用户输入: %s", user_input)
            
            if not deep_sleep:
                response_data = {
                    'status': 'error',
                    'message': 'DeepSleep 进程未初始化'
                }
                self.set_status(500)
            else:
                result_unicode = deep_sleep.ask(user_input)
                
                response_data = {
                    'status': 'success',
                    'input_received': user_input,
                    'processed_result': result_unicode,
                    'message': u'来自 DeepSleep 的回复'
                }
            
            self.write(response_data)
            
        except Exception as e:
            logger.error("处理 POST 请求出错: %s", str(e))
            error_msg = {
                'status': 'error',
                'message': str(e),
                'chinese_test': u'错误信息中文测试'
            }
            self.set_status(500)
            self.write(error_msg)

def make_app():
    """创建 Tornado 应用并设置静态文件路径"""
    return tornado.web.Application([
        (r"/", MainHandler)
    ])

if __name__ == "__main__":
    # 配置应用
    app = make_app()
    app.listen(PORT)
    
    logger.info("启动 DeepSleep 后端服务器在端口 %d...", PORT)
    logger.info("按 Ctrl+C 停止服务器")

    # 启动主循环
    tornado.ioloop.IOLoop.current().start()