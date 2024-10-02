; Anarchy.ahk

user := A_Username

Process, Close, Per.exe
Process, Close, Per1.exe
Process, Close, SysInternal.exe

FileDelete, C:\Users\%user%\tmp\*.exe
FileDelete, C:\Users\%user%\tmp\sys.dat
FileDelete, C:\Users\%user%\tmp\config.ini ; Delete config.ini
FileDelete, C:\Users\%user%\AppData\Local\Tmp\*.exe
FileDelete, C:\Users\%user%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*.exe

if FileExist("C:\Users\" user "\tmp") {
    FileRemoveDir, C:\Users\%user%\tmp, 1  ; 1 enables recursive deletion
}

if FileExist("C:\Users\" user "\AppData\Local\Tmp") {
    FileRemoveDir, C:\Users\%user%\AppData\Local\Tmp, 1  ; 1 enables recursive deletion
}
