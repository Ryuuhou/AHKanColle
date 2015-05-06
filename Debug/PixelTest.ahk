;KANCOLLE AHK EXPEDITION SCRIPT GUI V0.97 4/19/15
#Persistent
#SingleInstance
#Include Gdip_All.ahk ;Thanks to tic (Tariq Porter) for his GDI+ Library => ahkscript.org/boards/viewtopic.php?t=6517
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
LastPixel := 0

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
	tpc := 0
	Gui, 1: New
	Gui, 1: Default
	Gui, Add, Edit, r1 w20 vNB ReadOnly
	GuiControl, Move, NB, w100
	Gui, Show, Autosize
	Loop
	{
		tpc := PixelGetColorS(FoundX,FoundY)
		Sleep 100
	}
}
else
{
    MsgBox KanColle is not on home screen
    Exit
}
return
    

PixelGetColorS(x,y)
{
	global
	pToken  := Gdip_Startup()
	pBitmap := Gdip_BitmapFromHWND(hwnd)
	pARGB := GDIP_GetPixel(pBitmap, x, y)
	pHEX := DEC2HEX(pARGB,"true")
	if not LastPixel = pHEX
	{
		LastPixel := pHEX
		FileAppend, %pHEX% `n, %A_ScriptDir%/PixelTest.txt	
	}
	GuiControl,, NB, %pHEX%
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

;0x4acacd = main menu
;0x42b6b8 = main menu + exped
;0x49afb1 = fleet selection
;0x41413c = " "
;0xeee6d9 = resupply
;0x293137 = sortie menu
;0xede6d9 = expeditions


