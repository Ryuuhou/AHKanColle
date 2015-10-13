Click v1.03 10/12/15

ClickS(x,y)
{
	global hwnd
	global Background
	WinActivateRestore()
	if Background = 1
	{
		ControlClick, x%x% y%y%, ahk_id %hwnd%,,,,NA
	}
	else
	{
		Click %x%, %y%
	}
}