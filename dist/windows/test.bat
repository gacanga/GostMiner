@echo off
REM test.bat - checks every GPU against the consensus hashes of GOSTcoin (gostd) and Bitmark (lyra2v2)
gostminer.exe --selftest
gostminer.exe --algo lyra2v2 --selftest
pause
