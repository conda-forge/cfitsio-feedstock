
mkdir build
cd build

cmake -G "NMake Makefiles" ^
  -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -D CMAKE_BUILD_TYPE=Release ^
  ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

:: test-ish programs (speed doesn't seem to get built)
cookbook
if errorlevel 1 exit 1
testprog
if errorlevel 1 exit 1
  
nmake install
if errorlevel 1 exit 1

:: DLL seems to go in wrong place
move %LIBRARY_LIB%\cfitsio.dll %LIBRARY_BIN%
if errorlevel 1 exit 1

:: delete in case this breaks other things - only needed for compilation anyway
del %LIBRARY_INC%\unistd.h
if errorlevel 1 exit 1
