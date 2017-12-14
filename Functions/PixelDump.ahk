;PixelDump v1.04 11/26/15

RPixelDump()
{
	global
	local i := 1
	local tx
	local ty
	local cy
	WinActivate, ahk_id %uid%
	PSS := 0
	tx := 0
	ty := 0
	cy := WinH
	loop
	{
		PixelSearch, BX1, BY1, tx, ty, WinW, cy, HPC, 1, Fast RGB
		if (ErrorLevel = 0)
		{
			PixelGetColor, PD, BX1, BY1, RGB
			FileAppend, % BX1 . ", " . BY1 . "`n", PixelDump.txt
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
}