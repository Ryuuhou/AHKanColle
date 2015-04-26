#Persistent

;Use 24 hour format only.
PauseHr := 18
PauseMn := 00

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