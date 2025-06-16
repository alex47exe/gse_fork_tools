#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Array.au3>
#include <File.au3>
#include <ComboConstants.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
;#include "_Include\_UDF\_ArrayNaturalSort.au3" ; thanks to wraithdu - https://www.autoitscript.com/forum/topi ... comparison
;#include <..\..\_Include\_UDF\_Zip_Functions.au3> ; thanks to wraithdu - https://www.autoitscript.com/forum/topi ... /#comments

$game_appid = FileReadLine(@ScriptDir & "\_steam_appid_\game_appid.txt", 1)
$game_name = FileReadLine(@ScriptDir & "\_steam_appid_\game_name.txt", 1)

Local $a_appid, $a_name
$appid_dir = _FileListToArray(@ScriptDir & "\_steam_appid_", "*.txt", $FLTA_FILES)
For $i = 1 to $appid_dir[0]
	If StringInStr($appid_dir[$i], ".txt") Then
		If Not StringInStr($appid_dir[$i], "game_") Then
			_ArrayAdd($a_appid, StringTrimRight($appid_dir[$i], 4))
			_ArrayAdd($a_name, FileReadLine($appid_dir[$i], 1))
		EndIf
	EndIf
Next

_ArrayDisplay($a_appid, "appid")
_ArrayDisplay($a_name, "name")

$Form1 = GUICreate("Is this the game you're looking for?", 500, 260+80, 593, 651, -1, $WS_EX_ACCEPTFILES)
GUISetBkColor(0xBFCDDB)
$Label = GUICtrlCreateLabel($game_name, 10, 10, 480, 25, $SS_CENTER)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
$Image = GUICtrlCreatePic(@ScriptDir & "\_steam_appid_\" & $game_appid & ".jpg", 20, 20+20, 460, 215)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
$Input = GUICtrlCreateInput("", 20, 268, 460, 25)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
;$Button1 = GUICtrlCreateButton("TRY AGAIN", -20, 240+40+20+5, 140+20, 40)
;GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
$Button = GUICtrlCreateButton("CONTINUE", 180, 240+40+20+5, 140, 40)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetCursor(-1, 0)
GUICtrlSetState(-1, $GUI_FOCUS)
$ButtonNext = GUICtrlCreateButton(">>>", 430, 240+40+20+5, 50, 40)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetCursor(-1, 0)
$ButtonBack = GUICtrlCreateButton("<<<", 20, 240+40+20+5, 50, 40)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetCursor(-1, 0)
GUISetState(@SW_SHOW)

$appid_temp = 0

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
		Case $GUI_EVENT_DROPPED
			GuiCtrlSetData(@GUI_DropId, @GUI_DragFile)

        Case $Button
			If GUICtrlRead($Input) == "" Then
				$hFileOpen = FileOpen(@ScriptDir & "\_STEAM_APP_.txt", $FO_OVERWRITE)
				FileWriteLine($hFileOpen, $game_appid)
				FileWriteLine($hFileOpen, $game_name)
				FileClose($hFileOpen)
				Run(@ScriptDir & "\generate_emu_config.bat")
				Exit
			Else
				$hFileOpen = FileOpen(@ScriptDir & "\_STEAM_DIR_.txt", $FO_OVERWRITE)
				FileWriteLine($hFileOpen, GUICtrlRead($Input))
				FileClose($hFileOpen)
				Run(@ScriptDir & "\generate_emu_config-appid_finder.bat")
				Exit
			EndIf

		Case $ButtonBack
			If StringInStr($appid_dir[$appid_temp-1], ".txt") Then
				If Not StringInStr($appid_dir[$appid_temp-1], "game_") Then
					#If Not StringInStr($appid_dir[$appid_temp-1], $game_appid) Then #disabled, so we can go back to first found appid
						GUICtrlDelete($Image)
						$Image = GUICtrlCreatePic(@ScriptDir & "\_steam_appid_\" & StringTrimRight($appid_dir[$appid_temp-1], 4) & ".jpg", 20, 20+20, 460, 215)
						GUICtrlSetData($Label, FileReadLine(@ScriptDir & "\_steam_appid_\" & $appid_dir[$appid_temp-1], 1))
						$game_appid = StringTrimRight($appid_dir[$appid_temp-1], 4)
						$game_name = FileReadLine(@ScriptDir & "\_steam_appid_\" & $appid_dir[$appid_temp-1], 1)
						$appid_temp = $appid_temp-1
						;---
					#Else #disabled, so we can go back to first found appid
						#GUICtrlDelete($Image)
						#$Image = GUICtrlCreatePic(@ScriptDir & "\_steam_appid_\" & StringTrimRight($appid_dir[$appid_temp-2], 4) & ".jpg", 20, 20+20, 460, 215)
						#GUICtrlSetData($Label, FileReadLine(@ScriptDir & "\_steam_appid_\" & $appid_dir[$appid_temp-2], 1))
						#$game_appid = StringTrimRight($appid_dir[$appid_temp-2], 4)
						#$game_name = FileReadLine(@ScriptDir & "\_steam_appid_\" & $appid_dir[$appid_temp-2], 1)
						#$appid_temp = $appid_temp-2
					#EndIf
				EndIf
			EndIf
		Case $ButtonNext
			If StringInStr($appid_dir[$appid_temp+1], ".txt") Then
				If Not StringInStr($appid_dir[$appid_temp+1], "game_") Then
					If Not StringInStr($appid_dir[$appid_temp+1], $game_appid) Then
						GUICtrlDelete($Image)
						$Image = GUICtrlCreatePic(@ScriptDir & "\_steam_appid_\" & StringTrimRight($appid_dir[$appid_temp+1], 4) & ".jpg", 20, 20+20, 460, 215)
						GUICtrlSetData($Label, FileReadLine(@ScriptDir & "\_steam_appid_\" & $appid_dir[$appid_temp+1], 1))
						$game_appid = StringTrimRight($appid_dir[$appid_temp+1], 4)
						$game_name = FileReadLine(@ScriptDir & "\_steam_appid_\" & $appid_dir[$appid_temp+1], 1)
						$appid_temp = $appid_temp+1
					Else
						GUICtrlDelete($Image)
						$Image = GUICtrlCreatePic(@ScriptDir & "\_steam_appid_\" & StringTrimRight($appid_dir[$appid_temp+2], 4) & ".jpg", 20, 20+20, 460, 215)
						GUICtrlSetData($Label, FileReadLine(@ScriptDir & "\_steam_appid_\" & $appid_dir[$appid_temp+2], 1))
						$game_appid = StringTrimRight($appid_dir[$appid_temp+2], 4)
						$game_name = FileReadLine(@ScriptDir & "\_steam_appid_\" & $appid_dir[$appid_temp+2], 1)
						$appid_temp = $appid_temp+2
					EndIf
				EndIf
			EndIf
			If $appid_temp == $appid_dir[0]-1 Then
				GUICtrlSetState($ButtonNext, $GUI_DISABLE)
			EndIf
    EndSwitch

	If GUICtrlRead($Input) <> "" Then
		If GUICtrlRead($Button) <> "NO... RETRY" Then
			GUICtrlSetData($Button, "NO... RETRY")
		EndIf
	Else
		If GUICtrlRead($Button) <> "YES... CONTINUE" Then
			GUICtrlSetData($Button, "YES... CONTINUE")
		EndIf
	EndIf
WEnd
