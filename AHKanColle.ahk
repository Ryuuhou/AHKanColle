;AHKanColle v1.071 5/18/15
#Persistent
#SingleInstance
#Include Gdip_All.ahk ;Thanks to tic (Tariq Porter) for his GDI+ Library => ahkscript.org/boards/viewtopic.php?t=6517
CoordMode, Pixel, Relative

Initialize()

IniRead, WINID, config.ini, Variables, WINID, KanColleViewer!

SetExped[2] := 0
SetExped[3] := 0
SetExped[4] := 0

;Variable Delays

IniRead, MinRandomWait, config.ini, Variables, MinRandomWait, 5000		;Minimum time to wait after exped returns.
IniRead, MaxRandomWait, config.ini, Variables, MaxRandomWait, 300000	;Maximum time to wait after exped returns.

;Constant Delays

ClockDelay     := -59000   	;Set your clock delay (normally around -59000 to be safe)
SendDelay      := 3500      ;Used for expedition sending animation
MiscDelay      := 1000      ;Delay for actions with little to no animation time

;PixelColor Contants

HPC := 0x4acacd ;Home
HEPC := 0x42b6b8 ;Home + Exped
;0x49afb1 = fleet selection
;0x41413c = " "
RPC := 0xeee6d9 ;Resupply
SPC := 0x293137 ;Sortie
EPC := 0xede6d9 ;Expeditions
NRPC := 0x444444 ;Needs Resupply
RRPC := 0xd1c1b2 ;Resupplied
ECPC := 0xffffff ;Error Cat
EHPC := 0xee8b28 ;Cancel expedition button hovered
ENPC := 0xcd3547 ;Cancel expedition button
BPC1 := 0xaab974 ;Bucket1
BPC2 := 0xc3c89a ;Bucket2
BEPC1 := 0xeae2cc ;BucketExped1
BEPC2 := 0xece3cf ;BucketExped2

RTI := 2000 ;Refresh interval for GUI

PixelMap()
IniRead, iDOL, config.ini, Variables, iDOL, 0
IniRead, TWinX, config.ini, Variables, LastX, 0
IniRead, TWinY, config.ini, Variables, LastY, 0
Gui, 1: New
Gui, 1: Default
Gui, Add, Text,, Exped 2:
Gui, Add, Text,, Exped 3:
Gui, Add, Text,, Exped 4:
Gui, Add, Text,, MinWait:
Gui, Add, Text,, MaxWait:
Gui, Add, Edit, r1 w20 vNB ReadOnly
GuiControl, Move, NB, w300 y139
IniRead, tSetExped, config.ini, Variables, SetExped2, %A_Space%
Gui, Add, Edit, gESE2 r2 limit4 w20 vSE2 -VScroll ym, %tSetExped%
GuiControl, Move, SE2, h20
IniRead, tSetExped, config.ini, Variables, SetExped3, %A_Space%
Gui, Add, Edit, gESE3 r2 limit4 w20 vSE3 -VScroll, %tSetExped%
GuiControl, Move, SE3, h20 y32
IniRead, tSetExped, config.ini, Variables, SetExped4, %A_Space%
Gui, Add, Edit, gESE4 r2 limit4 w20 vSE4 -VScroll, %tSetExped%
GuiControl, Move, SE4, h20 y58
Gui, Add, Edit, gMiW r2 w20 vmid -VScroll, %MinRandomWait%
GuiControl, Move, mid, h20 y85 w80
Gui, Add, Edit, gMaW r2 w20 vmad -VScroll, %MaxRandomWait%
GuiControl, Move, mad, h20 y112 w80
Gui, Add, Text,ym x+20,Remaining Time:
Gui, Add, Text,,Remaining Time:
Gui, Add, Text,,Remaining Time:
Gui, Add, Edit, ReadOnly gERT2 r2 w60 vTRT2 -VScroll ym
GuiControl, Move, TRT2, h20
Gui, Add, Edit, ReadOnly gERT3 r2 w60 vTRT3 -VScroll
GuiControl, Move, TRT3, h20 y32
Gui, Add, Edit, ReadOnly gERT4 r2 w60 vTRT4 -VScroll
GuiControl, Move, TRT4, h20 y58
Gui, Add, Text, vT2 ym, 00:00:00
Gui, Add, Text, vT3, 00:00:00
Gui, Add, Text, vT4, 00:00:00
Gui, Add, Button, gSEButton vSEB, A
GuiControl, Move, SEB, x210 y110 w95
GuiControl,,SEB, Send Expeditions
GuiControl, Hide, SEB
Menu, Main, Add, Pause, Pause2
Gui, Menu, Main
GuiControl, Focus, SE2
Gui, Show, X%TWinX% Y%TWinY% Autosize, AHKanColle
return
    
2Return:
{
    SetTimer, 2Return, Off
	CDT[2] := 0
    QueueInsert(2)
    if Q.MaxIndex() = 1
    {
		Random, SR, MinRandomWait, MaxRandomWait 
		n := 2
		loop
		{
			GRT := GetRemainingTime(n)
			if (GRT > SR and GRT < SR+60000 and SR < GRT+10000)
			{
				SR := GRT+10000
				n := 1
			}
			n += 1
		}Until n > 4
		SRS := Round(SR/60000,2)
		GuiControl,, NB, Expedition 2 returning - Delay: %SRS% minutes
		Sleep SR
        goto Queue
		return
    }
    else
        RF := 1
    return
}

3Return:
{
    SetTimer, 3Return, Off
	CDT[3] := 0
    QueueInsert(3)
    if Q.MaxIndex() = 1
	{
		Random, SR, MinRandomWait, MaxRandomWait 
		n := 2
		loop
		{
			GRT := GetRemainingTime(n)
			if (GRT > SR and GRT < SR+60000 and SR < GRT+10000)
			{
				SR := GRT+10000
				n := 1
			}
			n += 1
		}Until n > 4
		SRS := Round(SR/60000,2)
		GuiControl,, NB, Expedition 3 returning - Delay: %SRS% minutes
		Sleep SR
        goto Queue
		return
    }
    else
        RF := 1
    return
}

4Return:
{
    SetTimer, 4Return, Off
	CDT[4] := 0
    QueueInsert(4)
    if Q.MaxIndex() = 1
    {
		Random, SR, MinRandomWait, MaxRandomWait 
		n := 2
		loop
		{
			GRT := GetRemainingTime(n)
			if (GRT > SR and GRT < SR+60000 and SR < GRT+10000)
			{
				SR := GRT+10000
				n := 1
			}
			n += 1
		}Until n > 4
		SRS := Round(SR/60000,2)
		GuiControl,, NB, Expedition 4 returning - Delay: %SRS% minutes
		Sleep SR
        goto Queue
		return
    }
    else
        RF := 1
    return
}

Queue:
{
	if RF = 1
	{
		RF := 0
	}
	WinGetPos, , , TWinW, TWinH, ahk_id %hwnd%
	if (TWinW != WinW or TWinH != WinH)
	{
		GuiControl,, NB, Window size changed, reinitializing pixel map
		PixelMap()
		Sleep 1000
	}
	tpc := 0
	tpc := PixelGetColorS(FX,FY,3)
	if (tpc = HPC)
	{
		ControlClick, x%Rx% y%Ry%, %WINID%
		WaitForPixelColor(RPC)
	}
	if (tpc != HEPC)
	{
		ControlClick, x%Hx% y%Hy%, %WINID%
	}
	GuiControl,, NB, Waiting for home screen...
	tpc := WaitForPixelColor(HPC,HEPC,,900)
	if tpc = 2
	{
		WaitForPixelColor(HPC,,1)
	}
	else if tpc = 0
	{
		if Q.MaxIndex() > 0
		{
			goto Queue
		}
		return
	}
    RC += 1
	qi := 1
    Loop
    {
        Resupply(Q[qi])
        qi += 1
    }Until qi > Q.MaxIndex()
    if RF = 1
    {
        RF := 0
        goto Queue
        return
    }
    Loop
    {
        SendExp(Q[1])
        RemovedValue := Q.Remove(1)
        if RF = 1
        {
            RF := 0
            goto Queue
            return
        }
    }Until Q.MaxIndex() = ""
	GuiControl,, NB, Idle
	if iDOL = 1 
	{
		ControlClick, x%Hx% y%Hy%, %WINID%
		GuiControl,, NB, iDOL
	}	
	
    return
}    

Resupply(r)
{
    global
	GuiControl,, NB, Resupplying...
	tpc := 0
	tpc := PixelGetColorS(FX,FY,3)
	if (tpc = HPC)
	{
        ControlClick, x%Rx% y%Ry%, %WINID%
	}
	else if (tpc != RPC) 
    {
        ControlClick, x%Hx% y%Hy%, %WINID%
        WaitForPixelColor(HPC)
        ControlClick, x%Rx% y%Ry%, %WINID%
    }
	WaitForPixelColor(RPC)
	GuiControl,, NB, Resupplying expedition %r%
    if r = 2
        ControlClick, x%2Rx% y%234Ry%, %WINID%
    else if r = 3
        ControlClick, x%3Rx% y%234Ry%, %WINID%
    else if r = 4
        ControlClick, x%4Rx% y%234Ry%, %WINID%
    Sleep MiscDelay
	tpc := PixelGetColorS(SAx,SAy,2)
	if (tpc != RRPC)
	{
		ControlClick, x%SAx% y%SAy%, %WINID%
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, %WINID%
		WaitForPixelColor(RPC)
	}
}
    
SendExp(n)
{
    global
    if SetExped[n] != 0
    {
		GuiControl,, NB, Sending...
        td := SetExped[n]
        te := Eh[td]
		tpc := 0
		tpc := PixelGetColorS(FX,FY,3)
		if (tpc != EPC)
		{
			if (tpc != HPC)
			{
				ControlClick, x%Hx% y%Hy%, %WINID%
				WaitForPixelColor(HPC)
			}
			ControlClick, x%Sx% y%Sy%, %WINID%
            WaitForPixelColor(SPC)
            ControlClick, x%Ex% y%Ey%, %WINID%
            WaitForPixelColor(EPC)	
		}
		GuiControl,, NB, Sending expedition %n%
        if td >  32
        {
            tf := PGx[5]
            ControlClick, x%tf% y%PGy%, %WINID%
        }
        else if td > 24
        {
            tf := PGx[4]
            ControlClick, x%tf% y%PGy%, %WINID%
        }
        else if td > 16
        {
            tf := PGx[3]
            ControlClick, x%tf% y%PGy%, %WINID%
        }
        else if td > 8
        {
            tf := PGx[2]
            ControlClick, x%tf% y%PGy%, %WINID%
        }
        else
        {
            tf := PGx[1]
            ControlClick, x%tf% y%PGy%, %WINID%
        }
        Sleep MiscDelay
        ControlClick, x%FX% y%te%, %WINID%
        Sleep MiscDelay
		tpc := PixelGetColorS(ESx,ESy,2)
		if (tpc != EHPC and tpc != ENPC)
		{
			ControlClick, x%ESx% y%ESy%, %WINID%
			Sleep MiscDelay
			if n = 3
				ControlClick, x%3Ex% y%34Ey%, %WINID%
			else if n = 4
				ControlClick, x%4Ex% y%34Ey%, %WINID%
			Sleep MiscDelay
			ControlClick, x%ESx% y%ESy%, %WINID%
		}
		WaitForPixelColor(EPC)
        if n = 2
        {
            ta := (ET[SetExped[2]]+ClockDelay)*-1
			TCS[2] := A_TickCount
			TCL[2] := -ta
            SetTimer, 2Return, %ta%
			CDT[2] := 1
        }
        else if n = 3
        {
            ta := (ET[SetExped[3]]+ClockDelay)*-1
			TCS[3] := A_TickCount
			TCL[3] := -ta
            SetTimer, 3Return, %ta%
			CDT[3] := 1
        }
        else if n = 4
        {
            ta := (ET[SetExped[4]]+ClockDelay)*-1
			TCS[4] := A_TickCount
			TCL[4] := -ta
            SetTimer, 4Return, %ta%
			CDT[4] := 1
        }
		if TO = 0
		{
			SetTimer, Refresh, %RTI%
			TO := 1
		}
        Sleep SendDelay
    }
}

GetRemainingTime(expedn) 
{	
	global
	return (TCS[expedn]+TCL[expedn]-A_TickCount)
}
	

HMS2MS(ss)
{
    global
    sl := StrLen(ss)
    i := 1
    ii := 0
    tt := 0
    loop
    {
        ts := SubStr(ss,i,1)
        if ts is integer
        {
            if ii > 0
                ii := ii*10+ts
            else
                ii := ts
        }
        else if ts is alpha
        {
            if ts = h
            {
                tt := tt+ii*3600000
            }
            else if ts = m
                tt := tt+ii*60000
            else if ts = s
                tt := tt+ii*1000
            else
            {
                GuiControl,, NB, Invalid time input
                Exit
            }
            ii := 0
        }
        i += 1
    }Until i > sl
    return tt
}

MS2HMS(ms)
{
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

MiW:
{
	Gui, submit,nohide
	if mid contains `n
	{
		StringReplace, mid, mid, `n,,All
		GuiControl,, mid, %mid%
		Send, {end}
		MinRandomWait := mid
		IniWrite,%mid%,config.ini,Variables,MinRandomWait
		GuiControl,, NB, Changed minimum random delay
	}
	return
}

MaW:
{
	Gui, submit,nohide
	if mad contains `n
	{
		StringReplace, mad, mad, `n,,All
		GuiControl,, mad, %mad%
		Send, {end}
		MaxRandomWait := mad
		IniWrite,%mad%,config.ini,Variables,MaxRandomWait
		GuiControl,, NB, Changed max random delay
	}
	return
}

ESE2:
{
	Gui, submit,nohide
	if SE2 contains `n
	{
		StringReplace, SE2, SE2, `n,,All
		GuiControl,, SE2, %SE2%
		Send, {end}
		SetExped[2] := SE2
		if SetExped[2] > -1 and SetExped[2] < 40 then
		{
			if SetExped[2] = 0
			{
				GuiControl,, NB, Expedition 2 will not be resent
			}else{
				GuiControl,, NB, Expedition 2 set
			}
			tSetExped := SetExped[2]
			IniWrite,%tSetExped%,config.ini,Variables,SetExped2
			GuiControl, % "-Readonly", TRT2
			GuiControl, Focus, TRT2
		}
		else
		{
			GuiControl,, NB, Invalid expedition for fleet 2
		}
	}
	return
}

ESE3:
{
	Gui, submit,nohide
	if SE3 contains `n
	{
		StringReplace, SE3, SE3, `n,,All
		GuiControl,, SE3, %SE3%
		Send, {end}
		SetExped[3] := SE3
		if SetExped[3] > -1 and SetExped[3] < 40 then
		{
			if SetExped[3] = 0
			{
				GuiControl,, NB, Expedition 3 will not be resent
			}else{
				GuiControl,, NB, Expedition 3 set
			}
			tSetExped := SetExped[3]
			IniWrite,%tSetExped%,config.ini,Variables,SetExped3
			GuiControl, % "-Readonly", TRT3
			GuiControl, Focus, TRT3
		}
		else
		{
			GuiControl,, NB, Invalid expedition for fleet 3
		}
	}
	return
}

ESE4:
{
	Gui, submit,nohide
	if SE4 contains `n
	{
		StringReplace, SE4, SE4, `n,,All
		GuiControl,, SE4, %SE4%
		Send, {end}
		SetExped[4] := SE4
		if SetExped[4] > -1 and SetExped[4] < 40 then
		{
			if SetExped[4] = 0
			{
				GuiControl,, NB, Expedition 4 will not be resent
			}else{
				GuiControl,, NB, Expedition 4 set
			}
			tSetExped := SetExped[4]
			IniWrite,%tSetExped%,config.ini,Variables,SetExped4
			GuiControl, % "-Readonly", TRT4
			GuiControl, Focus, TRT4
		}
		else
		{
			GuiControl,, NB, Invalid expedition for fleet 4
		}
	}
	return
}

ERT2:
{	
	Gui, Submit, NoHide
	if TRT2 contains `n
	{
		StringReplace, TRT2, TRT2, `n,,All
		GuiControl,, TRT2, %TRT2%
		Send, {end}
		RT2 := TRT2
		if (RT2 != "")
		{
			QueueRemove(2)
			if TRT2 = 0
			{
				QueueInsert(2,1)
				if IB = 0
				{
					GuiControl, Show, SEB
					IB := 1
				}
				GuiControl,, NB, Expedition 2 is ready to be refueled and sent
				GuiControl, % "+ReadOnly", TRT2
				GuiControl, Focus, SE3
			}
			else if (RT2 != -1)
			{
				if RT2 is not integer
				{
					ta := HMS2MS(RT2)
				}
				ta := (ta+ClockDelay)*-1
				TCS[2] := A_TickCount
				TCL[2] := -ta
				SetTimer, 2Return, %ta%
				GuiControl,, NB, Remaining time for fleet 2 set
				GuiControl, % "+ReadOnly", TRT2
				GuiControl, Focus, SE3
				if TO = 0
				{
					SetTimer, Refresh, %RTI%
					TO := 1
				}
				CDT[2] := 1				
			}
			else {
				GuiControl,, NB, Expedition 2 disabled
				GuiControl,, T2, 00:00:00
				CDT[2] := 0
				GuiControl, % "+ReadOnly", TRT2
				GuiControl, Focus, SE3
			}
		}
	}
	return
}

ERT3:
{
	Gui, Submit, NoHide
	if TRT3 contains `n
	{
		StringReplace, TRT3, TRT3, `n,,All
		GuiControl,, TRT3, %TRT3%
		Send, {end}
		RT3 := TRT3
		if (RT3 != "")
		{
			QueueRemove(3)
			if RT3 = 0
			{
				QueueInsert(3,1)
				if IB = 0
				{
					GuiControl, Show, SEB
					IB := 1
				}
				GuiControl,, NB, Expedition 3 is ready to be refueled and sent
				GuiControl, % "+Readonly", TRT3
				GuiControl, Focus, SE4
			}
			else if (RT3 != -1)
			{
				if RT3 is not integer
				{
					ta := HMS2MS(RT3)
				}
				ta := (ta+ClockDelay)*-1
				TCS[3] := A_TickCount
				TCL[3] := -ta
				SetTimer, 3Return, %ta%
				GuiControl,, NB, Remaining time for fleet 3 set
				GuiControl, % "+Readonly", TRT3
				GuiControl, Focus, SE4
				if TO = 0
				{
					SetTimer, Refresh, %RTI%
					TO := 1
				}
				CDT[3] := 1	
			}
			else
			{
				GuiControl,, NB, Expedition 3 disabled
				GuiControl,, T3, 00:00:00
				CDT[3] := 0
				GuiControl, % "+Readonly", TRT3
				GuiControl, Focus, SE4
			}
		}
	}
	return
}

ERT4:
{
	Gui, Submit, NoHide
	if TRT4 contains `n
	{
		StringReplace, TRT4, TRT4, `n,,All
		GuiControl,, TRT4, %TRT4%
		Send, {end}
		RT4 := TRT4
		if (RT4 != "")
		{
			QueueRemove(4)
			if RT4 = 0
			{
				QueueInsert(4,1)
				if IB = 0
				{
					GuiControl, Show, SEB
					IB := 1
				}
				GuiControl,, NB, Expedition 4 is ready to be refueled and sent
				GuiControl, % "+Readonly", TRT4
			}
			else if (RT4 != -1)
			{
				if RT4 is not integer
				{
					ta := HMS2MS(RT4)
				}
				ta := (ta+ClockDelay)*-1
				TCS[4] := A_TickCount
				TCL[4] := -ta
				SetTimer, 4Return, %ta%
				GuiControl,, NB, Remaining time for fleet 4 set
				GuiControl, % "+Readonly", TRT4
				if TO = 0
				{
					SetTimer, Refresh, %RTI%
					TO := 1
				}
				CDT[4] := 1	
			}
			else
			{
				GuiControl,, NB, Expedition 4 disabled
				GuiControl,, T4, 00:00:00
				CDT[4] := 0
				GuiControl, % "+Readonly", TRT4
			}
		}
	}
	return
}

SEButton:
{
	GuiControl, Hide, SEB
	IB := 0
	if Q.MaxIndex() > 0
    {
        goto Queue
    }
	return
}

QueueRemove(qrn)
{
	global
	if Q.MaxIndex() > 0
	{
		QRi := 1
		Loop
		{
			if Q[QRi] = qrn
			{
				Q.Remove(QRi)
			}
			QRi += 1
		}Until QRi > Q.MaxIndex()
	}
	return
}

QueueInsert(qin,QIs := 0)
{
	global
	if QIs = 0
	{
		QueueRemove(qin)
	}
	Q.Insert(qin)
	return
}

Refresh:
{
	if CDT[2] = 1 
	{
		tSS := MS2HMS(GetRemainingTime(2))
		GuiControl,, T2, %tSS%
	}	
	if CDT[3] = 1 
	{
		tSS := MS2HMS(GetRemainingTime(3))
		GuiControl,, T3, %tSS%
	}	
	if CDT[4] = 1 
	{
		tSS := MS2HMS(GetRemainingTime(4))
		GuiControl,, T4, %tSS%
	}
	if (CDT[2] = 0 and CDT[3] = 0 and CDT[4] = 0)
	{
		SetTimer, Refresh, Off
		TO := 0
	}
	return
}

PixelGetColorS(x2,y2,v2 := 0)
{
	global
	vc2 := 0
	lHEX := 0
	Loop
	{
		pToken  := Gdip_Startup()
		pBitmap := Gdip_BitmapFromHWND(hwnd)
		pARGB := GDIP_GetPixel(pBitmap, x2, y2)
		pHEX := DEC2HEX(pARGB,"true")
		if (pHEX = lHEX)
		{
			vc2 += 1
		}else
		{
			lHEX := pHEX
			vc2 := 1
		}
		Gdip_DisposeImage(pBitmap)
		Gdip_Shutdown(pToken)
		Sleep 50
	}Until vc2 > v2
	if lHEX = ECPC
	{
		GuiControl,, NB, ErrorCat
		Pause
	}
	return lHEX
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

WaitForPixelColor(pc3, pc33 := 0, click3 := 0, timeout := 60)
{
	global
	index3 := 0
	tpc3 := 0
	loop
	{
		Sleep 500
		tpc3 := PixelGetColorS(FX,FY)
		if (tpc3 = pc3)
		{
			Sleep 500
			return 1
		}
		else if (pc33 != 0 and tpc3 = pc33)
		{
			Sleep 500
			return 2
		}
		if (click3 = 1)
		{
			ControlClick, x%ESx% y%ESy%, %WINID%
		}
		Sleep 500
		index3 += 1
	}Until index3 > timeout
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

PixelMap()
{
	global
	hwnd := WinExist(WINID)
	if not hwnd = 0
	{
		WinActivate
		WinGetPos, , , WinW, WinH
	}    
	else
	{
		MsgBox Window not found
		ExitApp
	}
	Sleep 300
	PSS := 0
	PixelSearch, BX1, BY1, 0, 0, WinW, WinH, BPC1,, Fast RGB
	PixelGetColor, BPCT, BX1+1, BY1, RGB
	if (ErrorLevel = 0 and BPCT = BPC2)
	{
		PSS := 1
	}	
	else
	{
		PixelSearch, BX1, BY1, 0, 0, WinW, WinH, BEPC1,, Fast RGB
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
		Hx := FX - 330 ;Home Button
		Hy := FY - 415
		Sx := FX - 185 ;Sortie Button
		Sy := FY - 200
		Rx := FX - 300 ;Resupply Button
		Ry := FY - 240
		SAx := FX - 255
		SAy := FY - 335
		Ex := FX + 280 ;Expedition Button
		Ey := FY - 240
		ESx := FX + 330
		ESy := FY - 15
		3Ex := FX + 45
		4Ex := FX + 75
		34Ey := FY - 335
		2Rx := FX - 200
		3Rx := FX - 170
		4Rx := FX - 140
		234Ry := FY - 340
		PGx[1] := FX - 240
		PGx[2] := FX - 180
		PGx[3] := FX - 125
		PGx[4] := FX - 70
		PGx[5] := FX - 10
		PGy := FY - 20
		RC := 0
		TO := 0
		index := 1
		Loop
		{
			th := FY-280+30*(index-1)
			Eh[index] := th
			index2 := index+8
			Eh[index2] := th
			index2 := index+16
			Eh[index2] := th
			index2 := index+24
			Eh[index2] := th
			index2 := index+32
			Eh[index2] := th
			index += 1
		}Until index = 9
	}
	else
	{
		MsgBox KanColle is not on a valid screen
		ExitApp
	}
}
		
Initialize()
{
    global
    SetExped := Array(item)
    ET := Array(item)
    Eh := Array(item)
    PGx := Array(item)
	TCS := Array(item)
	TCL := Array(item)
	CDT := Array(item)
    Q := Array()
	TRT2 := 0
	TRT3 := 0
	TRT4 := 0
	TCS[2] := 0
	TCS[3] := 0
	TCS[4] := 0
	TCL[2] := 0
	TCL[3] := 0
	TCL[4] := 0
	CDT[2] := 0
	CDT[3] := 0
	CDT[4] := 0
    ET[1] := 900000
    ET[2] := 1800000
    ET[3] := 1200000
    ET[4] := 3000000
    ET[5] := 5400000
    ET[6] := 2400000
    ET[7] := 3600000
    ET[8] := 10800000
    ET[9] := 14400000
    ET[10] := 5400000
    ET[11] := 18000000
    ET[12] := 28800000
    ET[13] := 14400000
    ET[14] := 21600000
    ET[15] := 43200000
    ET[16] := 14400000
    ET[17] := 2700000
    ET[18] := 18000000
    ET[19] := 21600000
    ET[20] := 7200000
    ET[21] := 8400000
    ET[22] := 10800000
    ET[23] := 14400000
    ET[24] := 0           ;Does not exist
    ET[25] := 144000000
    ET[26] := 288000000
    ET[27] := 72000000
    ET[28] := 90000000
    ET[29] := 86400000
    ET[30] := 172800000
    ET[31] := 7200000
    ET[32] := 86400000
    ET[33] := 900000      ;Support
    ET[34] := 1800000     ;Support
    ET[35] := 25200000
    ET[36] := 32400000
    ET[37] := 9900000
    ET[38] := 10500000
    ET[39] := 108000000
    RF := 0
	IB := 0
}

GuiClose:
{
	WinGetPos,TWinX,TWinY
	IniWrite,%TWinX%,config.ini,Variables,LastX
	IniWrite,%TWinY%,config.ini,Variables,LastY
	ExitApp 
}

;To-do list


;ChangeLog
;1.07: Fixed script interaction with timing out waiting for home screen. Added check for change in window size.
;1.06: Added multi pixel checking to further reduce bugging. Addition of SysInternal for future suspend option.
;1.05: Fixed repeat resupply/sending. Adjusted pixel check delay. Script now exits when GUI is closed.
;1.04: Added short delay to allow window activation, fixed starting script on expedition return. Removal of archaic variables.
;1.03: Image no longer required, script can now be started on most pages of the game. Fixed a pixel check after sending expeditions that may bug iDOL and sending multiple expeds.
;1.0: Stable (?) Release
;0.98a: (ALPHA) Highly untested background pixel checking. Expect problems #BLAZEIT
;0.97: Adjusted delays
;0.95: Added support for INI file for saved values, repositioned GUI controls
;0.92: Improved GUI, Added countdown timer and notification bar
;0.91: Fixed all remaining times updating when pressing enter.
;0.9: GUI Interface
;0.8: Added a new detection method of overlapping returning fleets. Added support for expedition 32. Reformatted and simplified configuration instructions.
;0.7: Bugfixes, reduce bug rate of overlapping.
;0.6: Added text syntax for remaining time. Retimed constant delays. Revised delay variables for better configuration.
;0.5: Bugfixes.
;0.4: Early stage support for overlapping expeditions.
;0.1: Simple timer script created.


