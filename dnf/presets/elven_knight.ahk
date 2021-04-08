; ==================== 说明开始 ====================

; 这个脚本提供两个功能
; 1. 按下 z 的时候, 释放预先定义的小技能中的两个, 以达到快速叠C的功能 (会考虑冷却)
; 2. 使用输出技能的时候自动释放剑盾

; ==================== 说明结束 ====================

#NoEnv
#NoTrayIcon

SetWorkingDir ..

#Include lib\common_pre.ahk

#IfWinActive ahk_exe DNF.exe

; ==================== Customization Begin ====================

global smallSkills := [["盾挑", ["z"], 2], ["盾击", ["Up", "z"], 3], ["盾牌格挡", ["Down", "z"], 1.8], ["鹿", ["Up", "Up", "z"], 5.6], ["突刺", ["Down", "Down", "z"], 2.8], ["命运之轮", ["Up", "Down", "z"], 7.5], ["审判之盾", ["Down", "Up", "z"], 6.6]]
; 用来叠 C 的小技能

global showSkills := True
; 是否在释放小技能叠 C 后显示放出的技能, 通常用于 debug

global smallSkillsDelay := [190, 190]
; 小技能叠C后的延迟 (另外数组的长度即小技能的释放个数)

global keyJianDun := "Space"
; 剑盾猛攻按键

global skillDelay := {"a": 220, "s": 220, "d": 275, "f": 220, "g": 740, "w": 740, "e": 740, "r": 730, "t": 740, "v": 275, "tab": 740}
; 例如我 a 键是破武之轮, 希望在该技能释放后 225ms 按剑盾, 就设置 "a": 225
; 其他技能可以参考 https://bbs.colg.cn/thread-8027274-1-1.html, https://bbs.colg.cn/thread-7479247-1-1.html

; ==================== Customization End ====================

global keycodeJianDun := GetSpecialKeycode(keyJianDun)
global free := True

global smallSkillsLastFired := {}
for _, v in smallSkills {
    smallSkillsLastFired[v[1]] := 0
    v[3] := v[3] * 1000 + 100  ; 补正冷却时间 (s -> ms, 然后加上一点冗余量)
}


Hotkey, IfWinActive, ahk_exe DNF.exe
for k, v in skillDelay {
    fn := Func("JianDunAfter").Bind(v)
    Hotkey, $~*%k%, %fn%
}
Hotkey, If

JianDunAfter(delay) {
    if (free) {
        free := False
        Sleep, delay
        RobustSend(keycodeJianDun)
    }
    free := True
}

; 自动叠C
z::
    if (free) {
        free := False
        fireSmallSkills()
    }
    free := True
    return

fireSmallSkills() {
    ; 放两个小技能用于叠C
    fired := 0
    usedSkills := ""
    for _, skill in smallSkills {
        if (A_TickCount - smallSkillsLastFired[skill[1]] > skill[3]) {            
            ; 该技能冷却已经转好了
            for _, key in skill[2] {
                RobustSend(GetSpecialKeycode(key))
            }
            smallSkillsLastFired[skill[1]] := A_TickCount
            Sleep, smallSkillsDelay[fired+1] - delay - duration
            ; 详细说明:
            ; AHK 中如果只是 Send {key} 经常会出现发不出去的情况
            ; 一个 workaround 是 Send {key down}; Sleep duration; Send {key up}; Sleep delay;
            ; 这部分具体实现见 common_pre.ahk
            ; 这导致技能实际是在 (now-delay-duration, now-delay) 这个区间就放出来了
            ; 相应的, 这里 Sleep 的时间也应该把这部分时间考虑进去, 满足从技能释放之后算起有 225ms 的间隔
            RobustSend(keycodeJianDun)
            fired += 1
            usedSkills .= skill[1] . " "
        }
        if (fired == smallSkillsDelay.MaxIndex()) {
            ; 放完了, 结束
            break
        }
    }
    if (showSkills) {
        ToolTip1s(usedSkills)
    }
}

#IfWinActive

#Include lib\common_post.ahk
