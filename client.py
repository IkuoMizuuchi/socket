# coding:utf-8
# client.py
# $Id$
# 
# Ikuo Mizuuchi
# 
# - Scratch 2018/05/10
# 
# - Description
#   This program is for TCP/IP communication

import socket

DEFAULT_PORT = 9000

def connectHost(host=socket.gethostbyname(socket.gethostname()),
                port=DEFAULT_PORT):
    c = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    c.connect((host,port))
    return c

