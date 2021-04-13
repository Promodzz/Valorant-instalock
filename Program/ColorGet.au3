While True
   ConsoleWrite(PixelGetColor(889, 819))
   ConsoleWrite(" --- ")
   Sleep(1000)

   If PixelGetColor(889, 819) = 14740212 And PixelGetColor(765,898) = 14609388 And PixelGetColor(755,941) = 13014921 And PixelGetColor(718,952) = 2172988 Then
	  MouseClick("left",718,952,5,0)
	  Sleep(50)
	  MouseClick("left",959,814,5,0)
   EndIf
WEnd