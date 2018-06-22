@echo off

REM Copyright (c) 2018, SLikeSoft UG (haftungsbeschränkt)
REM
REM This file is licensed under the MIT-style license found in the license.txt
REM file in the root directory of this source tree.

REM import command line parameters first
set rootDir=%~1
set swigPath=%~2
set depentendExtension=%3
set option=%4

REM verify mandatory parameters
if "%rootDir%"=="" goto SYNTAXERROR

REM remove trailing backslashes from input paths
if "%rootDir:~-1%" == "\" set rootDir=%rootDir:~0,-1%
if "%swigPath:~-1%" == "\" set swigPath=%swigPath:~0,-1%

REM set required variables
set swigCommand="%swigPath%\swig.exe"
set sourceDir=%rootDir%\Source
set dependentExtensionDir=%rootDir%\DependentExtensions
set swigDefines=
set swigIncludes=-I"%sourceDir%" -I"SwigInterfaceFiles"
set copyToTestDir=0

REM parse/verify the dependent extension parameter
if "%dependentExtension%" == "SQLITE" (
	set swigIncludes=%swigIncludes% -I"%dependentExtensionDir%\SQLite3Plugin"
	set swigDefines=%swigDefines% -DSWIG_ADDITIONAL_SQL_LITE
) else if "%dependentExtension%" == "MYSQL_AUTOPATCHER" (
	set swigIncludes=%swigIncludes% -I"%dependentExtensionDir%\Autopatcher"
	set swigDefines=%swigDefines% -DSWIG_ADDITIONAL_AUTOPATCHER_MYSQL
) else if "%dependentExtension%" == "--copyToTestDir" (
	set copyToTestDir=1
) else if not "%dependentExtension%" == "" (
	echo Unsupported dependent extension: '%dependentExtension%'
	goto SYNTAXERROR
)

REM parse/verify option parameter
if "%option%" == "--copyToTestDir" (
	set copyToTestDir=1
) else if not "%option%" == "" (
	echo Unsupported option: '%option%'
	goto SYNTAXERROR
)

echo Performing SWIG build

REM clear output folder
if exist SwigOutput\SwigCSharpOutput del /F /Q SwigOutput\SwigCSharpOutput\*

REM run SWIG
%swigCommand% -c++ -csharp -namespace RakNet %swigIncludes% %swigDefines% -outdir SwigOutput\SwigCSharpOutput -o SwigOutput\CplusDLLIncludes\RakNet_wrap.cxx SwigInterfaceFiles\RakNet.i
if errorlevel 1 goto SWIGERROR

REM copy over output files (if specified to)
if copyToTestDir == 1 then (
	copy /Y SwigOutput\SwigCSharpOutput\* SwigWindowsCSharpSample\SwigTestApp\SwigFiles
	if errorlevel 1 goto SWIGERROR
)

echo SWIG build complete
goto :eof

:SYNTAXERROR
echo Usage:
echo   MakeSwig.bat ^<slikenet_root_path^> ^<swig_path^>
echo     [^<dependent_extension^>] [--copyToTestDir]
echo.
echo   slikenet_root_path  Path to the SLikeNet root path.
echo   swig_path           Path to the SWIG binary (swig.exe). Use "" to
echo                       indicate using swig.exe from the PATH environment
echo                       variable.
echo   dependent_extension The dependent extension which should be included.
echo                       Supported values: MYSQL_AUTOPATCHER, SQLITE
echo.
echo Options:
echo   --copyToTestDir If specified, copies the generated SWIG output files to
echo                   SwigWindowsCSharpSample\SwigTestApp\SwigFiles.
goto :eof

:SWIGERROR
echo SWIG had an error during build