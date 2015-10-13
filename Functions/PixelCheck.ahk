;PixelCheck v1.03 7/13/15

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
	i := 0
	lHEX := 0
	WinActivateRestore()
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
	return lHEX
}

WaitForPixelColor(x, y, pc, pc2 := 0, pc3 := 0, cx := -1, cy := -1, timeout := 60)
{
	global hwnd
	global ECPC
	ecc := 0
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
		else if (pc2 != 0 and tpc = pc2)
		{
			Sleep 500
			return 2
		}
		else if (pc3 != 0 and tpc = pc3)
		{
			Sleep 500
			return 3
		}
		else if (tpc = ECPC)
		{
			ecc += 1
		}
		if cy != -1
		{
			ClickS(cx,cy)
		}
		else if cx != -1
		{
			ClickS(x,y)
		}
		Sleep 500
		i += 1
	}Until i > timeout
	if ecc > 5
	{
		GuiControl,, NB, ErrorCat
		Pause
	}
	return 0
}
