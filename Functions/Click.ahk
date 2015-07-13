Click v1.0 7/13/15

ClickS(x,y)
{
	global hwnd
	if Background = 1
	{
		ControlClick, x%x% y%y%, ahk_id %hwnd%
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