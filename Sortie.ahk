;Sortie v1.022 5/31/15
#Persistent
#SingleInstance
#Include %A_ScriptDir%/Functions/Gdip_All.ahk ;Thanks to tic (Tariq Porter) for his GDI+ Library => ahkscript.org/boards/viewtopic.php?t=6517
CoordMode, Pixel, Relative

Initialize()

IniRead, WINID, config.ini, Variables, WINID, KanColleViewer!

MiscDelay := 1000

;PixelColor Contants

#Include %A_ScriptDir%/Constants/PixelColor.ahk

BC := 0

IniRead, TWinX, config.ini, Variables, LastXS, 0
IniRead, TWinY, config.ini, Variables, LastYS, 0
IniRead, World, config.ini, Variables, World, %A_Space%
IniRead, Map, config.ini, Variables, Map, %A_Space%
IniRead, DisableCriticalCheck, config.ini, Variables, DisableCriticalCheck, 0
IniRead, DisableResupply, config.ini, Variables, DisableResupply, 0
IniRead, SortieInterval, config.ini, Variables, SortieInterval, -1 ;900000 for full morale
Gui, 1: New
Gui, 1: Default
Gui, Add, Text,, Map:
Gui, Add, Edit, r1 w20 vNB ReadOnly
GuiControl, Move, NB, w300 y30
Gui, Add, Edit, gWorldF r2 limit3 w15 vWorldV -VScroll ym, %World%
GuiControl, Move, WorldV, x37 h17
Gui, Add, Text, x55 ym, -
Gui, Add, Edit, gMapF r2 limit3 w15 vMapV -VScroll ym, %Map%
GuiControl, Move, MapV, x62 h17
Gui, Add, Text, ym, Interval(ms):
Gui, Add, Edit, gIntervalF r2 w15 vIntervalV -VScroll ym, %SortieInterval%
GuiControl, Move, IntervalV, h17 w70
Gui, Add, Button, gSSBF vSSB, A
GuiControl, Move, SSB, x250 w60 ym
GuiControl,,SSB, Start
Menu, Main, Add, Pause, Pause2
Menu, Main, Add, 0, DN
Gui, Menu, Main
Gui, Show, X%TWinX% Y%TWinY% Autosize, AHKCSortie
SetWindow()
if DisableCriticalCheck = 1 
{
	GuiControl,, NB, Ready - WARNING: CRITICAL CHECK IS OFF
}
return
    
Repair()
{
	global
	local ti
	tpc2 := PixelGetColorS(FX,FY,3)
	if (tpc2 != HPC)
	{
		ControlClick, x%Hx% y%Hy%, ahk_id %hwnd%
		GuiControl,, NB, Waiting for home screen
		WaitForPixelColor(FX,FY,HPC,HEPC)	
	}
	ControlClick, x%REx% y%REy%, ahk_id %hwnd%
	GuiControl,, NB, Waiting for repair screen
	WaitForPixelColor(FX,FY,REPC)
	Sleep MiscDelay
	Loop
	{
		GuiControl,, NB, Checking HP states
		ControlClick, x%RBx% y%RBy%, ahk_id %hwnd%
		Sleep MiscDelay
		tpc2 := PixelGetColorS(CCx,CCy,3)
		if (tpc2 = CCPC)
		{
			GuiControl,, NB, Critical HP detected, repairing
			ti := BC+1
			Menu, Main, Rename, %BC%, %ti%
			BC += 1
			ControlClick, x%CCx% y%CCy%, ahk_id %hwnd%
			Sleep 500
			ControlClick, x%BBx% y%BBy%, ahk_id %hwnd%
			Sleep 500
			ControlClick, x%ESx% y%ESy%, ahk_id %hwnd%
			Sleep 500
			ControlClick, x%BCx% y%BCy%, ahk_id %hwnd%	
			WaitForPixelColor(FX,FY,REPC)
			Sleep 9000			
		}
		else
		{
			GuiControl,, NB, HP check completed
			return
		}
	}	
}


Sortie:
{
	IniRead, Busy, config.ini, Do Not Modify, Busy, KanColleViewer!
	if Busy != 1
	{
		SetTimer, Sortie, Off
		CheckWindow()
		if not (BP = 1 and DisableCriticalCheck = 1)
		{
			Repair()
		}
		if not (BP = 1 and DisableResupply = 1)
		{
			Resupply(1)
		}
		tpc2 := PixelGetColorS(FX,FY,3)
		if (tpc2 != HPC)
		{
			ControlClick, x%Hx% y%Hy%, ahk_id %hwnd%
			GuiControl,, NB, Waiting for home screen
			WaitForPixelColor(FX,FY,HPC)
		}
		ControlClick, x%Sx% y%Sy%, ahk_id %hwnd%
		GuiControl,, NB, Waiting for sortie screen
        WaitForPixelColor(FX,FY,SPC)
		ControlClick, x%S2x% y%S2y%, ahk_id %hwnd%
		GuiControl,, NB, Waiting for sortie selection screen
        WaitForPixelColor(FX,FY,S2PC)
		tf := SPGx[World]
		ControlClick, x%tf% y%PGy%, ahk_id %hwnd%
		GuiControl,, NB, Starting sortie
		Sleep MiscDelay
		tfx := MAPx[Map]
		tfy := MAPy[Map]
		ControlClick, x%tfx% y%tfy%, ahk_id %hwnd%
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, ahk_id %hwnd%
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, ahk_id %hwnd%
		GuiControl,, NB, Waiting for compass
		WaitForPixelColor(LAx,LAy,CPC)
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, ahk_id %hwnd%
		GuiControl,, NB, Waiting for formation
		tpc2 := WaitForPixelColor(LAx,LAy,FPC)
		if tpc2 := 0
		{
			Pause
		}
		Sleep MiscDelay
		ControlClick, x%LAx% y%LAy%, ahk_id %hwnd%
		GuiControl,, NB, Waiting for results
		tpc2 := WaitForPixelColor(FX,FY,SRPC,NBPC,,,300000)
		if tpc2 = 2
		{
			Sleep 3000
			ControlClick, x%CNBx% y%CNBy%, ahk_id %hwnd%
		}
		else if tpc2 = 0
		{
			Pause
		}
		GuiControl,, NB, Waiting for end sortie
		WaitForPixelColor(FX,FY,CSPC,HPC,HEPC,1)
		GuiControl,, NB, End sortie found
		Sleep 2000
		ControlClick, x%ESBx% y%ESBy%, ahk_id %hwnd%
		WaitForPixelColor(FX,FY,HPC,HEPC)
		GuiControl,, NB, Idle
		GuiControl, Show, SSB
		if SortieInterval != -1
		{
			BP := 0
			SetTimer, Sortie, %SortieInterval%
			ts := Round(SortieInterval/60000,2)
			GuiControl,, NB, Idle - Restarting in %ts% minutes
		}
	}
	else
	{
		GuiControl,, NB, An expedition is returning, retrying in 10 seconds
		SetTimer, Sortie, 10000
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
        ControlClick, x%Rx% y%Ry%, ahk_id %hwnd%
	}
	else if (tpc != RPC) 
    {
        ControlClick, x%Hx% y%Hy%, ahk_id %hwnd%
        WaitForPixelColor(FX,FY,HPC)
        ControlClick, x%Rx% y%Ry%, ahk_id %hwnd%
    }
	WaitForPixelColor(FX,FY,RPC)
	GuiControl,, NB, Resupplying fleet %r%
    Sleep MiscDelay
	tpc := PixelGetColorS(SAx,SAy,2)
	if (tpc != RRPC)
	{
		ControlClick, x%SAx% y%SAy%, ahk_id %hwnd%
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, ahk_id %hwnd%
		WaitForPixelColor(FX,FY,RPC)
	}
	return
}

WorldF:
{
	Gui, submit,nohide
	if WorldV contains `n
	{
		StringReplace, WorldV, WorldV, `n,,All
		GuiControl,, WorldV, %WorldV%
		Send, {end}
		if (WorldV = 3 or WorldV=5)
		{
			World := WorldV
			GuiControl,, NB, World set
			IniWrite,%World%,config.ini,Variables,World
		}
		else
		{
			GuiControl,, NB, Unsupported world
		}
	}
	return
}

MapF:
{
	Gui, submit,nohide
	if MapV contains `n
	{
		StringReplace, MapV, MapV, `n,,All
		GuiControl,, MapV, %MapV%
		Send, {end}
		if (MapV = 2 or MapV=4)
		{
			Map := MapV
			GuiControl,, NB, Map # set
			IniWrite,%Map%,config.ini,Variables,Map
		}
		else
		{
			GuiControl,, NB, Unsupported map #
		}
	}
	return
}

IntervalF:
{
	Gui, submit,nohide
	if IntervalV contains `n
	{
		StringReplace, IntervalV, IntervalV, `n,,All
		GuiControl,, IntervalV, %IntervalV%
		Send, {end}
		if IntervalV is integer
		{
			SortieInterval := IntervalV
			if (SortieInterval < 1000)
			{
				SortieInterval := -1
				GuiControl,, NB, Interval disabled
			}
			else
			{
				GuiControl,, NB, Interval set
			}
			IniWrite,%SortieInterval%,config.ini,Variables,SortieInterval
		}
		else
		{
			GuiControl,, NB, Invalid interval
		}
	}
	return
}

SSBF:
{
	GuiControl, Hide, SSB
	BP := 1
	goto Sortie
	return
}

DN:
{
	return
}

#Include %A_ScriptDir%/Functions/PixelCheck.ahk
#Include %A_ScriptDir%/Functions/Pause.ahk
#Include %A_ScriptDir%/Functions/PixelSearch.ahk

PixelMap()
{
	global
	Hx := FX - 330 ;Home Button
	Hy := FY - 415
	Sx := FX - 185 ;Sortie Button
	Sy := FY - 200
	S2x := FX - 151
	S2y := FY - 248
	Rx := FX - 300 ;Resupply Button
	Ry := FY - 240
	SAx := FX - 255
	SAy := FY - 335
	ESx := FX + 330
	ESy := FY - 15
	SPGx[3] := FX - 71
	SPGx[5] := FX + 75
	PGy := FY - 20
	REx := FX - 255
	REy := FY - 97
	MAPx[2] := FX + 252
	MAPy[2] := FY - 247
	MAPx[4] := FX + 252
	MAPy[4] := FY - 100
	LAx := FX + 69
	LAy := FY - 275
	ESBx := FX + 130
	ESBy := FY - 221
	CNBx := FX - 88
	CNBy := FY - 216
	RBx := FX - 128
	RBy := FY - 294
	BBx := FX + 361
	BBy := FY - 169
	BCx := FX + 128
	BCy := FY - 55
	CCx := FX + 353
	CCy := FY - 324
	return
}
		
Initialize()
{
    global
	SPGx := Array(item)
	MAPx := Array(item)
	MAPy := Array(item)
    Q := Array()
}

GuiClose:
{
	WinGetPos,TWinX,TWinY
	IniWrite,%TWinX%,config.ini,Variables,LastXS
	IniWrite,%TWinY%,config.ini,Variables,LastYS
	ExitApp 
}

;To-do list


;ChangeLog


