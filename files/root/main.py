#!/usr/bin/python

import time
import signal
import sys

flag=True

def handle_signal(signum, frame):
    flag=False

signal.signal(signal.SIGHUP, handle_signal)
signal.signal(signal.SIGINT, handle_signal)
signal.signal(signal.SIGQUIT, handle_signal)
signal.signal(signal.SIGTERM, handle_signal)

print("Start")

while flag:
    time.sleep(1)

print("Shutdown container")