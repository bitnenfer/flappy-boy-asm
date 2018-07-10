#!/usr/bin/python

import os

# Disable Wine debug warnings
os.environ["WINEDEBUG"] = "-all"

output = "flappyboy"
out_path = "./build/"
build = out_path + output
rgbds_path = "../rgbds/"
abisx = "wine " + rgbds_path + "abisx.exe /n /o /v"
rgbfix = rgbds_path + "rgbfix -p0 -v"

abisx_cmd = abisx + " " + build + ".isx /b" + build + ".gb /s" + build + ".sym"
rgbfix_cmd = rgbfix + " " + build + ".gb"

os.system("python build_osx.py")
os.system(abisx_cmd)
os.system(rgbfix_cmd)
os.system("kill $(pgrep wine)")
