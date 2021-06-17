#SingleInstance, Force
#WinActivateForce
SendMode Input
SetWorkingDir, %A_ScriptDir%

global moveWindowLastPos := ""
global moveWindowLastPosIndex := 0
moveWindow(pos) {
    ; ToolTip1s("123123")
    d := { "fullscreen"   : [0      , 0    , 1    , 1   ]
         , "left"         : [0      , 0    , 0.55 , 1   ]
         , "right"        : [0.55   , 0    , 0.45 , 1   ]
         , "center"       : [0.25   , 0.15 , 0.5  , 0.7 ]
         , "center-large" : [0.15   , 0.1  , 0.7  , 0.8 ]
         , "left-top"     : [0      , 0    , 0.55 , 0.55]
         , "left-bottom"  : [0      , 0.45 , 0.55 , 0.55]
         , "right-top"    : [0.55   , 0    , 0.45 , 0.55]
         , "right-bottom" : [0.55   , 0.45 , 0.45 , 0.55]
         , "corner"       : [0.95   , 0.95 , 0.05 , 0.05] }

    r := { "center": ["center", "center-large"]
         , "left":   ["left", "left-top", "left-bottom" ]
         , "right":  ["right", "right-top", "right-bottom"]
         , "fullscreen": ["fullscreen"] }

    If (pos == moveWindowLastPos) {
        moveWindowLastPosIndex := Mod(moveWindowLastPosIndex + 1, r[pos].Length())
    }
    Else {
        moveWindowLastPos := pos
        moveWindowLastPosIndex := 0
    }
    x := d[r[pos][moveWindowLastPosIndex + 1]][1] * A_ScreenWidth
    y := d[r[pos][moveWindowLastPosIndex + 1]][2] * A_ScreenHeight
    w := d[r[pos][moveWindowLastPosIndex + 1]][3] * A_ScreenWidth
    h := d[r[pos][moveWindowLastPosIndex + 1]][4] * A_ScreenHeight
    winId := WinExist("A")
    If (winId) {
        WinMove, ahk_id %winId%, , x, y, w, h
    }
}

launchOrFocus(appPath, winExe) {
    If (WinExist("ahk_exe" winExe)) {
        If (WinActive("ahk_exe" winExe)) {
            PostMessage, 0x0112, 0xF020,,, ahk_exe %winExe%,  ; 0x0112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE
        }
        Else {
            WinActivate, ahk_exe %winExe%
        }
    }
    Else {
        Run % appPath
    }
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


CapsLock & k::launchOrFocus("Firefox.exe", "Firefox.exe")
CapsLock & i::launchOrFocus("WindowsTerminal.exe", "WindowsTerminal.exe")
CapsLock & b::launchOrFocus("Code.exe", "Code.exe")


CapsLock & u::moveWindow("center")
CapsLock & h::moveWindow("left")
CapsLock & l::moveWindow("right")
CapsLock & Enter::moveWindow("fullscreen")

CapsLock:: Send, {Alt Down}{Shift Down}{Shift Up}{Alt Up}
