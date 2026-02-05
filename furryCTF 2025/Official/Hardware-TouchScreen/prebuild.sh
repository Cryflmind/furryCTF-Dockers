python build_touch_script.py $GZCTF_FLAG
unset GZCTF_FLAG
export GZCTF_FLAG=""

python ctf_touch_server.py --config touches.ctf.json