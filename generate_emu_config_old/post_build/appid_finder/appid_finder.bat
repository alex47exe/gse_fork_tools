@echo off
set /p arg="Find appid for this game folder name: "
echo:
echo:
xcopy /s /y/e "appid_finder" "%arg%\"
echo:
echo:
cd %arg%
call generate_emu_config-appid_finder.bat