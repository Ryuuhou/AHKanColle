;PixelSearch v1.04 11/26/15

RPixelSearch()
{
	global
	local i := 1
	local tx
	local ty
	local cy
	local PSS
	local RPTL
	local RPTR
	local RPTU
	local RPTD
	loop
	{
		WinActivate, ahk_id %uid%
		PSS := 0
		tx := 0
		ty := 0
		cy := WinH
		RPTL := 0
		RPTR := 0
		RPTU := 0
		RPTD := 0
		loop
		{
			PixelSearch, BX1, BY1, tx, ty, WinW, cy, RPN1, 1, Fast RGB
			;MsgBox % BX1 .  ", " . BY1 .  ", " . tx .  ", " . ty .  ", " . cy
			;MsgBox % BX1 .  ", " . BY1
			if (ErrorLevel = 0)
			{
				;MsgBox % BX1 .  ", " . BY1
				PixelGetColor, RPTL, BX1-1, BY1, RGB
				PixelGetColor, RPTR, BX1+1, BY1, RGB
				PixelGetColor, RPTU, BX1, BY1-1, RGB
				PixelGetColor, RPTD, BX1, BY1+1, RGB
				if (RPTL = RPN1 and RPTR = RPN1 and RPTU = RPN1 and RPTD = RPN1)
				{
					PSS := 1
					;MsgBox % BX1 .  ", " . BY1
					break
				}
				if (++tx >= WinW)
				{
					tx := 0
					ty := ty + 1
					cy := ty
				}
				else
				{
					tx := BX1+1
					ty := BY1
					cy := BY1
				}
			}
			else
			{
				tx := 0
				ty := ty + 1
				cy := WinH
			}
			
		} until ty >= WinH

		if PSS = 1
		{
			if not Class = 0
			{
				XDiff := BX1 - 678
				YDiff := BY1 - 17
			}
			FX := BX1 - 398
			FY := BY1 + 9
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