from flask import Flask
import random
from Crypto.Util.number import bytes_to_long, getPrime
import os
import time

app = Flask(__name__)

ACTUAL_FLAG = os.environ.get('GZCTF_FLAG', 'furryCTF{default_flag_here}')

def gcd(a, b):
    while b:
        a, b = b, a % b
    return a

flag = bytes_to_long(ACTUAL_FLAG.encode())
random.seed(flag)
p = getPrime(512, randfunc=random.randbytes)
q = getPrime(512, randfunc=random.randbytes)
N = p * q
phi = (p-1) * (q-1)

random.seed(flag+int(time.time()))
e = random.randint(1023, 65537)
while gcd(e, phi) != 1:
    e = random.randint(1023, 65537)

m = flag
c = pow(m, e, N)

@app.route('/')
def index():
    return f'''<html>
<head><title>GZRSA-furryCTF</title></head>
<body style="background-color: black; color: white; font-family: monospace; padding: 20px;">
<div style="border: 1px solid white; padding: 20px; word-wrap: break-word; overflow-wrap: break-word;">
请查收你本题的flag：<br><br>
N = {N}<br>
e = {e}<br>
c = {c}<br>
</div>
</body>
</html>'''

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)