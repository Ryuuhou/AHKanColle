;PixelSearch v1.03 11/26/15

RPixelSearch()
{
	global
	local i := 1
	local PSS
	Loop
	{
		WinActivate, ahk_id %uid%
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
			if Background = 2
			{
				XDiff := BX1 - 678
				YDiff := BY1 - 17
			}
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