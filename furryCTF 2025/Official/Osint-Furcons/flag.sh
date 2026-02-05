#!/bin/bash
sed -i "s/furryCTF{Test_Flag}/$GZCTF_FLAG/g" /var/www/html/check.php
unset GZCTF_FLAG
export GZCTF_FLAG=""
