@echo off

rem =====
rem For more information on ScriptTiger and more ScriptTiger scripts visit the following URL:
rem https://scripttiger.github.io/
rem Or visit the following URL for the latest information on this ScriptTiger script:
rem https://github.com/ScriptTiger/Randomness
rem =====

rem The %random% variable will give you 15 random bits (32767 total, 1,2,4,..,16384)

rem For 32 bits of random (positve and negative):
rem set /a "(%random%<<30)+(%random%<<15)+%random%"

rem For 31 bits of random (positive only):
rem set /a "(%random%<<16)+(%random%<<1)+(%random%&1)"


rem Accept command-line arguments
if not "%~1"=="" goto %1

rem Interactive menu
:choice
echo 1] Toss a coin
echo 2] Roll some dice
echo 3] Pick a number
echo 4] Rock, paper, scissors
echo 5] Random Generator
echo X] Exit
choice /c 12345x /n
cls
goto %errorlevel%

rem Toss a coin
:1
set /a toss="%random%&1"
if %toss%==1 (set toss=heads) else (set toss=tails)
echo The coin lands on %toss%!
if not "%~1"=="" exit /b
goto choice

rem Roll X-sided die Y times
:2
if "%1"=="" (
	set /p dice=Number of rolls? 
	set /p sides=Number of sides? 
) else (
	set dice=%2
	set sides=%3
)
set rolls=0
setlocal ENABLEDELAYEDEXPANSION
for /l %%0 in (1,1,%dice%) do (
	for /l %%a in (1,1,%sides%) do set /a side_%%a="(!random!<<30)+(!random!<<15)+!random!"
	call :sort side roll
	echo Roll %%0 is !roll!.
	set /a rolls=!rolls!+!roll!
)
echo Total rolled is !rolls!.
for /l %%0 in (1,1,%sides%) do set side_%%0=
endlocal
if not "%~1"=="" exit /b
goto choice

rem Pick a number from X to Y
:3
if "%1"=="" (
	set /p start=What number should your range start at? 
	set /p end=What number should your range end at?  
) else (
	set start=%2
	set end=%3
)
setlocal ENABLEDELAYEDEXPANSION
for /l %%0 in (%start%,1,%end%) do set /a num_%%0="(!random!<<30)+(!random!<<15)+!random!"
call :sort num num
echo The number picked between %start% and %end% is %num%^^!
for /l %%0 in (%start%,1,%end%) do set num_%%0=
endlocal
if not "%~1"=="" exit /b
goto choice

rem Rock, paper, scissors
:4
setlocal ENABLEDELAYEDEXPANSION
for %%0 in (rps_Rock rps_Paper rps_Scissors) do set /a %%0="(!random!<<30)+(!random!<<15)+!random!"
call :sort rps rps
echo %rps%^^^!
for %%0 in (rps_Rock rps_Paper rps_Scissors) do set %%0=
endlocal
if not "%~1"=="" exit /b
goto choice

rem Matrix
:5
setlocal ENABLEDELAYEDEXPANSION
if "%1"=="" (
	echo 1] 0 through 9
	echo 2] Only 1 and 0
	echo X] Exit
	choice /c 12x /n
	set choice=!errorlevel!
) else (
	set choice=%2
)
cls
if %choice%==1 endlocal&cmd /v:on /c"for /l %%0 in () do @set /a !random!"
if %choice%==2 endlocal&cmd /v:on /c"for /l %%0 in () do @set /a !random!^&1"
endlocal
if not "%~1"=="" exit /b
goto choice

rem Exit
:6
exit /b

rem Sort a variable set and return the bottom value
:sort
for /f "tokens=2" %%0 in (
	'^(
		for /f "tokens=2,3 delims=_=" %%a in ^(
			^'set %1_^'
		^) do @echo %%b %%a
	^) ^| sort'
) do set %2=%%0
exit /b