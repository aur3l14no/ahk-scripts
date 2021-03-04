; ==================== 说明开始 ====================

; 这个脚本提供两个功能
; 1. 同时按下 x 和 z 的时候, 释放预先定义的小技能中的两个, 以达到快速叠C的功能 (会考虑冷却)
; 2. 使用输出技能的时候自动释放剑盾

; ==================== 说明结束 ====================

#NoEnv
#NoTrayIcon

SetWorkingDir ..

#Include lib\common_pre.ahk

#IfWinActive ahk_exe DNF.exe

; ==================== Customization Begin ====================

global smallSkills := [["盾挑", ["", ""], 2], ["盾击", ["Up", "z"], 3], ["盾牌格挡", ["Down", "z"], 1.8], ["致命突刺", ["Up", "Up", "z"], 3]]
global keyJianDun := "space"
global keycodeJianDun := GetSpecialKeycode(keyJianDun)

global smallSkillsLastFired := {}
for _, v in smallSkills {
    smallSkillsLastFired[v[1]] := 0
    v[3] := v[3] * 1000 + 100  ; 补正冷却时间 (s -> ms, 然后加上一点冗余量)
}

; 自动叠C快捷键 (此处为同时按x和z时触发)
~x & ~z::
    fireSmallSkills()
    return

; 破武之轮, 此技能可蓄力, 所以从松开按键算起, 若要加在连锁中, 务必快速释放!
~a::
    Sleep, 225
    RobustSend(keycodeJianDun)
    return

; 神木刺击
~s::
    Sleep, 225
    RobustSend(keycodeJianDun)
    return

; 破甲冲击
~d::
    Sleep, 225
    RobustSend(keycodeJianDun)
    return

; 自然束缚
~f::
    Sleep, 240
    RobustSend(keycodeJianDun)
    return

; 飓风旋枪, 带护石减500
~g::
    Sleep, 740
    RobustSend(keycodeJianDun)
    return

; 壁垒突袭
~w::
    Sleep, 750
    RobustSend(keycodeJianDun)
    return

; 天陨断空斩
~e::
    Sleep, 740
    RobustSend(keycodeJianDun)
    return

; 一刀两断
~r::
    Sleep, 276
    RobustSend(keycodeJianDun)
    return

; 自然之怒
~b::
    Sleep, 740
    RobustSend(keycodeJianDun)
    return

; 二觉
~y::
    Sleep, 2750
    RobustSend(keycodeJianDun)
    return

; ==================== Customization End ====================

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
            Sleep, 225 - delay * 2
            RobustSend(keycodeJianDun)
            fired += 1
            usedSkills .= skill[1] . " "
        }
        if (fired == 2) {
            ; 已经放了2个了
            Break
        }    
    }
    ToolTip1s(usedSkills)
}

#Include lib\common_post.ahk
