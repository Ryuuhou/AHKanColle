;AHKanColle Functions

ParseTime(ss)
{
    global NB
    sl := StrLen(ss)
    i := 0
    ii := 0
    tt := 0
	mx := 1000
	cc := 0
    loop
    {
        ts := SubStr(ss,sl,1)
        if ts is integer
        {
			i := i + ts*10**ii
			ii += 1
			if sl = 1
			{
				tt := tt + i * mx
				return tt
			}
        }
        else if ts is alpha
        {
			if i > 0
			{
				tt := tt + i * mx
			}
			if ts = h
			{
				mx := 3600000
			}
			else if ts = m
			{
				mx := 60000
			}
			else if ts = s
			{
				mx := 1000
			}
			else
			{
				GuiControl,, NB, Invalid time input
				Exit
			}
			ii := 0
			i := 0
        }
		else if ts = :
		{
			if cc = 0
			{
				tt := tt + i * 1000
				mx := 60000
			}
			else if cc = 1
			{
				tt := tt + i * 60000
				mx := 3600000
			}
			i := 0
			ii := 0
			cc += 1
		}
        sl := sl - 1
    }
}

MS2HMS(ms)
{
	if ms < 0
	{
		return "00:00:00"
	}
	var := Floor(ms/3600000)
	ms := ms - var*3600000
	if (var<10) 
		tString := "0" . var . ":"
	else 
		tString := var . ":"
	
	var := Floor(ms/60000)
	ms := ms - var*60000
	if (var<10) 
		tString := tString . "0" . var . ":"
	else 
		tString := tString . var . ":"
	var := Floor(ms/1000)
	if (var<10) 
		tString := tString . "0" . var
	else 
		tString := tString . var
	return tString
}

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
	if lHEX = ECPC
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


SysIntSuspend(sus)
{
	if sus = 1
	{
		Run %A_ScriptDir%\Sysinternals\pssuspend.exe KanColleViewer.exe
	}else
	{
		Run %A_ScriptDir%\Sysinternals\pssuspend.exe -r KanColleViewer.exe
	}
}

Pause2:
{
	Pause
}

Pause::Pause