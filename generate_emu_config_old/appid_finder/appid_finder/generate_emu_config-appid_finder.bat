@echo off
python -W ignore::DeprecationWarning ..\..\generate_emu_config.py -find -rel_raw
.\au3\au3.exe /AutoIt3ExecuteScript .\appid_finder.a3x