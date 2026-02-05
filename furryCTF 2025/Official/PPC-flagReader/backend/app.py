from flask import Flask, jsonify
import os
import base64
import random
import time

app = Flask(__name__)

# 从环境变量读取flag
def init_flag():
    flag = os.environ.get('GZCTF_FLAG', 'FLAG{default_flag_here}')
    flag_base64 = base64.b16encode(flag.encode()).decode()
    flag_base64 = base64.b16encode(flag_base64.encode()).decode()
    
    with open('/app/flag.txt', 'w') as f:
        f.write(flag_base64)
    
    return flag_base64

# 初始化flag
try:
    flag_content = init_flag()
    print(f"Flag初始化成功，长度: {len(flag_content)}")
except Exception as e:
    print(f"Flag初始化失败: {e}")
    flag_content = "default"

@app.route('/api/flag/length', methods=['GET'])
def get_flag_length():
    try:
        time.sleep(random.uniform(0.05, 0.2))
        return jsonify({
            'length': len(flag_content),
            'status': 'success'
        })
    except Exception as e:
        return jsonify({'error': str(e), 'status': 'error'}), 500

@app.route('/api/flag/char/<int:position>', methods=['GET'])
def get_flag_char(position):
    try:
        time.sleep(random.uniform(0.05, 0.2))
        
        if position < 1 or position > len(flag_content):
            return jsonify({
                'error': '位置超出范围',
                'status': 'error'
            }), 400
        
        char = flag_content[position - 1]
        return jsonify({
            'position': position,
            'char': char,
            'total_length': len(flag_content),
            'is_base64': True,
            'status': 'success'
        })
    except Exception as e:
        return jsonify({'error': str(e), 'status': 'error'}), 500

@app.route('/api/auth/init', methods=['POST'])
def init_auth():
    time.sleep(random.uniform(0.05, 0.1))
    return jsonify({
        'session_initialized': True,
        'status': 'success'
    })

@app.route('/api/auth/status', methods=['GET'])
def check_auth_status():
    time.sleep(random.uniform(0.05, 0.1))
    return jsonify({
        'authenticated': True,
        'status': 'success'
    })

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'flag_length': len(flag_content)})

if __name__ == '__main__':
    print("启动 Flask 应用...")
    app.run(host='0.0.0.0', port=5000, debug=False)
