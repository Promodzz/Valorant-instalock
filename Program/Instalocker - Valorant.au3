; ===============================================================================================================================
; Name ..........: MetroGUI UDF
; Version .......: v5.1
; Style Author ........: BB_19
; ===============================================================================================================================

;!Highly recommended for improved overall performance and responsiveness of the GUI effects etc.! (after compiling):
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe

;YOU NEED TO EXCLUDE FOLLOWING FUNCTIONS FROM AU3STRIPPER, OTHERWISE IT WON'T WORK:
#Au3Stripper_Ignore_Funcs=_iHoverOn,_iHoverOff,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete
;Please not that Au3Stripper will show errors. You can ignore them as long as you use the above Au3Stripper_Ignore_Funcs parameters.

; ===============================================================================================================================

#NoTrayIcon
#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include "MetroGUI-UDF\_GUIDisable.au3" ; For dim effects when msgbox is displayed
#include <GUIConstants.au3>

;=======================================================================Creating the GUI===============================================================================
;_Metro_EnableHighDPIScaling() ; Note: Requries "#AutoIt3Wrapper_Res_HiDpi=y" for compiling. To see visible changes without compiling, you have to disable dpi scaling in compatibility settings of Autoit3.exe

;Set Theme
_SetTheme("DarkTeal") ;See MetroThemes.au3 for selectable themes or to add more

;Create resizable Metro GUI
$Form1 = _Metro_CreateGUI("Instalocker", 500, 300, -1, -1, True)

;Add/create control buttons to the GUI
$Control_Buttons = _Metro_AddControlButtons(True, False, True, False, True) ;CloseBtn = True, MaximizeBtn = True, MinimizeBtn = True, FullscreenBtn = True, MenuBtn = True

;Set variables for the handles of the GUI-Control buttons. (Above function always returns an array this size and in this order, no matter which buttons are selected.)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_MENU_BUTTON = $Control_Buttons[6]
;======================================================================================================================================================================

;Create  Buttons
;$Button1 = _Metro_CreateButton("Hide", 188, 235, 115, 40) ;Not now

GUICtrlCreateLabel("Menu", 50, 0, 62, 32, 0x0200)
GUICtrlSetFont(-1, 11, 600, Default, "Segoe UI", 5)
GUICtrlSetColor(-1, 0xDEDEDE)

GUICtrlCreateLabel("Valorant Instalocker", 100, 90, 160, 32, 0x0200)
GUICtrlSetFont(-1, 11, 600, Default, "Segoe UI", 5)
GUICtrlSetColor(-1, 0xDEDEDE)

Global $textBox = GUICtrlCreateLabel("Enable the program...", 50, 150, 160, 32, 0x0200)
GUICtrlSetFont(-1, 9, 300, Default, "Segoe UI", 5)
Global $textColor = GUICtrlSetColor(-1, 0xFF0000)

GUICtrlCreateLabel("Coded By: Nekoraru22", 10, 270, 160, 32, 0x0200)
GUICtrlSetFont(-1, 9, 100, 2, "Segoe UI", 5)
GUICtrlSetColor(-1, 0xDEDEDE)

Global $icon = GUICtrlCreateIcon("unknown.ico", "icon", 350, 93, 90, 90)

$ctrlCombo = GUICtrlCreateCombo("Select", 50, 130, 250, 250, 0x0003)
GUICtrlSetData(-1, "Jett|Sage|Yoru|Raze|Skye|Omen|Astra|Breach|Brimstone|Cypher|Killjoy|Phoenix|Reyna|Sova|Viper")
Global $champ = GUICtrlRead($ctrlCombo)

$Toggle3 = _Metro_CreateOnOffToggle("Enabled", "Disabled", 188, 240, 130, 30)
Global $check = False

GUICtrlSetOnEvent($Toggle3, "_GUIEvent_Toggles")

GUISetState(@SW_SHOW)

Global $char = 0

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
			_Metro_GUIDelete($Form1) ;Delete GUI/release resources, make sure you use this when working with multiple GUIs!
			Exit
		Case $GUI_MINIMIZE_BUTTON
			GUISetState(@SW_MINIMIZE, $Form1)
		Case $GUI_MENU_BUTTON
			;Create an Array containing menu button names
			Local $MenuButtonsArray[2] = ["Repository", "Contact"]
			; Open the metro Menu. See decleration of $MenuButtonsArray above.
			Local $MenuSelect = _Metro_MenuStart($Form1, 150, $MenuButtonsArray)
			Switch $MenuSelect ;Above function returns the index number of the selected button from the provided buttons array.
				Case "0"
					ShellExecute("https://github.com/Nekoraru22/Valorant-instalock")
				 Case "1"
					_GUIDisable($Form1, 0, 30)
					Local $copy = _Metro_MsgBox(4, "Contact", "Hi, My name is Neko and you can find me in Discord like:" & @LF & @LF & "Neko-san#4592" & @LF & @LF & "     [ · ] Do you want to copy it?", 450, 11, $Form1)
				    If $copy = "Yes" Then
					   ConsoleWrite("copied" & @CRLF)
					   ClipPut("Neko-san#4592")
				    EndIf
					_GUIDisable($Form1)
			EndSwitch
		;Case $Button1
		;	ConsoleWrite("Hide" & @CRLF)
		;	GUISetState(@SW_HIDE)

	    Case $Toggle3
			If _Metro_ToggleIsChecked($Toggle3) Then
				_Metro_ToggleUnCheck($Toggle3)
				GUICtrlSetData($textBox,"Enable the program...")
				GUICtrlSetImage($icon, "unknown.ico")
				GUICtrlSetColor($textBox, 0xFF0000)
				Global $check = False
			Else
				_Metro_ToggleCheck($Toggle3)
				ConsoleWrite(@CRLF & "Enabled!")
				Global $check = True
			 EndIf

		Case $ctrlCombo
			Global $champ = GUICtrlRead($ctrlCombo)
		 EndSwitch

	    If $check = "True" Then
		    If $champ = "Select" Then
			   wait(1)

			ElseIf $champ = "Jett" Then
			   GUICtrlSetData($textBox, "Jett selected")
			   GUICtrlSetImage($icon, "jett_icon.ico")
			   GUICtrlSetColor($textBox, 0x00FF00)
			   Jett()

			ElseIf $champ = "Sage" Then
			   GUICtrlSetData($textBox, "Sage selected")
			   GUICtrlSetImage($icon, "sage_icon.ico")
			   GUICtrlSetColor($textBox, 0x00FF00)
			   Sage()
			Else
			   wait(2)
			EndIf
	    EndIf
WEnd

Func Jett()
   If PixelGetColor(889, 819) = 14740212 And PixelGetColor(765,898) = 14609388 And PixelGetColor(755,941) = 13014921 And PixelGetColor(718,952) = 2172988 Then
	  MouseClick("left",718,952,5,0)
	  Sleep(50)
	  MouseClick("left",959,814,5,0)
   EndIf
EndFunc

Func Sage()
   If PixelGetColor(889, 819) = 14806005 And PixelGetColor(999, 940) = 15448743 And PixelGetColor(1000, 944) = 14924191 And PixelGetColor(983, 940) = 3800518 Then
	  MouseClick("left",1000,944,5,0)
	  Sleep(50)
	  MouseClick("left",959,814,5,0)
   EndIf
EndFunc

Func wait($number)
   If $number = 1 And GUICtrlRead($textBox) <> "Please, select a champ..." Then
	  GUICtrlSetData($textBox, "Please, select a champ...")
	  GUICtrlSetImage($icon, "unknown.ico")
	  GUICtrlSetColor($textBox, 0xFF0000)

   ElseIf $number = 2 And GUICtrlRead($textBox) <> "Coming soon" Then
	  GUICtrlSetData($textBox, "Coming soon")
	  GUICtrlSetImage($icon, "soon.ico")
	  GUICtrlSetColor($textBox, 0xFFFF00)

   EndIf
EndFunc