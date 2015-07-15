Click v1.01 7/14/15

ClickS(x,y)
{
	global hwnd
	global Background
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