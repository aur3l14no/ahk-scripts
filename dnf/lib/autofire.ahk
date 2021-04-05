; ==================== 说明开始 ====================

; 这个脚本接收一个形如 "a,b,c,d" 的参数, 并开启这些用逗号隔开的按键的连发 (有冲)
; 配合 `main.ahk` 和 `config.ahk` 达到无冲的效果

; ==================== 说明结束 ====================

#NoEnv
#NoTrayIcon

SetWorkingDir ..

#Include lib\common_pre.ahk

arg_1 = %1%
global keys := arg_1

if (keys != "") {
	SetAutofire(keys)
}

SetAutofire(keys) {
	Hotkey, IfWinActive, ahk_exe DNF.exe
	for _, key in StrSplit(keys, ",") {
		keycode := GetSpecialKeycode(key)  ; 提前算好 keycode, 以提高连发的速度
		fn := Func("OnSelfAutofireKeyPressed").Bind(key, keycode)
		Hotkey, $~*%key%, %fn%
	}
	Hotkey, If
}

OnSelfAutofireKeyPressed(key, keycode) {
	while (getKeyState(key, "P"))
	{
		RobustSend(keycode)
	}
}

#Include lib\common_pre.ahk