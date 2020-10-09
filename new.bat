@echo off
setlocal
set selfname=%~n0
set ret_success=0
set ret_fail=1

if "%1"=="" (
    call :usage
    exit /b %red_success%
)

if "%1"=="help" (
    call :usage
    exit /b %ret_success%
)

rem if not "%2"=="" (
rem     call :abort Please specify only one parameter.
rem     exit /b %ret_fail%
rem )

rem if not "%1"=="blogs" (
rem     if not "%1"=="news" (
rem         if not "%1"=="posts"(
rem             call :usage
rem             exit /b %ret_fail%
rem         )
rem     )
rem )

powershell -ExecutionPolicy RemoteSigned -File new.ps1 -Arg %1

pause
exit /b

:usage
echo [Usage]
echo %selfname%         : Show the usage.
echo %selfname% help    : Show the usage.
echo %selfname% blogs   : Create a blog post.
echo %selfname% news    : Create a post of news for XMLPro.
echo %selfname% posts   : Create another post.
exit /b

:abort
echo (%selfname%) Error! %*
exit /b
