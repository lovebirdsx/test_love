@echo off

@REM 杀死之前启动的love进程
taskkill /IM "love.exe" /F

start love --console transform

@REM -------------------------------------------------------
@REM 取消注释以下脚本, 可以在启动love2d之后, 将焦点返回vs code

@REM ping不存在的地址，模拟1秒的延迟
@REM @ping 222.222.222.222 -w 1000 -n 1

@REM 焦点返回VsCode
@REM echo (new ActiveXObject("WScript.Shell")).AppActivate("test_love -"); > focus.js
@REM cscript //nologo focus.js
@REM del focus.js
