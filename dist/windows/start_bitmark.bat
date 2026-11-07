@echo off
REM start_bitmark.bat - Bitmark (lyra2v2): replace YOUR_MARKS_ADDRESS, the pool host and port, then double-click.
set ADDRESS=YOUR_MARKS_ADDRESS
set WORKER=rig1
set POOL=pool.example.com:4034
if "%ADDRESS%"=="YOUR_MARKS_ADDRESS" (echo Edit start_bitmark.bat first: put your Bitmark address in ADDRESS. & pause & exit /b 1)
:loop
gostminer.exe --algo lyra2v2 --pool %POOL% --user %ADDRESS%.%WORKER% --pass x --log gostminer_bitmark.log
echo Miner stopped (exit code %ERRORLEVEL%), restart in 5 s (close this window to quit)
timeout /t 5 /nobreak >nul
goto loop
