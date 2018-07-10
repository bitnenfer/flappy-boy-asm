#!/usr/bin/python

import os

# Disable Wine debug warnings
os.environ["WINEDEBUG"] = "-all"
bgb = "wine ../bgb/bgb.exe ./build/flappyboy.gb"

os.system(bgb);
