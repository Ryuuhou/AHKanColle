﻿;PixelSearch v1.0

CheckWindow()
{
	global
	IfWinExist, ahk_id %hwnd%
	{
		WinGetPos, , , TWinW, TWinH
		if (TWinW != WinW or TWinH != WinH)
		{
			GuiControl,, NB, Window size changed, reinitializing pixel map
			Sleep 1000
			RPixelSearch()
		}
	}
	else
	{
		GuiControl,, NB, Window not found, searching for window
		Sleep 1000
		SetWindow()
	}
	return
}
	
SetWindow()
{
	global
	local i := 1
	Sleep 300
	Loop
	{
		hwnd := 0
		hwnd := WinExist(WINID)
		if not hwnd = 0
		{
			WinActivate
			WinGetPos, , , WinW, WinH
			GuiControl,, NB, Window found
			Break
		}    
		else
		{
			GuiControl,, NB, Window not found. Retrying (%i%)
			Sleep 1000
			i += 1
			if i > 30
			{
				GuiControl,, NB, Could not find window, unpause script to try again
				i := 1
				Pause
			}
		}
	}
	RPixelSearch()
}

RPixelSearch()
{
	global
	local i := 1
	local PSS
	Loop
	{
		WinActivate, ahk_id %hwnd%
		PSS := 0
		PixelSearch, BX1, BY1, 0, 0, WinW, WinH, BPC1, 1, Fast RGB
		PixelGetColor, BPCT, BX1+1, BY1, RGB
		if (ErrorLevel = 0 and BPCT = BPC2)
		{
			PSS := 1
		}	
		else
		{
			PixelSearch, BX1, BY1, 0, 0, WinW, WinH, BEPC1, 1, Fast RGB
			PixelGetColor, BPCT, BX1+1, BY1, RGB
			if (ErrorLevel = 0 and BPCT = BEPC2)
			{
				PSS := 1
			}
		}

		if PSS = 1
		{
			FX := BX1 - 304
			FY := BY1 + 441
			PixelMap()
			GuiControl,, NB, Ready
			return
		}
		else
		{
			GuiControl,, NB, Invalid Screen, Retrying (%i%)
			Sleep 1000
			i += 1
			if i > 30
			{
				GuiControl,, NB, Could not find reference pixel, unpause script to try again
				i := 1
				Pause
			}
		}
	}
}