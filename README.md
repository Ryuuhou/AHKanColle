
AHKanColle (Click script for KanColle expeditions)
--

by Ryuuhou

README 6/2/15

>scripting

>kuso ttk

## Requirements: 

* AHK_L
* Gdip_All library by tic

## Features:

* Background scripting (cannot be minimized)
* Dynamic pixel checking to prevent user error
* Easy to use GUI with changeable settings
* Error Cat detection (script will be paused)
* Can be set up to pause/resume at a certain time

## How to use: AHKanColle
Set which expedition each fleet will run, press ENTER to submit.  
Use expedition 0 to disable resending that fleet.

Enter a remaining time if it is currently already on an expedition. The following syntax are allowed for the time 2 hours 2 minutes and 2 seconds. 02:02:02 | 2:2:2 | 2h2m2s

If it is not on an expedition, use 0 to resupply and send after pushing the button "Send Expeditions."

Use a remaining time of -1 to disable scripting for that fleet.

Enter a MinWait and MaxWait in MILLISECONDS. The script will wait a random amount of time between these two numbers after an expedition comes back.

If you are not playing with KanColleViewer, add/create an entry in the config.ini file in the script directory. As shown below -

>[Variables]
>WINID = NameOfWindow

If using a browser, the name of window will usually be in the titlebar.

## How to use: Pause Utility

Simple pause script that runs alongside AHKanColle.

Enter in config.ini under [Variables], PauseHr=22 , and PauseMn=22 to pause at 22:22.  Use 24 Hour format only. You may use PCSleep=1 to sleep the computer at that time as well.

Use ResumeHr and ResumeMn to have the script resume at a specific time. Can be omitted for pause functionality only. When resume is enabled, PCSleep will be ignored and expired timers will automatically be set to pause/resume 24 hours later.

## How to use: AHKCSortie

Sortie script that should be used along with AHKanColle. GUI is pretty self explanatory.  Set the map you would like to script (only does the first node), set an interval if you would like it to automatically send again, and press start.
Currently, only world 3 and 5, maps 2 and 4, are supported (3-2,3-4,5-2,5-4) though only 3-2 and 5-4 are recommended.  The script will check for critically damaged ships and resupply before each sortie.

Some recommended intervals:
1000 for fatigue grinding
900000 for full morale recovery (recommended for 5-4)
Use a -1 interval to disable auto sending.  

I AM NOT RESPONSIBLE IF THIS SCRIPT BUGS AND SINKS YOUR SHIP. Use at your own risk.

## Warnings:
Do NOT use hardware acceleration on your browsers or use "Direct/GPU" on KCV unless your computer is set to never idle.  When the computer idles, hardware acceleration is turned off and flash no longer renders.

Although this script was designed to work in background, certain applications may lose focus while scripting.

Do NOT minimize browser/KCV, mouse clicks do not work while minimized. It can be behind other windows.

If you have not unlocked all expeditions, your expeditions may be out of place and cause problems.  It is up to you to change the constants within the script if you wish to use it.

Playing while scripting may lead to bugging the script, avoid playing if you decide to script. Unless you know how the script works :^)
