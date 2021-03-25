; ==================== 说明开始 ====================

; 这是一个开发模板, 通用的函数建议写入 `lib\common_pre.ahk` 和 `lib\common_post.ahk` 中

; ==================== 说明结束 ====================

#NoEnv
#NoTrayIcon

SetWorkingDir ..

#Include lib\common_pre.ahk
#Include lib\autofire.ahk

#IfWinActive ahk_exe DNF.exe

^LButton::
	while (getKeyState("LButton", "P"))
	{
		RobustSend("LButton")
	}
    return

#Include lib\common_post.ahk
