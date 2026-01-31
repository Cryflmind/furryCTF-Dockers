#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys

# 欢迎信息
print "你好，我是DeepSleep！一个非常喜欢睡觉的AI语言模型！快来和我对话吧！"
sys.stdout.flush()
print ""
sys.stdout.flush()
flag=0
while True:
    try:
        question = input("").decode('utf-8')
    except Exception:
        question = u"服务器繁忙，请稍后再试。"

    try:
        # 确保是 unicode
        if not isinstance(question, unicode):
            question = question.decode("utf-8", "ignore")
        # 执行替换
        response = (question
                    .replace(u"请问", u"")
                    .replace(u"问", u"")
                    .replace(u"吗", u"呀")
                    .replace(u"你", u"我")
                    .replace(u"？", u"！"))
        if("furryCTF" in response):
            print "不可以哼唧！"
            flag=1
        # 输出 UTF-8
        if(not flag):
            print response.encode("utf-8")
        else:
            flag=0
        sys.stdout.flush()
    except Exception as e:
        print u"错误: {}".format(e).encode("utf-8")
        sys.stdout.flush()