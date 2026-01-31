from flask import Flask, session, request, render_template, render_template_string, redirect, url_for
import os
import sys
import random

try:
    import config
except ImportError:
    sys.path.append(os.getcwd())
    import config

app = Flask(__name__)
app.config.from_object(config)

ANNOUNCEMENTS = [
    "2024年Q4财务报告",
    "关于加强内部密码强度的通知",
    "安全补丁更新日志 (v3.1.0)",
    "行政部：春节放假安排"
]

@app.route('/')
def index():
    return render_template('home.html')

@app.route('/search')
def search():
    query = request.args.get('q', '')

    results = [a for a in ANNOUNCEMENTS if query.lower() in a.lower()] if query else []
    
    return render_template('home.html', results=results, query=query)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        if username == 'admin' and password == 'Nexusadmin2025!@#':

             return render_template('login.html', error="错误：该账户已启用多因素认证 (MFA)，请使用硬件密钥登录。")
        
        if "'" in username:

            return render_template('login.html', error="System Warning: Illegal character detected in input stream.")
            
        return render_template('login.html', error="用户名或密码错误")
        
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if session.get('role') == 'admin':

        username = request.args.get('u', 'Administrator')
        template = f"""
        {{% extends "base.html" %}}
        {{% block content %}}
        <div class="alert alert-success">
            <h2>欢迎回到管理控制台, {username}!</h2>
            <p>系统完整性检查：通过</p>
            <p>Flag 服务状态：待机</p>
        </div>
        {{% endblock %}}
        """
        return render_template_string(template)
    else:
        return redirect(url_for('login'))

if __name__ == '__main__':
    #app.run(host='0.0.0.0', port=5000)
    pass
