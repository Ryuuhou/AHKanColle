;Pause Utility v1.1 for AHKanColle and AHKCSortie
#Persistent

;Use 24 hour format only.
;Set these variables in config.ini file.
;Put PC to sleep after pausing, 0 for disable, 1 for enable.
;
;Example for 18:00. Order of the variables does not matter. config.ini is used by AHKanColle.ahk as well.
;Do not edit anything in this script, all configurations go in config.ini
;
;[Variables]
;PauseHr=18
;PauseMn=00
;PCSleep=0

IniRead, PauseHr, config.ini, Variables, PauseHr, -1
IniRead, PauseMn, config.ini, Variables, PauseMn, -1
IniRead, ResumeHr, config.ini, Variables, ResumeHr, -1
IniRead, ResumeMn, config.ini, Variables, ResumeMn, -1
IniRead, PCSleep, config.ini, Variables, PCSleep, 0

Resume := 0
tString := ""

if (PauseHr = -1 or PauseHr < 0 or PauseHr > 23 or PauseMn = -1 or PauseMn < 0 or PauseMn > 59)
{
	MsgBox PauseHr and PauseMn not set in config.ini file or invalid time input.
	ExitApp
}
else
{
	tt := GetRemainingTime(PauseHr,PauseMn)
	SetTimer, TogglePause, %tt%
	tString := "Script will be paused at " . PauseHr . ":" . PauseMn
}

if not (ResumeHr = -1 or ResumeHr < 0 or ResumeHr > 23 or ResumeMn = -1 or ResumeMn < 0 or ResumeMn > 59)
{
	Resume := 1
	tt := GetRemainingTime(ResumeHr,ResumeMn)
	SetTimer, ToggleResume, %tt%
	tString := tString . " and resumed at " . ResumeHr . ":" . ResumeMn
}

MsgBox % tString

return

GetRemainingTime(hr,mn)
{
	global
	if (hr < A_Hour)
	{
		TRH := 24 - A_Hour + hr
	}
	else
	{
		TRH := hr - A_Hour
	}

	if (mn < A_Min)
	{
		TRM := 60 - A_Min + mn
		TRH := TRH - 1
		if (TRH < 0)
		{
			TRH := 24 + TRH
		}
	}
	else
	{
		TRM := mn - A_Min
	}

	TR := TRH * 3600000 + TRM * 60000
	return TR
}

TogglePause:
{
	SetTimer, TogglePause, Off
	DetectHiddenWindows, On
	WM_COMMAND := 0x111
	ID_FILE_PAUSE := 65403
	PostMessage, WM_COMMAND, ID_FILE_PAUSE,,, %A_ScriptDir%\AHKanColle.ahk ahk_class AutoHotkey
	PostMessage, WM_COMMAND, ID_FILE_PAUSE,,, %A_ScriptDir%\AHKCSortie.ahk ahk_class AutoHotkey
	if (PCSleep = 1 and Resume = 0)
	{
		DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
	}
	else if Resume = 1
	{
		SetTimer, TogglePause, 86400000
	}
	return
}

ToggleResume:
{
	SetTimer, ToggleResume, Off
	DetectHiddenWindows, On
	WM_COMMAND := 0x111
	ID_FILE_PAUSE := 65403
	PostMessage, WM_COMMAND, ID_FILE_PAUSE,,, %A_ScriptDir%\AHKanColle.ahk ahk_class AutoHotkey
	PostMessage, WM_COMMAND, ID_FILE_PAUSE,,, %A_ScriptDir%\AHKCSortie.ahk ahk_class AutoHotkey
	{
		SetTimer, ToggleResume, 86400000
	}
	return
}