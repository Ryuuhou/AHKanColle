;PixelCheck v1.0

DEC2HEX(DEC, RARGB="false") 
{
    SetFormat, IntegerFast, hex
    RGB += DEC ;Converts the decimal to hexidecimal
	if(RARGB=="true")
		RGB := RGB & 0x00ffffff
	SetFormat, IntegerFast, d
    return RGB
}

PixelGetColorS(x,y,z := 0)
{
	global hwnd
	global NB
	global ECPC
	i := 0
	lHEX := 0
	Loop
	{
		pToken  := Gdip_Startup()
		pBitmap := Gdip_BitmapFromHWND(hwnd)
		pARGB := GDIP_GetPixel(pBitmap, x, y)
		pHEX := DEC2HEX(pARGB,"true")
		if (pHEX = lHEX)
		{
			i += 1
		}else
		{
			lHEX := pHEX
			i := 1
		}
		Gdip_DisposeImage(pBitmap)
		Gdip_Shutdown(pToken)
		Sleep 50
	}Until i > z
	if (lHEX = ECPC)
	{
		GuiControl,, NB, ErrorCat
		Pause
	}
	return lHEX
}

WaitForPixelColor(x, y, pc, pc2 := 0, click := 0, timeout := 60)
{
	global WINID
	i := 0
	tpc := 0
	loop
	{
		Sleep 500
		tpc := PixelGetColorS(x,y)
		if (tpc = pc)
		{
			Sleep 500
			return 1
		}
		else if (pc != 0 and tpc = pc2)
		{
			Sleep 500
			return 2
		}
		if (click = 1)
		{
			ControlClick, x%x% y%y%, %WINID%
		}
		Sleep 500
		i += 1
	}Until i > timeout
	return 0
}
