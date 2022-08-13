@REM 杀死之前启动的love进程
taskkill /IM "love.exe" /F

start love transform

@REM ping不存在的地址，模拟1秒的延迟
ping 222.222.222.222 -w 1000 -n 1

@REM 焦点返回VsCode
echo (new ActiveXObject("WScript.Shell")).AppActivate("test_love -"); > focus.js
cscript //nologo focus.js
del focus.js
