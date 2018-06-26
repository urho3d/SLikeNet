REM This file was taken from RakNet 4.082.
REM Please see licenses/RakNet license.txt for the underlying license and related copyright.
REM
REM Modified work: Copyright (c) 2018, SLikeSoft UG (haftungsbeschränkt)
REM
REM This source code was modified by SLikeSoft. Modifications are licensed under the MIT-style
REM license found in the license.txt file in the root directory of this source tree.

if not exist "..\SwigWindowsCSharpSample\SwigTestApp\bin" mkdir "..\SwigWindowsCSharpSample\SwigTestApp\bin"
if not exist "..\SwigWindowsCSharpSample\SwigTestApp\bin\X86" mkdir "..\SwigWindowsCSharpSample\SwigTestApp\bin\X86"
if not exist "..\SwigWindowsCSharpSample\SwigTestApp\bin\X86\%1" mkdir "..\SwigWindowsCSharpSample\SwigTestApp\bin\X86\%1"
copy /Y "%1\RakNet.dll" "../SwigWindowsCSharpSample\SwigTestApp\bin\X86\%1\RakNet.dll"
