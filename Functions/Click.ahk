Click v1.031 10/13/15

ClickS(x,y)
{
	global uid
	global Background
	WinActivateRestore()
	if Background = 1
	{
		ControlClick, x%x% y%y%, ahk_id %uid%,,,,NA
	}
	else
	{
		Click %x%, %y%
	}
}