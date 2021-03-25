; ==================== 说明开始 ====================

; 像素小游戏
; 此脚本不依赖 main.ahk, 请单独运行
; 像素点必须自己设置 (嫌这个不直观的话可以用按键精灵, 一样的)
; - shift+F12 自动派兵 (循环)
; - shift+F11 自动讨伐当前栏目中最下的 boss (循环)
; - F12 派兵一次
; - F11 自动讨伐当前栏目中最下的 boss

; ==================== 说明结束 ====================


MyClick(x, y) {
    Random, rand, -2.0, 2.0
    MouseMove, x+rand, y+rand
    ; MouseClick
    send {lbutton down}
    Sleep, 10
    send {lbutton up}
    Sleep, 200
}

SendOnMission() {
    ; MyClick(1200, 970)  ; 天界入口
    MyClick(1400, 970)  ; 天界深处
    MyClick(1800, 840)  ; 关闭派兵窗
}

SendAllCharacters() {
    ; 翻页到顶部
    MyClick(1730, 845)
    ; 第一个角色
    MyClick(1600, 870)
    ; 天界
    SendOnMission()
    ; 第二个角色
    MyClick(1600, 1030)
    ; 天界
    SendOnMission()

    Loop, 14 {
        ; 第三个角色
        MyClick(1600, 1170)
        ; 天界
        SendOnMission()
        ; 翻页
        MyClick(1730, 1220)
    }
}

Boss() {
    ; 讨伐最后一个boss
    MyClick(1600, 1170)
    ; 第1个角色
    MyClick(1060, 960)
    ; 第2个角色
    MyClick(1220, 960)
    ; 第3个角色
    MyClick(1360, 960)
    ; 第4个角色
    MyClick(1470, 960)
    ; 确定
    MyClick(1180, 1130)
    ; 取消
    MyClick(1400, 1130)
}

ToolTipForever(msg) {
    ; Somehow it has to hacked this way
    ToolTip, % msg, (A_ScreenWidth // 2), (A_ScreenHeight // 2)
}

F12::
    SendAllCharacters()
    Return

+F12::
    fn := Func("SendAllCharacters").bind()
    SetTimer, % fn, 300000  ; 300s
    ToolTipForever("Periodically sending all characters on mission")
    Return

F11::
    Boss()
    Return

+F11::
    fn := Func("Boss").bind()
    SetTimer, % fn, 6000  ; 7s
    ToolTipForever("Periodically getting fucked by the last boss")
    Return

^F12::
    Reload
    Return
