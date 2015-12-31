;PixelTest for AHKanColle v1.0 5/15/15
#Persistent
#SingleInstance
#Include Gdip_All.ahk ;Thanks to tic (Tariq Porter) for his GDI+ Library => ahkscript.org/boards/viewtopic.php?t=6517
CoordMode, Pixel, Relative

IniRead, WINID, config.ini, Variables, WINID, KanColleViewer!

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

;PixelColor Contants

HPC := 0x4acacd ;Home
HEPC := 0x42b6b8 ;Home + Exped
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

LastPixel := 0

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
	CCx := FX + 353
	CCy := FY - 324
    CM := 1
	tpc := 0
	Gui, 1:New
	Gui, 1:Default
	Gui, Add, Edit, r1 w20 vNB ReadOnly
	GuiControl, Move, NB, w100
	Gui, Show, Autosize
	Loop
	{
		PixelGetColorS(FX,FY)
		Sleep 100
	}
}
else
{
    MsgBox KanColle is not on a valid screen
    ExitApp
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
		GuiControl,, NB, %pHEX%
		FileAppend, %pHEX% `n, %A_ScriptDir%/PixelTest.txt	
	}
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