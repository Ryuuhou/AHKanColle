;AHKCSortie v1.60816

#Persistent
#SingleInstance
#Include %A_ScriptDir%/Functions/Gdip_All.ahk ;Thanks to tic (Tariq Porter) for his GDI+ Library => ahkscript.org/boards/viewtopic.php?t=6517

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}
CoordMode, Pixel, Relative
Menu, Tray, Icon, %A_ScriptDir%/Icons/favicon_ahkcsortie.ico,,1

IniRead, Background, config.ini, Variables, Background, 1
IniRead, Class, config.ini, Variables, Class, 0

Initialize()

IniRead, WINID, config.ini, Variables, WINID, KanColleViewer!

MiscDelay := 1000

;PixelColor Constants

#Include %A_ScriptDir%/Constants/PixelColor.ahk

BC := 0
BusyS := 0
TR := 0
DT := 0
Nodes := 1

IniRead, NotificationLevel, config.ini, Variables, NotificationLevel, 1
IniRead, TWinX, config.ini, Variables, LastXS, 0
IniRead, TWinY, config.ini, Variables, LastYS, 0
SpecificWindows()
IniRead, World, config.ini, Variables, World, %A_Space%
IniRead, Map, config.ini, Variables, Map, %A_Space%
IniRead, DisableCriticalCheck, config.ini, Variables, DisableCriticalCheck, 0
IniRead, Sparkling, config.ini, Variables, Sparkling, 0
IniRead, DisableResupply, config.ini, Variables, DisableResupply, 0
IniRead, SortieInterval, config.ini, Variables, SortieInterval, -1 ;900000 for full morale
IniRead, MinRandomWait, config.ini, Variables, MinRandomWaitS, 0
IniRead, MaxRandomWait, config.ini, Variables, MaxRandomWaitS, 300000
Gui, 1: New
Gui, 1: Default
Gui, Add, Text,, Map:
Gui, Add, Text,, MinWait:
Gui, Add, Text,, MaxWait:
Gui, Add, Edit, r1 w20 vNB ReadOnly
GuiControl, Move, NB, x10 w300 y80
Gui, Add, Edit, gWorldF r2 limit3 w10 vWorldV -VScroll ym, %World%
GuiControl, Move, WorldV, x37 h17 w15
Gui, Add, Text, x55 ym, -
Gui, Add, Edit, gMapF r2 limit3 w10 vMapV -VScroll ym, %Map%
GuiControl, Move, MapV, x62 h17 w15
Gui, Add, Text, ym, Interval(ms):
Gui, Add, Edit, gIntervalF r2 w15 vIntervalV -VScroll ym, %SortieInterval%
GuiControl, Move, IntervalV, h17 w70
Gui, Add, Text, vText, #Nodes
GuiControl, Move, Text, x150 y35
Gui, Add, Edit, gNodeCount r2 limit3 w10 vNodeCount -VScroll ym, %Nodes%
GuiControl, Move, NodeCount, x195 y33 h17 w25
Gui, Add, Button, gSSBF vSSB, A
GuiControl, Move, SSB, x250 w60 ym
GuiControl,,SSB, Start
Gui, Add, Edit, gMiW r2 w20 vmid -VScroll, %MinRandomWait%
GuiControl, Move, mid, h20 x60 y30 w80
Gui, Add, Edit, gMaW r2 w20 vmad -VScroll, %MaxRandomWait%
GuiControl, Move, mad, h20 x60 y55 w80
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
		ClickS(Hx,Hy)
		GuiControl,, NB, Waiting for home screen
		pc := []
		pc := [HPC,HEPC]
		WaitForPixelColor(FX,FY,pc)	
	}
	ClickS(REx,REy)
	GuiControl,, NB, Waiting for repair screen
	pc := []
	pc := [REPC]
	WaitForPixelColor(FX,FY,pc)
	Sleep MiscDelay
	Loop
	{
		GuiControl,, NB, Checking HP states
		ClickS(RBx,RBy)
		Sleep MiscDelay
		tpc2 := PixelGetColorS(CCx,CCy,3)
		if (tpc2 = CCPC)
		{
			Notify("AHKCSortie", "Critical HP detected, repairing",1)
			GuiControl,, NB, Critical HP detected, repairing
			ti := BC+1
			Menu, Main, Rename, %BC%, %ti%
			BC += 1
			ClickS(CCx,CCy)
			Sleep 500
			ClickS(BBx,BBy)
			Sleep 500
			ClickS(ESx,ESy)
			Sleep 500
			ClickS(BCx,BCy)	
			pc := []
			pc := [REPC]
			WaitForPixelColor(FX,FY,pc)
			Sleep 9000			
		}
		else
		{
			Notify("AHKCSortie", "HP check completed",2)
			GuiControl,, NB, HP check completed
			return
		}
	}	
}

Delay:
{
	IniRead, Busy, config.ini, Do Not Modify, Busy, 1
	if DT = 0
	{
		DT := 1
		Random, SR, MinRandomWait, MaxRandomWait
		QTS := A_TickCount
		QTL := SR
		SetTimer, NBUpdate, 2000
		tSS := MS2HMS(GetRemainingTime(QTS,QTL))
		Notify("AHKCSortie", "Starting sortie in " . tSS,1)
		Sleep SR
		goto Delay
	}
	else if (Busy = 0 and BusyS = 0)
	{	
		{
			goto Sortie
		}
	}
	else
	{
		if (Busy = 1 and BusyS = 0)
		{
			GuiControl,, NB, An expedition is returning, retrying every 10 seconds
			SetTimer, NBUpdate, Off
		}
		SetTimer, Delay, 10000
	}
	return
}

Sortie:
{
	SetTimer, NBUpdate, Off
	SetTimer, Delay, Off
	BusyS := 1
	DT := 0
	TR := 0
	GuiControl, Hide, SSB
	CheckWindow()
	Notify("AHKCSortie", "Preparing to send sortie",1)
	if not (BP = 1 and DisableCriticalCheck = 1)
	{
		if not (World = 1 and Map = 1 and Sparkling = 1)
		{
			Repair()
		}
	}
	if not (BP = 1 and DisableResupply = 1)
	{
		Resupply(1)
	}
	tpc2 := PixelGetColorS(FX,FY,3)
	if (tpc2 != HPC)
	{
		ClickS(Hx,Hy)
		GuiControl,, NB, Waiting for home screen
		pc := []
		pc := [HPC]
		WaitForPixelColor(FX,FY,pc)
	}
	ClickS(Sx,Sy)
	GuiControl,, NB, Waiting for sortie screen
	pc := []
	pc := [SPC]
    WaitForPixelColor(FX,FY,pc)
	ClickS(S2x,S2y)
	GuiControl,, NB, Waiting for sortie selection screen
	pc := []
	pc := [S2PC]
	WaitForPixelColor(FX,FY,pc)
	tf := SPGx[World]
	ClickS(tf,PGy)
	GuiControl,, NB, Starting sortie
	Sleep MiscDelay
	if(World = 1 and Map = 5)
		{
		ClickS(Extrax,Extray)
		}
	tfx := MAPx[Map]
	tfy := MAPy[Map]
	ClickS(tfx,tfy)
	Sleep MiscDelay
	ClickS(ESx,ESy)
	Sleep MiscDelay
	ClickS(ESx,ESy)
	Notify("AHKCSortie", "Sortie started",1)
	if SortieInterval != -1
	{
		SetTimer, Delay, %SortieInterval%
		TR := 1
		TCS := A_TickCount
	}
	NC := 1
	Loop
	{
		GuiControl,, NB, Waiting for compass/formation
		pc := []
		pc := [CPC,FPC,IBPC]
		tpc := WaitForPixelColor(LAx,LAy,pc,,,30)
		Sleep MiscDelay
		if(World = 1 and Map = 5)
		{
			ClickS(ESx,ESy)
			GuiControl,, NB, Waiting for formation
			pc := []
			pc := [FPC,IBPC]
			tpc2 := WaitForPixelColor(LAx,LAy,pc)
			if tpc2 = 1
			{
				Sleep MiscDelay
				ClickS(LAbreastx,LAbreasty)
			}
		}
		if tpc = 1
		{
			ClickS(ESx,ESy)
			GuiControl,, NB, Waiting for formation
			pc := []
			pc := [FPC,IBPC]
			tpc2 := WaitForPixelColor(LAx,LAy,pc)
			if tpc2 = 1
			{
				Sleep MiscDelay
				ClickS(LAx,LAy)
			}
		}
		else if tpc = 2 
		{
			ClickS(LAx,LAy)	
		}
		GuiControl,, NB, Waiting for results
		pc := []
		pc := [SRPC,NBPC]
		WaitForPixelColor(FX,FY,pc,,,250)
		Sleep 5000
		tpc := WaitForPixelColor(FX,FY,pc)
		if tpc = 2
		{
			GuiControl,, NB, Cancelling night battle
			Sleep 3000
			ClickS(CNBx,CNBy)
		}
		GuiControl,, NB, Waiting...
		pc := []
		pc := [HPC,HEPC,CSPC]
		tpc := WaitForPixelColor(FX,FY,pc,FX,FY)
		if tpc = 1 or tpc = 2
		{
			Break
		}
		else if tpc = 3
		{
			GuiControl,, NB, Continue screen
			Sleep 2000
			if (NC = Nodes)
			{
				GuiControl,, NB, Ending sortie
				ClickS(ESBx,ESBy)
			}
			else
			{
				Notify("AHKCSortie", "Proceeding to next node",2)
				GuiControl,, NB, Continuing Sortie
				ClickS(CSBx,CSBy)
			}
		}
		NC += 1
	}Until NC > Nodes
	GuiControl,, NB, Waiting for home screen
	pc := []
	pc := [HPC,HEPC]
	WaitForPixelColor(FX,FY,pc,ESBx,ESBy)
	Notify("AHKCSortie", "Sortie completed",1)
	GuiControl,, NB, Idle
	BusyS := 0
	GuiControl, Show, SSB
	if SortieInterval != -1
	{
		BP := 0
		SetTimer, NBUpdate, 2000
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
	GuiControl,, NB, Resupplying fleet %r%
    Sleep MiscDelay
	rti := 0
	rti2 := 5
	if (World = 1 and Map = 1 and Sparkling = 1)
	{
		rti2 := 0
	}
	Loop
	{
		ClickS(SAx,SAy+50*rti)
		rti := rti+1
		Sleep 1
	}Until (rti > rti2)
	ClickS(ESx,ESy)
	pc := []
	pc := [RPC]
	WaitForPixelColor(FX,FY,pc)
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
		if (WorldV=1 or WorldV=3 or WorldV=5)
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
		if (MapV=1 or MapV=2 or MapV=4 or MapV=5)
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

NodeCount:
{
	Gui, submit,nohide
	if NodeCount contains `n
	{
		StringReplace, NodeCount, NodeCount, `n,,All
		GuiControl,, NodeCount, %NodeCount%
		Send, {end}
		if (NodeCount > 0 and NodeCount < 4)
		{
			Nodes := NodeCount
			if Nodes > 1
			{
				MsgBox WARNING: Script will continue past first node and will NOT check for critical damage. You risk sinking any girl that is not flagship.
			}
			GuiControl,, NB, # of nodes set
		}
		else
		{
			GuiControl,, NB, Invalid entry, must be within 1 and 3
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
				SetTimer, Delay, Off
				SetTimer, NBUpdate, Off
				TR := 0
			}
			else
			{
				if TR = 1
				{
					tt := SortieInterval - A_TickCount + TCS
					if tt < 0
					{
						tt := 1000
					}
					SetTimer, Delay, %tt%
				}
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

MiW:
{
	Gui, submit,nohide
	if mid contains `n
	{
		StringReplace, mid, mid, `n,,All
		GuiControl,, mid, %mid%
		Send, {end}
		MinRandomWait := mid
		IniWrite,%mid%,config.ini,Variables,MinRandomWaitS
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
		IniWrite,%mad%,config.ini,Variables,MaxRandomWaitS
		GuiControl,, NB, Changed max random delay
	}
	return
}

SSBF:
{
	if (Map < 1 or World < 1)
	{
		MsgBox Map or world invalid. Press enter after each field to submit.
		return
	}
	GuiControl, Hide, SSB
	BP := 1
	DT := 1
	goto Delay
	return
}

NBUpdate:
{
	if DT = 0
	{
		ts := Round((TCS + SortieInterval - A_TickCount)/60000,2)
		GuiControl,, NB, Idle - Restarting in %ts% minutes
	}
	else
	{
		tSS := MS2HMS(GetRemainingTime(QTS,QTL))
		GuiControl,, NB, Delay - %tSS%
	}
	return
}

DN:
{
	return
}

#Include %A_ScriptDir%/Functions/Click.ahk
#Include %A_ScriptDir%/Functions/TimerUtils.ahk
#Include %A_ScriptDir%/Functions/PixelCheck.ahk
#Include %A_ScriptDir%/Functions/Pause.ahk
#Include %A_ScriptDir%/Functions/Window.ahk
#Include %A_ScriptDir%/Functions/PixelSearch.ahk
#Include %A_ScriptDir%/Functions/PixelMap.ahk
#Include %A_ScriptDir%/Functions/Notify.ahk

	
Initialize()
{
    global
	SPGx := Array(item)
	MAPx := Array(item)
	MAPy := Array(item)
	pc := Array(item)
    Q := Array()
	NC := 0
	coffset := 2
}

GuiClose:
{
	WinGetPos,TWinX,TWinY
	IniWrite,%TWinX%,config.ini,Variables,LastXS
	IniWrite,%TWinY%,config.ini,Variables,LastYS
	ExitApp 
}