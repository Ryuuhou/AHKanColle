Click v1.02 10/11/15

ClickS(x,y)
{
	global hwnd
	global Background
	if Background = 1
	{
		ControlClick, x%x% y%y%, ahk_id %hwnd%,,,,NA
	}
	else
	{
		if not hwnd = 0
		{
			WinActivate
			Click %x%, %y%
		}
	}
}