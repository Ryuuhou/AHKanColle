#Persistent

;Use 24 hour format only.
;Set these variables in config.ini file.
;
;Example for 18:00. Order of the variables does not matter. config.ini is used by AHKanColle.ahk as well.
;
;[Variables]
;PauseHr=18
;PauseMn=00

IniRead, PauseHr, config.ini, Variables, PauseHr, -1
IniRead, PauseMn, config.ini, Variables, PauseMn, -1

if (PauseHr = -1 or PauseMn = -1)
{
	MsgBox PauseHr and PauseMn not set in config.ini file.
	ExitApp
}

;Put PC to sleep after pausing, 0 for disable, 1 for enable.
PCSleep := 0

if (PauseHr < A_Hour)
{
	TRH := 24 - A_Hour + PauseHr
}
else
{
	TRH := PauseHr - A_Hour
}

if (PauseMn < A_Min)
{
	TRM := 60 - A_Min + PauseMn
	TRH := TRH - 1
	if (TRH < 0)
	{
		TRH := 24 + TRH
	}
}
else
{
	TRM := PauseMn - A_Min
}

TR := TRH * 3600000 + TRM * 60000
SetTimer, TogglePause, %TR%

return

TogglePause:
{
	SetTimer, TogglePause, Off
	DetectHiddenWindows, On
	WM_COMMAND := 0x111
	ID_FILE_PAUSE := 65403
	PostMessage, WM_COMMAND, ID_FILE_PAUSE,,, %A_ScriptDir%\AHKanColle.ahk ahk_class AutoHotkey
	if (PCSleep = 1)
	{
		DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
	}	
}