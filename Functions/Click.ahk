;Click v1.04 11/26/15

ClickS(x,y)
{
	global uid
	global Background
	global XDiff
	global YDiff
	WinActivateRestore()
	if Background = 1
	{
		SetControlDelay -1
		ControlClick, x%x% y%y%, ahk_id %uid%,,,,NA Pos
	}
	else if Background = 0
	{
		Click %x%, %y%
	}
	else if Background = 2
	{
		SetControlDelay -1
		tx := x-XDiff
		ty := y-YDiff
		ControlClick, Internet Explorer_Server1,ahk_id %uid%,,,, x%tx% y%ty%
		if ErrorLevel = 1 
		{
			MsgBox NotFound
		}
	}
	return
}