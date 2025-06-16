@echo off
..\..\generate_emu_config.exe -find -rel_raw
.\au3\au3.exe /AutoIt3ExecuteScript .\appid_finder.a3x