Set sh = CreateObject("WScript.Shell")

' Try to activate by window title
If sh.AppActivate("Playnite") = False Then
  ' Fallback: activate by process-friendly title pattern
  sh.AppActivate("Playnite Fullscreen")
End If
