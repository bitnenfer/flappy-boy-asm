#!/usr/bin/python

import os

# Disable Wine debug warnings
os.environ["WINEDEBUG"] = "-all"
bgb = "wine ../bgb/bgb.exe -br 0100 -rom ./build/flappyboy.gb"

os.system(bgb);
