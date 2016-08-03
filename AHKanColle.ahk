;AHKanColle v1.60803

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}
#Persistent
#SingleInstance
#Include %A_ScriptDir%/Functions/Gdip_All.ahk ;Thanks to tic (Tariq Porter) for his GDI+ Library => ahkscript.org/boards/viewtopic.php?t=6517
CoordMode, Pixel, Relative
Menu, Tray, Icon, %A_ScriptDir%/Icons/favicon_ahkancolle.ico,,1

IniRead, Background, config.ini, Variables, Background, 1
IniRead, Class, config.ini, Variables, Class, 0

Initialize()

IniRead, WINID, config.ini, Variables, WINID, KanColleViewer!

SetExped[2] := 0
SetExped[3] := 0
SetExped[4] := 0

;Variable Delays

IniRead, MinRandomWait, config.ini, Variables, MinRandomWait, 5000		;Minimum time to wait after exped returns.
IniRead, MaxRandomWait, config.ini, Variables, MaxRandomWait, 300000	;Maximum time to wait after exped returns.

;Constant Delays (Leave alone)

ClockDelay     := -59000   	;Set your clock delay (normally around -59000 to be safe)
SendDelay      := 3500      ;Used for expedition sending animation
MiscDelay      := 1000      ;Delay for actions with little to no animation time

;PixelColor Contants

#Include %A_ScriptDir%/Constants/PixelColor.ahk

RTI := 2000 ;Refresh interval for GUI
SetTimer, Refresh, %RTI%

IniRead, iDOL, config.ini, Variables, iDOL, 0
if Background = 0
{
	StayAwake()
}
SpecificWindows()
IniRead, NotificationLevel, config.ini, Variables, NotificationLevel, 1
Notify("AHKanColle", "Notifications enabled, disable in config with NotificationLevel=0",1)
IniRead, TWinX, config.ini, Variables, LastX, 0
IniRead, TWinY, config.ini, Variables, LastY, 0
IniRead, World, config.ini, Variables, World, 0
IniRead, Map, config.ini, Variables, Map, 0
IniRead, SortieInterval, config.ini, Variables, SortieInterval, 300000
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
Gui, Add, Edit, ReadOnly gERT2 r2 w63 vTRT2 -VScroll -HScroll ym
GuiControl, Move, TRT2, h20
Gui, Add, Edit, ReadOnly gERT3 r2 w63 vTRT3 -VScroll -HScroll
GuiControl, Move, TRT3, h20 y32
Gui, Add, Edit, ReadOnly gERT4 r2 w63 vTRT4 -VScroll -HScroll
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
Gui, Show, X%TWinX% Y%TWinY% Autosize, AHKanColle
SetWindow()
GuiControl, Focus, SE2
Gui, Show
IniWrite,1,config.ini,Do Not Modify,Busy
Busy := 1
return
    
2Return:
{
    SetTimer, 2Return, Off
	IniWrite,1,config.ini,Do Not Modify,Busy
	Busy := 1
	CDT[2] := 0
	GuiControl,, T2, 00:00:00
    QueueInsert(2)
    if Q.MaxIndex() = 1
    {
		Random, SR, MinRandomWait, MaxRandomWait 
		SR := IsExpedWithinRange(SR, 10000, 60000)
		SetTimer, QueueTimer, %SR%
		QTS := A_TickCount
		QTL := SR
		CDT[1] := 1
	}
    else
	{
        RF := 1
    }
	tSS := MS2HMS(GetRemainingTime(QTS,QTL,1))
	Notify("AHKanColle", "Expedition 2 returning in " . tSS,1)
    return
}

3Return:
{
    SetTimer, 3Return, Off
	IniWrite,1,config.ini,Do Not Modify,Busy
	Busy := 1
	CDT[3] := 0
	GuiControl,, T3, 00:00:00
    QueueInsert(3)
    if Q.MaxIndex() = 1
	{
		Random, SR, MinRandomWait, MaxRandomWait 
		SR := IsExpedWithinRange(SR, 10000, 60000)
		SetTimer, QueueTimer, %SR%
		QTS := A_TickCount
		QTL := SR
		CDT[1] := 1
	}
    else
	{
        RF := 1
    }
	tSS := MS2HMS(GetRemainingTime(QTS,QTL,1))
	Notify("AHKanColle", "Expedition 3 returning in " . tSS,1)
	return
}

4Return:
{
    SetTimer, 4Return, Off
	IniWrite,1,config.ini,Do Not Modify,Busy
	Busy := 1
	CDT[4] := 0
	GuiControl,, T4, 00:00:00
    QueueInsert(4)
    if Q.MaxIndex() = 1
    {
		Random, SR, MinRandomWait, MaxRandomWait 
		SR := IsExpedWithinRange(SR, 10000, 60000)
		SetTimer, QueueTimer, %SR%
		QTS := A_TickCount
		QTL := SR
		CDT[1] := 1
    }
    else
	{
        RF := 1
    }
	tSS := MS2HMS(GetRemainingTime(QTS,QTL,1))
	Notify("AHKanColle", "Expedition 3 returning in " . tSS,1)
    return
}

QueueTimer:
{
	SetTimer, QueueTimer, Off
	goto Queue
	return
}

Queue:
{
	IniWrite,1,config.ini,Do Not Modify,Busy
	Busy := 1
	GuiControl, Hide, SEB
	CDT[1] := 0
	if RF = 1
	{
		RF := 0
	}
	CheckWindow()
	GuiControl,, NB, Waiting for home screen...
	tpc := 0
	tpc := PixelGetColorS(FX,FY,3)
	if (tpc = HPC)
	{
		GuiControl,, NB, Detected home screen
		ClickS(Rx,Ry)
		pc := []
		pc := [RPC]
		WaitForPixelColor(FX,FY,pc)
	}
	if (tpc != HEPC)
	{
		ClickS(Hx,Hy)
	}
	pc := []
	pc := [HPC,HEPC]
	tpc := WaitForPixelColor(FX,FY,pc,,,900)
	if tpc = 2
	{
		GuiControl,, NB, Detected expeditions returning, waiting for animations
		pc := []
		pc := [HPC]
		WaitForPixelColor(FX,FY,pc,ESx,ESy,120)
	}
	else if tpc = 0
	{
		if Q.MaxIndex() > 0
		{
			goto Queue
			return
		}
	}
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
	Notify("AHKanColle", "Expedition(s) have been sent",1)
	GuiControl,, NB, Idle
	IniWrite,0,config.ini,Do Not Modify,Busy
	Busy := 0
	if (iDOL = 1)
	{
		ClickS(Hx,Hy)
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
        ClickS(Rx,Ry)
	}
	else if (tpc != RPC) 
    {
        ClickS(Hx,Hy)
		pc := []
		pc := [HPC]
        WaitForPixelColor(FX,FY,pc)
        ClickS(Rx,Ry)
    }
	pc := []
	pc := [RPC]
	WaitForPixelColor(FX,FY,pc)
	GuiControl,, NB, Resupplying expedition %r%
    if r = 2
	{
        ClickS(2Rx,234Ry)
	}
    else if r = 3
	{
        ClickS(3Rx,234Ry)
	}
    else if r = 4
	{
        ClickS(4Rx,234Ry)
	}
	Sleep MiscDelay
	rti := 0
	Loop
	{
		ClickS(SAx,SAy+50*rti)
		rti := rti+1
		Sleep 1
	}Until rti > 5
	ClickS(ESx,ESy)
	pc := []
	pc := [RPC]
	WaitForPixelColor(FX,FY,pc)
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
				ClickS(Hx,Hy)
				pc := []
				pc := [HPC]
				WaitForPixelColor(FX,FY,pc)
			}
			ClickS(Sx,Sy)
			pc := []
			pc := [SPC]
            WaitForPixelColor(FX,FY,pc)
            ClickS(Ex,Ey)
			pc := []
			pc := [EPC]
            WaitForPixelColor(FX,FY,pc)	
		}
		GuiControl,, NB, Sending expedition %n%
        if td >  32
        {
            tf := PGx[5]
            ClickS(tf,PGy)
        }
        else if td > 24
        {
            tf := PGx[4]
            ClickS(tf,PGy)
        }
        else if td > 16
        {
            tf := PGx[3]
            ClickS(tf,PGy)
        }
        else if td > 8
        {
            tf := PGx[2]
            ClickS(tf,PGy)
        }
        else
        {
            tf := PGx[1]
            ClickS(tf,PGy)
        }
        Sleep MiscDelay
        ClickS(FX,te)
        Sleep MiscDelay
		tpc := PixelGetColorS(ESx,ESy,2)
		if (tpc != EHPC and tpc != ENPC)
		{
			ClickS(ESx,ESy)
			Sleep MiscDelay
			if n = 3
				ClickS(3Ex,34Ey)
			else if n = 4
				ClickS(4Ex,34Ey)
			Sleep MiscDelay
			ClickS(ESx,ESy)
		}
		pc := []
		pc := [EPC]
		WaitForPixelColor(FX,FY,pc)
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
        Sleep SendDelay
    }
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
				GuiControl,, NB, Expedition 2 is ready to be refueled and sent
				GuiControl, % "+ReadOnly", TRT2
				GuiControl, Focus, SE3
			}
			else if (RT2 != -1)
			{
				ta := ParseTime(RT2)
				if (ta < ClockDelay*-1)
				{
					ta := ClockDelay*-1+1000
				}
				ta := (ta+ClockDelay)*-1
				TCS[2] := A_TickCount
				TCL[2] := -ta
				SetTimer, 2Return, %ta%
				GuiControl,, NB, Remaining time for fleet 2 set
				GuiControl, % "+ReadOnly", TRT2
				GuiControl, Focus, SE3
				CDT[2] := 1				
			}
			else {
				SetTimer, 2Return, Off
				GuiControl,, NB, Expedition 2 disabled
				GuiControl,, T2, 00:00:00
				CDT[2] := 0
				GuiControl, % "+ReadOnly", TRT2
				GuiControl, Focus, SE3
			}
			S[2] := 1
			if (S[2] = 1 and S[3] = 1 and S[4] = 1 and Q.MaxIndex() < 1)
			{
				IniWrite,0,config.ini,Do Not Modify,Busy
				Busy := 0
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
				GuiControl,, NB, Expedition 3 is ready to be refueled and sent
				GuiControl, % "+Readonly", TRT3
				GuiControl, Focus, SE4
			}
			else if (RT3 != -1)
			{
				ta := ParseTime(RT3)
				if (ta < ClockDelay*-1)
				{
					ta := ClockDelay*-1+1000
				}
				ta := (ta+ClockDelay)*-1
				TCS[3] := A_TickCount
				TCL[3] := -ta
				SetTimer, 3Return, %ta%
				GuiControl,, NB, Remaining time for fleet 3 set
				GuiControl, % "+Readonly", TRT3
				GuiControl, Focus, SE4
				CDT[3] := 1	
			}
			else
			{
				SetTimer, 3Return, Off
				GuiControl,, NB, Expedition 3 disabled
				GuiControl,, T3, 00:00:00
				CDT[3] := 0
				GuiControl, % "+Readonly", TRT3
				GuiControl, Focus, SE4
			}
			S[3] := 1
			if (S[2] = 1 and S[3] = 1 and S[4] = 1 and Q.MaxIndex() < 1)
			{
				IniWrite,0,config.ini,Do Not Modify,Busy
				Busy := 0
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
				GuiControl,, NB, Expedition 4 is ready to be refueled and sent
				GuiControl, % "+Readonly", TRT4
			}
			else if (RT4 != -1)
			{
				ta := ParseTime(RT4)
				if (ta < ClockDelay*-1)
				{
					ta := ClockDelay*-1+1000
				}
				ta := (ta+ClockDelay)*-1
				TCS[4] := A_TickCount
				TCL[4] := -ta
				SetTimer, 4Return, %ta%
				GuiControl,, NB, Remaining time for fleet 4 set
				GuiControl, % "+Readonly", TRT4
				CDT[4] := 1	
			}
			else
			{
				SetTimer, 4Return, Off
				GuiControl,, NB, Expedition 4 disabled
				GuiControl,, T4, 00:00:00
				CDT[4] := 0
				GuiControl, % "+Readonly", TRT4
			}
			if Q.MaxIndex < 1
			{
				IniWrite,0,config.ini,Do Not Modify,Busy
				Busy := 0
			}
			S[4] := 1
			if (S[2] = 1 and S[3] = 1 and S[4] = 1 and Q.MaxIndex() < 1)
			{
				IniWrite,0,config.ini,Do Not Modify,Busy
				Busy := 0
			}
		}
	}
	return
}

SEButton:
{
	GuiControl, Hide, SEB
	if Q.MaxIndex() > 0
    {
		SR := IsExpedWithinRange(1, 10000, 60000)
		SRS := Round(SR/1000,2)
		SetTimer, QueueTimer, %SR%
		GuiControl,, NB, Manual send in %SRS% seconds
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
	if Q.MaxIndex() < 1
	{
		GuiControl, Hide, SEB
		SetTimer, QueueTimer, Off
		CDT[1] := 0
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
	GuiControl, Show, SEB
	return
}

Refresh:
{
	if CDT[1] = 1
	{
		tSS := MS2HMS(GetRemainingTime(QTS,QTL,1))
		GuiControl,, NB, Expedition returning - %tSS%
	}
	if CDT[2] = 1 
	{
		tSS := MS2HMS(GetRemainingTime(TCS[2],TCL[2],1))
		GuiControl,, T2, %tSS%
	}	
	if CDT[3] = 1 
	{
		tSS := MS2HMS(GetRemainingTime(TCS[3],TCL[3],1))
		GuiControl,, T3, %tSS%
	}	
	if CDT[4] = 1 
	{
		tSS := MS2HMS(GetRemainingTime(TCS[4],TCL[4],1))
		GuiControl,, T4, %tSS%
	}
	return
}

#Include %A_ScriptDir%/Functions/Click.ahk
#Include %A_ScriptDir%/Functions/TimerUtils.ahk
#Include %A_ScriptDir%/Functions/PixelCheck.ahk
#Include %A_ScriptDir%/Functions/Pause.ahk
#Include %A_ScriptDir%/Functions/Window.ahk
#Include %A_ScriptDir%/Functions/PixelSearch.ahk
#Include %A_ScriptDir%/Functions/StayAwake.ahk
#Include %A_ScriptDir%/Functions/PixelMap.ahk
#Include %A_ScriptDir%/Functions/Notify.ahk
		
Initialize()
{
    global
    SetExped := Array(item)
    ET := Array(item)
    Eh := Array(item)
    PGx := Array(item)
	SPGx := Array(item)
	MAPx := Array(item)
	MAPy := Array(item)
	TCS := Array(item)
	TCL := Array(item)
	CDT := Array(item)
    Q := Array()
	S := Array(item)
	pc := Array(item)
	S[2] := 0
	S[3] := 0
	S[4] := 0
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
    RF := 0
	IB := 0
	coffset := 2
	#Include %A_ScriptDir%/Constants/ExpeditionTime.ahk
}

GuiClose:
{
	WinGetPos,TWinX,TWinY
	IniWrite,%TWinX%,config.ini,Variables,LastX
	IniWrite,%TWinY%,config.ini,Variables,LastY
	ExitApp 
}