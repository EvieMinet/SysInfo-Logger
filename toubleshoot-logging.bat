@echo off
REM This script is used to troubleshoot logging issues in a Windows environment.
SET HOSTNAME=%COMPUTERNAME%
SET TIMESTAMP=%DATE%_%TIME%
SET TIMESTAMP=%TIMESTAMP::=-%
SET TIMESTAMP=%TIMESTAMP:/=-%
SET TIMESTAMP=%TIMESTAMP: =_%
SET TIMESTAMP=%TIMESTAMP:.=-%
SET LOGFILE=.\%HOSTNAME%_%TIMESTAMP%_log-output.txt

REM PROPERTY OF CONTEC AMERICAS, INC.
REM THIS FILE IS FOR INTERNAL USE ONLY AND MAY NOT BE DISTRIBUTED OUTSIDE OF CONTEC AMERICAS, INC.
REM THIS FILE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
REM IN NO EVENT SHALL CONTEC AMERICAS, INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

REM DEVELOPER: EVANGELINE MINET
REM CONTACT: evangeline.minet@us.contec.com
REM DATE: 2023-10-03
REM VERSION: 0.1.0
REM DESCRIPTION: This script collects various system information and logs it to a file for troubleshooting purposes.
REM USAGE: Run this script in a command prompt with administrative privileges to collect system information.
REM NOTE: Ensure that the script is run in a directory where you have write permissions to create the log file.

SET MAILTO="evangeline.minet@us.contec.com"

REM Header Information
REM This section creates a log file with the current date, time, and hostname.
echo ================================================================ > %LOGFILE%
echo START OF LOG >> %LOGFILE%
echo Date: %DATE% >> %LOGFILE%
echo Time: %TIME% >> %LOGFILE%
echo Hostname: %HOSTNAME% >> %LOGFILE%
echo ================================================================ >> %LOGFILE%
echo Starting debugging log...
echo. >> %LOGFILE%
echo.

echo STARTING SYSTEM INFORMATION COLLECTION...

REM System Information
echo =========================[  SYSTEMINFO  ]========================= >> %LOGFILE%
echo -[1/10] Running 'systeminfo' command...
systeminfo >> %LOGFILE%
echo. >> %LOGFILE%

REM Registry Query for Installed Applications
echo =========================[  REG QUERY  ]========================= >> %LOGFILE%
echo -[2/10] Running 'reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' command...
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall >> %LOGFILE%
echo. >> %LOGFILE%

REM Tasklist for Running Processes
echo =========================[  TASKLIST  ]========================= >> %LOGFILE%
echo -[3/10] Running 'tasklist' command...
tasklist >> %LOGFILE%
echo. >> %LOGFILE%

REM Driver Information
echo =========================[  DRIVERQUERY  ]========================= >> %LOGFILE%
echo -[4/10] Running 'driverquery' command...
driverquery >> %LOGFILE%
echo. >> %LOGFILE%

REM Environment Variables
echo =========================[  ENVIRONMENT VARIABLES  ]========================= >> %LOGFILE%
echo -[5/10] Listing all environment variables...
set >> %LOGFILE%
echo. >> %LOGFILE%

REM System Drives and Volumes
echo =========================[  SYSTEM DRIVES  ]========================= >> %LOGFILE%
echo -[6/10] Running 'fsutil fsinfo drives' command...
fsutil fsinfo drives >> %LOGFILE%
REM for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
REM     if exist %%d:\ (
REM         echo Drive %%d:\ >> %LOGFILE%
REM         vol %%d:\ >> %LOGFILE%
REM         dir %%d:\ >> %LOGFILE%
REM     )
REM )
echo. >> %LOGFILE%

REM Services Information
echo =========================[  SERVICES  ]========================= >> %LOGFILE%
echo -[7/10] Running 'sc query' command...
sc query >> %LOGFILE%
echo. >> %LOGFILE%

REM Event Log Errors
echo =========================[  EVENT LOG ERRORS  ]========================= >> %LOGFILE%
echo -[8/10] Fetching the last 10 error events from the System event log...
wevtutil qe System /q:"*[System[(Level=2)]]" /f:text /c:10 >> %LOGFILE%
echo. >> %LOGFILE%

REM Installed Programs
echo =========================[  INSTALLED PROGRAMS  ]========================= >> %LOGFILE%
echo -[9/10] Fetching installed programs using PowerShell...
powershell "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | Format-Table -AutoSize" >> %LOGFILE%
echo. >> %LOGFILE%

REM Hardware Information
echo =========================[  HARDWARE INFORMATION  ]========================= >> %LOGFILE%
echo -[10/10] Fetching hardware information using PowerShell...

echo -Processor Information: >> %LOGFILE%
powershell "Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed | Format-List" >> %LOGFILE%
echo. >> %LOGFILE%

echo -Memory Information: >> %LOGFILE%
powershell "Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object Capacity, Speed, Manufacturer, PartNumber | Format-List" >> %LOGFILE%
echo. >> %LOGFILE%

echo -Disk Drive Information: >> %LOGFILE%
powershell "Get-CimInstance -ClassName Win32_DiskDrive | Select-Object Model, Size, InterfaceType, MediaType | Format-List" >> %LOGFILE%
echo. >> %LOGFILE%

echo -BIOS Information: >> %LOGFILE%
powershell "Get-CimInstance -ClassName Win32_BIOS | Select-Object Manufacturer, Name, Version, ReleaseDate, SerialNumber | Format-List" >> %LOGFILE%
echo. >> %LOGFILE%

echo -Motherboard Information: >> %LOGFILE%
powershell "Get-CimInstance -ClassName Win32_BaseBoard | Select-Object Manufacturer, Model, Name, SKU, Product, Version, SerialNumber | Format-List" >> %LOGFILE%
echo. >> %LOGFILE%

echo.
echo ================================================================>> %LOGFILE%
echo ================================================================>> %LOGFILE%
echo. >> %LOGFILE%

echo.
echo STARTING NETWORK INFORMATION COLLECTION...

REM Network Information
echo =========================[  IPCONFIG  ]========================= >> %LOGFILE%
echo Running 'ipconfig /all' command...
ipconfig /all >> %LOGFILE%
echo. >> %LOGFILE%

echo =========================[  NETSTAT  ]========================= >> %LOGFILE%
echo Running 'netstat -es' command...
netstat -es >> %LOGFILE%
echo. >> %LOGFILE%

echo =========================[  PING  ]========================= >> %LOGFILE%
echo Running 'ping -n 5'...
ping -n 5 8.8.8.8 >> %LOGFILE%
echo. >> %LOGFILE%

echo =========================[  NETSH  ]========================= >> %LOGFILE%
echo Running 'netsh interface ip show config' command...
netsh interface ip show config >> %LOGFILE%
echo. >> %LOGFILE%

echo =========================[  NETSH WLAN  ]========================= >> %LOGFILE%
echo Running 'netsh wlan show interfaces' command...
netsh wlan show interfaces >> %LOGFILE%
echo. >> %LOGFILE%

echo ================================================================= >>%LOGFILE%
echo END OF LOG >> %LOGFILE%
echo ================================================================= >> %LOGFILE%

echo.
echo.

REM Final Output
echo Log file created: %LOGFILE%
echo Please send the log file to %MAILTO% for further analysis.
echo.

echo Press any key to exit...
pause >nul

