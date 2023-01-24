@ECHO OFF
set USERNAME=<username>
set PASSWORD=<password>
set PROXY=<proxy:port>
set HTTPS_PROXY=http://%USERNAME%:%PASSWORD%@%PROXY%
::dir kubeconfig /b /a-d

setlocal
cd kubeconfig

SET index=1

SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%f IN (*.*) DO (
   SET file!index!=%%f
   ECHO !index! - %%f
   SET /A index=!index!+1
)

SETLOCAL DISABLEDELAYEDEXPANSION

SET /P selection="select file by number:"

SET file%selection% >nul 2>&1

IF ERRORLEVEL 1 (
   ECHO invalid number selected   
   EXIT /B 1
)

CALL :RESOLVE %%file%selection%%%

ECHO selected file name: %file_name%
CALL :SETKUBE %%file_name%%
endlocal
GOTO :EOF


:RESOLVE
SET file_name=%1
GOTO :EOF



:SETKUBE
cd ..
start cmd /k "set KUBECONFIG=kubeconfig\%1% && kubectl config get-contexts" 
GOTO :EOF
