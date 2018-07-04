@echo off

cls

setlocal EnableDelayedExpansion

set PATH=%PATH%;"C:\dev\INTELLIGENT SYSTEMS\CGB-SDK"

set OUTPUT=flappyboy
set ISAS=isas32
set ISLK=islk32
set CVTISX=abisx
set GBFIX=rgbfix
set PROJPATH="C:\dev\gameboy\flappy-boy-asm"
set CODEPATH=src
set OBJPATH=build
set OUTPATH=build
set ISASFLAGS=-isdmg -g -nologo -us -b 262144 -I include
set ISLKFLAGS=-nologo -us -b 262144 -map %OUTPATH%\%OUTPUT%.map
set ISXFLAGS=/n /o /v
set GBFIXFLAGS=-p0 -v
set OBJFILES=

mkdir build

echo Assembling...

for %%I in (%PROJPATH%\%CODEPATH%\*.s) do (
    %ISAS% %ISASFLAGS% %%~I -o %OBJPATH%\%%~nI.o
)

echo Linking...

for %%I in (%PROJPATH%\%OBJPATH%\*.o) do (
	set OBJFILES=!OBJFILES! %OBJPATH%\%%~nI.o
)


%ISLK% %ISLKFLAGS% %OBJFILES% -o %OUTPATH%\%OUTPUT%.isx

%CVTISX% %ISXFLAGS% %OUTPATH%\%OUTPUT%.isx /b%OUTPATH%\%OUTPUT%.gb /s%OUTPATH%\%OUTPUT%.sym
%GBFIX% %GBFIXFLAGS% %OUTPATH%\%OUTPUT%.gb
