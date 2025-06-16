#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>

; ARC_NAME

$arc_generate_interfaces = IniRead(@ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini", "ARC_NAME", "generate_interfaces", "generate_interfaces.7z")

; EXE_PATH

$generate_interfaces_release = IniRead(@ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini", "EXE_PATH", "generate_interfaces_release", "generate_interfaces.exe")
$generate_interfaces64_release = IniRead(@ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini", "EXE_PATH", "generate_interfaces64_release", "generate_interfaces64.exe")

$generate_interfaces_7z = @ScriptDir & '\steam_misc\tools\generate_interfaces\' & $arc_generate_interfaces
$generate_interfaces_dst = @ScriptDir & '\steam_misc\tools\generate_interfaces'
$generate_interfaces_exe = ''
Switch @OSArch
	Case 'X64'
		$generate_interfaces_exe = StringTrimLeft($generate_interfaces64_release, StringInStr($generate_interfaces64_release, "\", 0, -1)) ; generate_interfaces64.exe
		If Not FileExists(@ScriptDir & '\steam_misc\tools\generate_interfaces\' & StringTrimLeft($generate_interfaces64_release, StringInStr($generate_interfaces64_release, "\", 0, -1))) Then
			ShellExecuteWait(@ScriptDir & "\steam_misc\tools\7za\7za.exe", 'x "' & $generate_interfaces_7z & '" -o"' & $generate_interfaces_dst & '" -aoa', "", "", @SW_HIDE)
		EndIf
	Case 'X86'
		$generate_interfaces_exe = StringTrimLeft($generate_interfaces_release, StringInStr($generate_interfaces_release, "\", 0, -1)) ; generate_interfaces.exe
		If Not FileExists(@ScriptDir & '\steam_misc\tools\generate_interfaces\' & StringTrimLeft($generate_interfaces_release, StringInStr($generate_interfaces_release, "\", 0, -1))) Then
			ShellExecuteWait(@ScriptDir & "\steam_misc\tools\7za\7za.exe", 'x "' & $generate_interfaces_7z & '" -o"' & $generate_interfaces_dst & '" -aoa', "", "", @SW_HIDE)
		EndIf
	Case Else
		$generate_interfaces_exe = StringTrimLeft($generate_interfaces64_release, StringInStr($generate_interfaces64_release, "\", 0, -1)) ; generate_interfaces64.exe
		If Not FileExists(@ScriptDir & '\steam_misc\tools\generate_interfaces\' & StringTrimLeft($generate_interfaces64_release, StringInStr($generate_interfaces64_release, "\", 0, -1))) Then
			ShellExecuteWait(@ScriptDir & "\steam_misc\tools\7za\7za.exe", 'x "' & $generate_interfaces_7z & '" -o"' & $generate_interfaces_dst & '" -aoa', "", "", @SW_HIDE)
		EndIf
EndSwitch

If Not FileExists(@ScriptDir & '\steam_api.dll') Then FileDelete(@ScriptDir & '\steam_misc\tools\generate_interfaces\' & StringTrimLeft($generate_interfaces_release, StringInStr($generate_interfaces_release, "\", 0, -1)))
If Not FileExists(@ScriptDir & '\steam_api64.dll') Then FileDelete(@ScriptDir & '\steam_misc\tools\generate_interfaces\' & StringTrimLeft($generate_interfaces64_release, StringInStr($generate_interfaces64_release, "\", 0, -1)))

Switch @OSArch
	Case 'X64'
		If Not FileExists(@ScriptDir & '\steam_misc\tools\generate_interfaces\' & StringTrimLeft($generate_interfaces64_release, StringInStr($generate_interfaces64_release, "\", 0, -1))) Then
			$generate_interfaces_exe = StringTrimLeft($generate_interfaces_release, StringInStr($generate_interfaces_release, "\", 0, -1))
		EndIf
	Case 'X86'
		If Not FileExists(@ScriptDir & '\steam_misc\tools\generate_interfaces\' & StringTrimLeft($generate_interfaces_release, StringInStr($generate_interfaces_release, "\", 0, -1))) Then
			$generate_interfaces_exe = StringTrimLeft($generate_interfaces64_release, StringInStr($generate_interfaces64_release, "\", 0, -1))
		EndIf
	Case Else
		If Not FileExists(@ScriptDir & '\steam_misc\tools\generate_interfaces\' & StringTrimLeft($generate_interfaces64_release, StringInStr($generate_interfaces64_release, "\", 0, -1))) Then
			$generate_interfaces_exe = StringTrimLeft($generate_interfaces_release, StringInStr($generate_interfaces_release, "\", 0, -1))
		EndIf
EndSwitch

If FileExists(@ScriptDir & '\valve_api.dll') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\valve_api.dll.bak' & '"', @ScriptDir, @SW_HIDE)
EndIf

If FileExists(@ScriptDir & '\steam_api.dll.bak') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api.dll.bak' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api.dll.org') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api.dll.org' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api.bak') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api.bak' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api.org') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api.org' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api_orig.dll') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api_orig.dll' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api_legit.dll') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api_legit.dll' & '"', @ScriptDir, @SW_HIDE)
#ElseIf FileExists(@ScriptDir & '\steam_api.dll') Then
	#RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api.dll' & '"', @ScriptDir, @SW_HIDE)
EndIf

If FileExists(@ScriptDir & '\valve_api64.dll') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\valve_api64.dll.bak' & '"', @ScriptDir, @SW_HIDE)
EndIf

If FileExists(@ScriptDir & '\steam_api64.dll.bak') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api64.dll.bak' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api64.dll.org') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api64.dll.org' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api64.bak') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api64.bak' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api64.org') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api64.org' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api64_orig.dll') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe &' ' & '"' & @ScriptDir & '\steam_api64_orig.dll' & '"', @ScriptDir, @SW_HIDE)
ElseIf FileExists(@ScriptDir & '\steam_api64_legit.dll') Then
	RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe &' ' & '"' & @ScriptDir & '\steam_api64_legit.dll' & '"', @ScriptDir, @SW_HIDE)
#ElseIf FileExists(@ScriptDir & '\steam_api64.dll') Then
	#RunWait($generate_interfaces_dst & '\' & $generate_interfaces_exe & ' ' & '"' & @ScriptDir & '\steam_api64.dll' & '"', @ScriptDir, @SW_HIDE)
EndIf

FileMove(@ScriptDir & '\steam_interfaces.txt', @ScriptDir & '\steam_settings\steam_interfaces.txt', 9)
FileCopy(@ScriptDir & '\steam_settings\steam_interfaces.txt', @ScriptDir & '\steam_settings\steam_interfaces.ini', 9)

$hFile=FileOpen(@ScriptDir & '\steam_settings\steam_interfaces.ini',0)
$sOld=FileRead($hFile)
FileClose($hFile)
$hFile=FileOpen(@ScriptDir & '\steam_settings\steam_interfaces.ini',2)
$sNew='[steam_interfaces]' & @CRLF & $sOld
FileWrite($hFile,$sNew)
FileClose($hFile)

$interfaces_ini = @ScriptDir & '\steam_settings\steam_interfaces.ini'

$codex_ini = @ScriptDir & '\steam_misc\extra_crk\CODEX\steam_emu.ini'
$interfaces_ini_tmp = @ScriptDir & '\steam_settings\steam_interfaces.ini.cdx'
FileCopy($interfaces_ini, $interfaces_ini_tmp, 1)
_AddInterfaces($codex_ini)
FileDelete($interfaces_ini_tmp)

$rune_ini = @ScriptDir & '\steam_misc\extra_crk\RUNE\steam_emu.ini'
$interfaces_ini_tmp = @ScriptDir & '\steam_settings\steam_interfaces.ini.rne'
FileCopy($interfaces_ini, $interfaces_ini_tmp, 1)
_AddInterfaces($rune_ini)
FileDelete($interfaces_ini_tmp)

FileDelete($interfaces_ini)

Func _AddInterfaces($crack_ini)

	If FileExists($crack_ini) Then

		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamAppDisableUpdate', 'SteamAppDisableUpdate=SteamAppDisableUpdate', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMAPPLIST_', 'SteamAppList=STEAMAPPLIST_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMAPPS_', 'SteamApps=STEAMAPPS_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMAPPTICKET_', 'SteamAppTicket=STEAMAPPTICKET_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamClient', 'SteamClient=SteamClient', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamController', 'SteamController=SteamController', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamFriends', 'SteamFriends=SteamFriends', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamGameCoordinator', 'SteamGameCoordinator=SteamGameCoordinator', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamGameServerStats', 'Steam_Game_Server_Stats=Steam_Game_Server_Stats', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamGameServer', 'SteamGameServer=SteamGameServer', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'Steam_Game_Server_Stats', 'SteamGameServerStats', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamGameStats', 'SteamGameStats=SteamGameStats', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMHTMLSURFACE_', 'SteamHTMLSurface=STEAMHTMLSURFACE_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMHTTP_', 'SteamHTTP=STEAMHTTP_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamInput', 'SteamInput=SteamInput', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMINVENTORY_', 'SteamInventory=STEAMINVENTORY_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamMasterServerUpdater', 'SteamMasterServerUpdater=SteamMasterServerUpdater', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamMatchGameSearch', 'SteamMatchGameSearch=SteamMatchGameSearch', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamMatchMakingServers', 'Steam_Match_Making_Servers=Steam_Match_Making_Servers', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamMatchMaking', 'SteamMatchMaking=SteamMatchMaking', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'Steam_Match_Making_Servers', 'SteamMatchMakingServers', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMMUSIC_', 'SteamMusic=STEAMMUSIC_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMMUSICREMOTE_', 'SteamMusicRemote=STEAMMUSICREMOTE_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamNetworkingMessages', 'Steam_Networking_Messages=Steam_Networking_Messages', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamNetworkingSocketsSerialized', 'Steam_Networking_Sockets_Serialized=Steam_Networking_Sockets_Serialized', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamNetworkingSockets', 'Steam_Networking_Sockets=Steam_Networking_Sockets', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamNetworkingUtils', 'Steam_Networking_Utils=Steam_Networking_Utils', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamNetworking', 'SteamNetworking=SteamNetworking', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'Steam_Networking_Messages', 'SteamNetworkingMessages', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'Steam_Networking_Sockets_Serialized', 'SteamNetworkingSocketsSerialized', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'Steam_Networking_Sockets', 'SteamNetworkingSockets', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'Steam_Networking_Utils', 'SteamNetworkingUtils', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMPARENTALSETTINGS_', 'SteamParentalSettings=STEAMPARENTALSETTINGS_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamParties', 'SteamParties=SteamParties', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMREMOTEPLAY_', 'SteamRemotePlay=STEAMREMOTEPLAY_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMREMOTESTORAGE_', 'SteamRemoteStorage=STEAMREMOTESTORAGE_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMSCREENSHOTS_', 'SteamScreenshots=STEAMSCREENSHOTS_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMTIMELINE_', 'SteamTimeline=STEAMTIMELINE_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMTV_', 'SteamTV=STEAMTV_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMUGC_', 'SteamUGC=STEAMUGC_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMUNIFIEDMESSAGES_', 'SteamUnifiedMessages=STEAMUNIFIEDMESSAGES_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMUSERSTATS_', 'Steam_User_Stats=STEAMUSERSTATS_', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamUser', 'SteamUser=SteamUser', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'Steam_User_Stats', 'SteamUserStats', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'SteamUtils', 'SteamUtils=SteamUtils', 1, 1)
		_ReplaceStringInFile($interfaces_ini_tmp, 'STEAMVIDEO_', 'SteamVideo=STEAMVIDEO_', 1, 1)

		IniWrite($crack_ini, 'Interfaces', 'SteamAppDisableUpdate', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamAppDisableUpdate', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamAppList', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamAppList', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamApps', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamApps', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamAppTicket', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamAppTicket', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamClient', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamClient', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamController', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamController', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamFriends', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamFriends', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamGameCoordinator', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamGameCoordinator', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamGameServerStats', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamGameServerStats', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamGameServer', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamGameServer', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamGameStats', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamGameStats', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamHTMLSurface', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamHTMLSurface', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamHTTP', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamHTTP', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamInput', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamInput', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamInventory', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamInventory', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamMasterServerUpdater', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamMasterServerUpdater', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamMatchGameSearch', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamMatchGameSearch', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamMatchMakingServers', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamMatchMakingServers', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamMatchMaking', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamMatchMaking', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamMusic', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamMusic', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamMusicRemote', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamMusicRemote', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamNetworkingMessages', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamNetworkingMessages', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamNetworkingSocketsSerialized', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamNetworkingSocketsSerialized', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamNetworkingSockets', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamNetworkingSockets', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamNetworkingUtils', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamNetworkingUtils', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamNetworking', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamNetworking', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamParentalSettings', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamParentalSettings', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamParties', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamParties', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamRemotePlay', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamRemotePlay', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamRemoteStorage', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamRemoteStorage', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamScreenshots', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamScreenshots', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamTimeline', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamTimeline', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamTV', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamTV', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamUGC', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamUGC', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamUnifiedMessages', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamUnifiedMessages', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamUserStats', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamUserStats', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamUser', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamUser', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamUtils', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamUtils', ''))
		IniWrite($crack_ini, 'Interfaces', 'SteamVideo', IniRead($interfaces_ini_tmp, 'steam_interfaces', 'SteamVideo', ''))

	EndIf

EndFunc
