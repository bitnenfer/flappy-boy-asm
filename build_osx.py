#!/usr/bin/python

import os
import shutil

output = "flappyboy"
out_path = "./build/"
is_path = "../IS/cgb-sdk/"
isas32 = "wine " + is_path + "isas32.exe"
islk32 = "wine " + is_path + "islk32.exe"
asm_flags = "-isdmg -g -nologo -us -b 262144 -I include"
lnk_flags = "-nologo -us -b 262144 -map " + out_path + output + ".map"
code_path = "./src/"
obj_path = "./obj/"

# Create build folder
os.system("mkdir -p " + out_path)
os.system("mkdir -p " + obj_path)

# Disable Wine debug warnings
os.environ["WINEDEBUG"] = "-all"

print "Assembling..."

files = os.listdir(code_path)
s_files = [i for i in files if i.endswith(".s")]

for file in s_files:
	cmd = isas32 + " " + asm_flags + " " + code_path + file + " -o " + obj_path + file + ".o"
	os.system(cmd)

print "Linking..."

files = os.listdir(obj_path)
o_files = [i for i in files if i.endswith(".o")]
obj_files = ""

for file in o_files:
	obj_files = obj_files + " " + obj_path + file


link_cmd = islk32 + " " + lnk_flags + " " + obj_files + " -o " + out_path + output + ".isx"

os.system(link_cmd)
os.system("kill $(pgrep wine)")
shutil.rmtree(obj_path)
