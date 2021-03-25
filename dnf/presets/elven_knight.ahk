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

global smallSkills := [["盾挑", [""], 2], ["盾击", ["Up", "z"], 3], ["盾牌格挡", ["Down", "z"], 1.8], ["致命突刺", ["Up", "Up", "z"], 3]]
; 用来叠 C 的小技能, 之所以我盾挑留空是因为我下面触发键 (x & z) 中包含了 z, 所以不需要再在这里写 z 了

global showSkills := True
; 是否在释放小技能叠 C 后显示放出的技能, 通常用于 debug

global smallSkillsCount := 2
; 释放小技能的次数

global keyJianDun := "Space"
; 剑盾猛攻按键

global skillDelay := {"a": 225, "s": 225, "d": 225, "f": 240, "g": 740, "w": 750, "e": 740, "r": 276, "b": 740, "y": 2750}
; 例如我 a 键是破武之轮, 希望在该技能释放后 225ms 按剑盾, 就设置 "a": 225
; 其他技能可以参考 https://bbs.colg.cn/thread-8027274-1-1.html
; 个人对应表
; a - 破武之轮
; s - 神木刺击
; d - 破甲冲击
; f - 自然束缚
; g - 飓风旋枪, 带护石减500
; w - 壁垒突袭
; e - 天陨断空斩
; r - 一刀两断
; b - 自然之怒
; y - 二觉

; ==================== Customization End ====================

global keycodeJianDun := GetSpecialKeycode(keyJianDun)

global smallSkillsLastFired := {}
for _, v in smallSkills {
    smallSkillsLastFired[v[1]] := 0
    v[3] := v[3] * 1000 + 100  ; 补正冷却时间 (s -> ms, 然后加上一点冗余量)
}

global fireLastJianDun := True

for k, v in skillDelay {
    fn := Func("JianDunAfter").Bind(v)
    Hotkey, $~*%k%, %fn%
}

JianDunAfter(delay) {
    Sleep, delay
    if (fireLastJianDun) {
        RobustSend(keycodeJianDun)
    }
    fireLastJianDun := True
}

; 自动叠C快捷键 (此处为同时按x和z时触发)
~x & ~z::
    fireSmallSkills()
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
            Sleep, 225 - delay - duration / 2
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
        if (fired == smallSkillsCount) {
            ; 放完了, 结束
            break
        }
    }
    if (showSkills) {
        ToolTip1s(usedSkills)
    }
}

#Include lib\common_post.ahk
