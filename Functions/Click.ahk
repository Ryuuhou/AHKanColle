;Click v1.05 11/26/15

ClickS(x,y)
{
	global uid
	global Background
	global XDiff
	global YDiff
	global Class
	WinActivateRestore()
	if Background = 1
	{
		SetControlDelay -1
		if Class = 0
		{
			ControlClick, x%x% y%y%, ahk_id %uid%,,,,NA Pos
		}
		else
		{
			tx := x-XDiff
			ty := y-YDiff
			ControlClick, %Class%,ahk_id %uid%,,,, x%tx% y%ty%
		}
	}
	else if Background = 0
	{
		Click %x%, %y%
	}
	return
}