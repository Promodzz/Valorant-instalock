While True
   ;ConsoleWrite(PixelGetColor(1027, 908))
   ;ConsoleWrite(" --- ")
   ;ConsoleWrite(PixelGetColor(1000, 944))
   ;ConsoleWrite(" --- ")
   ;ConsoleWrite(PixelGetColor(983, 940))
   ;ConsoleWrite(" --- ")
   ;Sleep(5000)

   If PixelGetColor(889, 819) = 14740212 And PixelGetColor(1027, 908) = 5065045 And PixelGetColor(1000, 944) = 14924191 And PixelGetColor(983, 940) = 3800518 Then
	  MouseClick("left",1000,944,5,0)
	  Sleep(50)
	  MouseClick("left",959,814,5,0)
	  ;ConsoleWrite("puurrrfect")
   EndIf
WEnd