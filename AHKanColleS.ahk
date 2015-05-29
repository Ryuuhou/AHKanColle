;AHKanColleS v1.09 5/24/15
#Persistent
#SingleInstance
#Include %A_ScriptDir%/Functions/Gdip_All.ahk ;Thanks to tic (Tariq Porter) for his GDI+ Library => ahkscript.org/boards/viewtopic.php?t=6517
CoordMode, Pixel, Relative

Initialize()

IniRead, WINID, config.ini, Variables, WINID, KanColleViewer!

MiscDelay := 1000

;PixelColor Contants

#Include %A_ScriptDir%/Constants/PixelColor.ahk

RTI := 2000 ;Refresh interval for GUI

IniRead, TWinX, config.ini, Variables, LastXS, 0
IniRead, TWinY, config.ini, Variables, LastYS, 0
IniRead, World, config.ini, Variables, World, 0
IniRead, Map, config.ini, Variables, Map, 0
IniRead, SortieInterval, config.ini, Variables, SortieInterval, 300000
Gui, 1: New
Gui, 1: Default
Gui, Add, Edit, r1 w20 vNB ReadOnly
GuiControl, Move, NB, w300
Menu, Main, Add, Pause, Pause2
Gui, Menu, Main
Gui, Show, X%TWinX% Y%TWinY% Autosize, AHKanColleS
SetWindow()
SetTimer, Sortie, %SortieInterval%
return
    
Repair()
{
	global
	tpc2 := PixelGetColorS(FX,FY,3)
	if (tpc2 != HPC)
	{
		ControlClick, x%Hx% y%Hy%, %WINID%
		GuiControl,, NB, Waiting for home screen
		WaitForPixelColor(FX,FY,HPC)
	}
	ControlClick, x%REx% y%REy%, %WINID%
	GuiControl,, NB, Waiting for repair screen
	WaitForPixelColor(FX,FY,REPC)
	Sleep MiscDelay
	Loop
	{
		ControlClick, x%RBx% y%RBy%, %WINID%
		Sleep MiscDelay
		tpc2 := PixelGetColorS(CCx,CCy,3)
		if (tpc2 = CCPC)
		{
			GuiControl,, NB, Critical HP detected, repairing
			ControlClick, x%CCx% y%CCy%, %WINID%
			Sleep 500
			ControlClick, x%BBx% y%BBy%, %WINID%
			Sleep 500
			ControlClick, x%ESx% y%ESy%, %WINID%
			Sleep 500
			ControlClick, x%BCx% y%BCy%, %WINID%	
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
		Repair()
		Resupply(1)
		tpc2 := PixelGetColorS(FX,FY,3)
		if (tpc2 != HPC)
		{
			ControlClick, x%Hx% y%Hy%, %WINID%
			GuiControl,, NB, Waiting for home screen
			WaitForPixelColor(FX,FY,HPC)
		}
		ControlClick, x%Sx% y%Sy%, %WINID%
		GuiControl,, NB, Waiting for sortie screen
        WaitForPixelColor(FX,FY,SPC)
		ControlClick, x%S2x% y%S2y%, %WINID%
		GuiControl,, NB, Waiting for sortie selection screen
        WaitForPixelColor(FX,FY,S2PC)
		tf := SPGx[World]
		ControlClick, x%tf% y%PGy%, %WINID%
		GuiControl,, NB, Starting sortie
		Sleep MiscDelay
		tfx := MAPx[Map]
		tfy := MAPy[Map]
		ControlClick, x%tfx% y%tfy%, %WINID%
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, %WINID%
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, %WINID%
		GuiControl,, NB, Waiting for compass
		WaitForPixelColor(LAx,LAy,CPC)
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, %WINID%
		GuiControl,, NB, Waiting for formation
		WaitForPixelColor(LAx,LAy,FPC)
		Sleep MiscDelay
		ControlClick, x%LAx% y%LAy%, %WINID%
		GuiControl,, NB, Waiting for results
		tpc2 := WaitForPixelColor(FX,FY,SRPC,NBPC,,300000)
		if tpc2 = 2
		{
			Sleep 3000
			ControlClick, x%CNBx% y%CNBy%, %WINID%
		}
		GuiControl,, NB, Waiting for end sortie
		WaitForPixelColor(FX,FY,CSPC,,1)
		GuiControl,, NB, End sortie found
		Sleep 3000
		ControlClick, x%ESBx% y%ESBy%, %WINID%
		WaitForPixelColor(FX,FY,HPC,HEPC)
		GuiControl,, NB, Idle
		SetTimer, Sortie, %SortieInterval%
	}
	else
	{
		SetTimer, Sortie, 30000
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
        WaitForPixelColor(FX,FY,HPC)
        ControlClick, x%Rx% y%Ry%, %WINID%
    }
	WaitForPixelColor(FX,FY,RPC)
	GuiControl,, NB, Resupplying expedition %r%
    Sleep MiscDelay
	tpc := PixelGetColorS(SAx,SAy,2)
	if (tpc != RRPC)
	{
		ControlClick, x%SAx% y%SAy%, %WINID%
		Sleep MiscDelay
		ControlClick, x%ESx% y%ESy%, %WINID%
		WaitForPixelColor(FX,FY,RPC)
	}
	return
}

#Include %A_ScriptDir%/Functions/PixelCheck.ahk
#Include %A_ScriptDir%/Functions/Pause.ahk

SetWindow()
{
	global
	Sleep 300
	RCount := 1
	Loop
	{
		hwnd := 0
		hwnd := WinExist(WINID)
		if not hwnd = 0
		{
			WinActivate
			WinGetPos, , , WinW, WinH
			GuiControl,, NB, Window found
			Break
		}    
		else
		{
			GuiControl,, NB, Window not found. Retrying (%RCount%)
			Sleep 1000
			RCount += 1
			if RCount > 30
			{
				GuiControl,, NB, Could not find window, unpause script to try again
				RCount := 1
				Pause
			}
		}
	}
	PixelMap()
}

PixelMap()
{
	global
	RCount := 1
	Loop
	{
		WinActivate, ahk_id %hwnd%
		PSS := 0
		PixelSearch, BX1, BY1, 0, 0, WinW, WinH, BPC1, 1, Fast RGB
		PixelGetColor, BPCT, BX1+1, BY1, RGB
		if (ErrorLevel = 0 and BPCT = BPC2)
		{
			PSS := 1
		}	
		else
		{
			PixelSearch, BX1, BY1, 0, 0, WinW, WinH, BEPC1, 1, Fast RGB
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
			MAPx[1] := FX - 102
			MAPy[1] := FY - 250
			MAPx[2] := FX + 252
			MAPy[2] := FY - 247
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
			index := 1
			GuiControl,, NB, Ready
			return
		}
		else
		{
			GuiControl,, NB, Invalid Screen, Retrying (%RCount%)
			Sleep 1000
			RCount += 1
			if RCount > 30
			{
				GuiControl,, NB, Could not find reference pixel, unpause script to try again
				RCount := 1
				Pause
			}
		}
	}
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


