@echo off
REM start_pool.bat - GOSTcoin: replace YOUR_GST_ADDRESS, the pool host and port, then double-click.
set ADDRESS=YOUR_GST_ADDRESS
set WORKER=rig1
set POOL=pool.example.com:4033
if "%ADDRESS%"=="YOUR_GST_ADDRESS" (echo Edit start_pool.bat first: put your GOSTcoin address in ADDRESS. & pause & exit /b 1)
:loop
gostminer.exe --pool %POOL% --user %ADDRESS%.%WORKER% --pass x --log gostminer.log
echo Miner stopped (exit code %ERRORLEVEL%), restart in 5 s (close this window to quit)
timeout /t 5 /nobreak >nul
goto loop
