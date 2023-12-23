@set sv=24
@mkdir c:\temp
@cls
@echo PLEASE TYPE ONE OF THE FOLLOWING (NO SPACES) AND HIT ENTER:
@echo .    
@set /p response="swmA swmB swmC swmD swmE swmF (or other) "
@set response=%response%%sv%.hoc
cd nrnpgms
copy diff.dat  c:\temp
start swmanimation.exe
start nrnalone.exe %response%






