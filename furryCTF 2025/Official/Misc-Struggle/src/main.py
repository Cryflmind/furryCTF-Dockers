from string import ascii_letters,digits
from sys import *
import io

stdin = io.TextIOWrapper(stdin.buffer, encoding='utf-8')
stdout = io.TextIOWrapper(stdout.buffer, encoding='utf-8')
stderr = io.TextIOWrapper(stderr.buffer, encoding='utf-8')

modules['os']='Forbidden'
modules['subprocess']='Forbidden'

def getattr(mod,com):
    pass
def help():
    pass

WELCOME = r'''
  ?__?
 /    \
|•ᴥ•|
| 0101 |
|H4CK3R|
 \____/                 
'''

print(WELCOME)
print("Well,I just banned letters,digits, '.' and ','")
print("And also banned getattr() and help() by replacing it")
print("And I banned os,subprocess module by pre-load it as strings")
print("Just give up~")
print("Or you still wanna try?")
input_data = input("> ")
if any([i in ascii_letters+".,"+digits for i in input_data]):
    print("No,no,no~You can't pass it~")
    exit(0)
try:
    print("Result: {}".format(eval(input_data)))
except Exception as e:
    print(f"Result: {e}")