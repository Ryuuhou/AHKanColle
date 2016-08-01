;Notify v1.60801

Notify(n,m,i)
{
	global NotificationLevel
	if (NotificationLevel >= i)
	{
		TrayTip, %n%, %m%, , 48
	}
return
}