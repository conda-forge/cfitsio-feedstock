
mkdir build
cd build

cmake -G "NMake Makefiles" ^
  %CMAKE_ARGS% ^
  -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -D TESTS=On ^
  -D UTILS=On ^
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

:: delete in case this breaks other things - only needed for compilation anyway
del %LIBRARY_INC%\unistd.h
if errorlevel 1 exit 1
