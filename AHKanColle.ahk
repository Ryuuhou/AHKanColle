;KANCOLLE AHK EXPEDITION SCRIPT GUI V0.97 4/19/15
#Persistent
#SingleInstance
#Include Gdip.ahk ;Thanks to tic (Tariq Porter) for his GDI+ Library => ahkscript.org/boards/viewtopic.php?t=6517
CoordMode, Pixel, Relative

Initialize()

IniRead, WINID, config.ini, Variables, WINID, KanColleViewer!

;Variable Delays

IniRead, LoadingDelay, config.ini, Variables, LoadingDelay, 5000    ;Most important delay, server response delay.  No lower than 4000.
IniRead, MinRandomWait, config.ini, Variables, MinRandomWait, 4000		;Minimum time to wait after exped returns.
IniRead, MaxRandomWait, config.ini, Variables, MaxRandomWait, 300000	;Maximum time to wait after exped returns.

;Constant Delays

ClockDelay     := -59000   	;Set your clock delay (normally around -59000 to be safe)
ReturnDelay    := 8000    	;Used for expedition returning animation (AT LEAST 8 SECONDS)
SendDelay      := 4000      ;Used for expedition sending animation
MiscDelay      := 1000      ;Delay for actions with little to no animation time

RTI := 2000 ;Refresh interval for GUI

;CM: 1=Home, 2=Resupply, 3=SortieMenu, 4=ExpedList

IfWinExist, %WINID%
{
	hwnd := WinExist(WINID)
    WinActivate
    WinGetPos, , , WinW, WinH
}    
else
{
    MsgBox Window not found
    Exit
}

ImageSearch, FoundX, FoundY, 0, 0, WinW, WinH, %A_ScriptDir%\IMG\HP.png
if ErrorLevel = 0
{
    Hx := FoundX - 330 ;Home Button
    Hy := FoundY - 415
    Sx := FoundX - 185 ;Sortie Button
    Sy := FoundY - 200
    Rx := FoundX - 300 ;Resupply Button
    Ry := FoundY - 240
    SAx := FoundX - 255
    SAy := FoundY - 335
    Ex := FoundX + 280 ;Expedition Button
    Ey := FoundY - 240
    ESx := FoundX + 330
    ESy := FoundY - 15
    3Ex := FoundX + 45
    4Ex := FoundX + 75
    34Ey := FoundY - 335
    2Rx := FoundX - 200
    3Rx := FoundX - 170
    4Rx := FoundX - 140
    234Ry := FoundY - 340
    PGx[1] := FoundX - 240
    PGx[2] := FoundX - 180
    PGx[3] := FoundX - 125
    PGx[4] := FoundX - 70
    PGx[5] := FoundX - 10
    PGy := FoundY - 20
    CM := 1
    RC := 0
	TO := 0
    index := 1
    Loop
    {
        th := FoundY-280+30*(index-1)
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
	IniRead, iDOL, config.ini, Variables, iDOL, 0
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
	Gui, Show, Autosize
}
else
{
    MsgBox KanColle is not on home screen
    Exit
}
return
    
2Return:
{
    SetTimer, 2Return, Off
    Q.Insert(2)
    if Q.MaxIndex() = 1
    {
		Random, SR, MinRandomWait, MaxRandomWait 
		n := 2
		loop
		{
			GRT := GetRemainingTime(n)
			if (GRT > SR-LoadingDelay and GRT < SR+60000 and SR < GRT+10000)
			{
				SR := GRT+10000
				n := 1
			}
			n += 1
		}Until n > 4
		SRS := Round(SR/60000,2)
		GuiControl,, NB, Expedition 2 returning - Delay: %SRS% minutes
		CDT[2] := 0
		Sleep SR
        goto Queue
    }
    else
        RF := 1
    return
}

3Return:
{
    SetTimer, 3Return, Off
    Q.Insert(3)
    if Q.MaxIndex() = 1
	{
		Random, SR, MinRandomWait, MaxRandomWait 
		n := 2
		loop
		{
			GRT := GetRemainingTime(n)
			if (GRT > SR-LoadingDelay and GRT < SR+60000 and SR < GRT+10000)
			{
				SR := GRT+10000
				n := 1
			}
			n += 1
		}Until n > 4
		SRS := Round(SR/60000,2)
		GuiControl,, NB, Expedition 3 returning - Delay: %SRS% minutes
		CDT[3] := 0
		Sleep SR
        goto Queue
    }
    else
        RF := 1
    return
}

4Return:
{
    SetTimer, 4Return, Off
    Q.Insert(4)
    if Q.MaxIndex() = 1
    {
		Random, SR, MinRandomWait, MaxRandomWait 
		n := 2
		loop
		{
			GRT := GetRemainingTime(n)
			if (GRT > SR-LoadingDelay and GRT < SR+60000 and SR < GRT+10000)
			{
				SR := GRT+10000
				n := 1
			}
			n += 1
		}Until n > 4
		SRS := Round(SR/60000,2)
		GuiControl,, NB, Expedition 4 returning - Delay: %SRS% minutes
		CDT[4] := 0
		Sleep SR
        goto Queue
    }
    else
        RF := 1
    return
}

Queue:
{
	if RF = 1
		RF := 0
    qi := 1
	if Skip = 0
	{
		if CM != 1
		{
			ControlClick, x%Hx% y%Hy%, %WINID%
		}
		else
		{
			ControlClick, x%Rx% y%Ry%, %WINID%
			Sleep MiscDelay
			ControlClick, x%Hx% y%Hy%, %WINID%
			
		}
		CM := 1
		Sleep LoadingDelay
		Loop
		{
			ControlClick, x%ESx% y%ESy%, %WINID%
			Sleep ReturnDelay+LoadingDelay
			ControlClick, x%ESx% y%ESy%, %WINID%
			Sleep MiscDelay
			ControlClick, x%ESx% y%ESy%, %WINID%
			Sleep MiscDelay
			qi += 1
		}Until qi > Q.MaxIndex()
	}
	Skip := 0
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
		CM := 1	
	}	
	
    return
}    

Resupply(r)
{
    global
	GuiControl,, NB, Resupplying...
    if CM = 1
        ControlClick, x%Rx% y%Ry%, %WINID%
    else if CM > 2
    {
        ControlClick, x%Hx% y%Hy%, %WINID%
        Sleep LoadingDelay
        ControlClick, x%Rx% y%Ry%, %WINID%
    }
    CM := 2
    Sleep MiscDelay
	GuiControl,, NB, Resupplying expedition %r%
    if r = 2
        ControlClick, x%2Rx% y%234Ry%, %WINID%
    else if r = 3
        ControlClick, x%3Rx% y%234Ry%, %WINID%
    else if r = 4
        ControlClick, x%4Rx% y%234Ry%, %WINID%
    Sleep MiscDelay
    ControlClick, x%SAx% y%SAy%, %WINID%
    Sleep MiscDelay
    ControlClick, x%ESx% y%ESy%, %WINID%
    Sleep LoadingDelay
}
    
SendExp(n)
{
    global
    if SetExped[n] != 0
    {
		GuiControl,, NB, Sending...
        td := SetExped[n]
        te := Eh[td]
        if (CM != 4 and CM != 1)
        {
            ControlClick, x%Hx% y%Hy%, %WINID%
            CM := 1
            Sleep LoadingDelay
        }
        if CM = 1
        {
            ControlClick, x%Sx% y%Sy%, %WINID%
            CM := 3
            Sleep LoadingDelay
            ControlClick, x%Ex% y%Ey%, %WINID%
            CM := 4
			Sleep LoadingDelay
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
        ControlClick, x%FoundX% y%te%, %WINID%
        Sleep MiscDelay
        ControlClick, x%ESx% y%ESy%, %WINID%
        Sleep MiscDelay
        if n = 3
            ControlClick, x%3Ex% y%34Ey%, %WINID%
        else if n = 4
            ControlClick, x%4Ex% y%34Ey%, %WINID%
        Sleep MiscDelay
        ControlClick, x%ESx% y%ESy%, %WINID%
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
        Sleep SendDelay+LoadingDelay
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
		if RT2 != ""
		{
			if Q.MaxIndex() > 0
			{
				qi := 1
			    Loop
				{
					if Q[qi] = 2 {
						Q.Remove(qi)
					}
					qi += 1
				}Until qi > Q.MaxIndex()
			}
			if TRT2 = 0
			{
				Q.Insert(2)
				if IB = 0
				{
					GuiControl, Show, SEB
					IB := 1
				}
				GuiControl,, NB, Expedition 2 is ready to be refueled and sent
				GuiControl, % "+ReadOnly", TRT2
				GuiControl, Focus, SE3
			}
			else if RT2 != -1
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
		if RT3 != ""
		{
			if Q.MaxIndex() > 0
			{
				qi := 1
			    Loop
				{
					if Q[qi] = 3 {
						Q.Remove(qi)
					}
					qi += 1
				}Until qi > Q.MaxIndex()
			}
			if RT3 = 0
			{
				Q.Insert(3)
				if IB = 0
				{
					GuiControl, Show, SEB
					IB := 1
				}
				GuiControl,, NB, Expedition 3 is ready to be refueled and sent
				GuiControl, % "+Readonly", TRT3
				GuiControl, Focus, SE4
			}
			else if RT3 != -1
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
		if RT4 != ""
		{
			if Q.MaxIndex() > 0
			{
				qi := 1
			    Loop
				{
					if Q[qi] = 4 {
						Q.Remove(qi)
					}
					qi += 1
				}Until qi > Q.MaxIndex()
			}
			if RT4 = 0
			{
				Q.Insert(4)
				if IB = 0
				{
					GuiControl, Show, SEB
					IB := 1
				}
				GuiControl,, NB, Expedition 4 is ready to be refueled and sent
				GuiControl, % "+Readonly", TRT4
			}
			else if RT4 != -1
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
		Skip := 1
        goto Queue
    }
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

PixelGetColorS(x,y)
{
	global
	pToken  := Gdip_Startup()
	pBitmap := Gdip_BitmapFromHWND(hwnd)
	;PixelGetColor, TEST1, x, y, RGB
	;MsgBox % TEST1
	pARGB := GDIP_GetPixel(pBitmap, FoundX, FoundY)
	pHEX := DEC2HEX(pARGB,"true")
	;MsgBox % pHEX
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	return pHEX
}

DEC2HEX(DEC, RARGB="false") {
    SetFormat, IntegerFast, hex
    RGB += DEC ;Converts the decimal to hexidecimal
	if(RARGB=="true")
		RGB := RGB & 0x00ffffff
    return RGB
}

Pause2:
{
	Pause
}

Pause::Pause

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
    RandomDelay := 0
    RF := 0
	IB := 0
	Skip := 0
}

;To-do list
;Remove image search requirement. Possibly a pixel search alternative.
;Test a background pixel search method

;ChangeLog
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


