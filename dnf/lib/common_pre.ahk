; ==================== 说明开始 ====================

; 公用的函数 / 设置, 通常被 Include 在脚本的顶端

; ==================== 说明结束 ====================

#Include config.ahk
ListLines, Off
SetBatchLines, -1
SetKeyDelay, -1, -1
Process, Priority, , A

GetSpecialKeycode(key) {
	; 返回对应于 key 的只被游戏识别但不影响打字的 keycode
	base := "vkFFsc"
	sc := GetKeySC(key)
	keycode := Format("{1}{2:X}", base, sc)
	return keycode
}

RobustSend(key) {
	; 或许用 SetKeyDelay 也可以达成同样的效果
	Send, {Blind}{%key% down}
	Sleep, duration
	Send, {Blind}{%key% up}
	Sleep, delay
}

ToolTip1s(msg) {
    ; Somehow it has to hacked this way
    ToolTip, % msg, (A_ScreenWidth // 2), (A_ScreenHeight // 2)
	fn := Func("MyToolTip").bind()
    SetTimer, % fn, -1000
}

MyToolTip() {
	ToolTip
}
