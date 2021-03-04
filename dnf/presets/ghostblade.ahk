; ==================== 说明开始 ====================

; 这个脚本提供基于 2021.3.3 前后爆出的鬼步 bug 的超级鬼步连招

; ==================== 说明结束 ====================

#NoEnv
#NoTrayIcon

SetWorkingDir ..

#Include lib\common_pre.ahk
#Include lib\autofire.ahk

#InstallKeybdHook

#IfWinActive ahk_exe DNF.exe

global hammer := "f"  ; 鱼锤
global miniBoomGhostSkills := ["z", "r"]  ; 在最后面留一个保底的鬼系技能
global miniBoomBladeSkills := [["a"], ["right", "right", "z"]]  ; 我这里是鬼连斩, 冥灵, 裂魂, 鬼连牙
global ultraBoomGhostSkills := ["w", "e"]  ; 在最后面留一个保底的鬼系技能
global ultraBoomBladeSkills := [["a"], ["s"], ["tab"], ["right", "right", "z"]]  ; 我这里是鬼连斩, 冥灵, 裂魂, 鬼连牙

SetAutofire("x,z,a,f,g,q,w,e,r,t,y")

global delayBetweenGhostAndBlade := 100
; Input 成功时
; 实验数据: 190 延迟对应 55 ~ 145 攻速
; 实验数据: 160 延迟对应 65 ~ 180 攻速
; 实验数据: 130 延迟对应 105 ~ 230 攻速
; 实验数据: 100 延迟对应 170 ~ 265 攻速
; 组队 / 刷图时 delay 应该上提
; 如果发现空放第一个剑术技能, 说明攻速过快, 延迟过高?
; 如果发现空放第二个剑术技能, 说明攻速过慢, 延迟过低?
; Input 失败时 (回落到 Event 模式)
; 实验数据: 200 延迟对应 60 ~ 170 攻速
; 实验数据: 170 延迟对应 85 ~ 210 攻速
; 实验数据: 140 延迟对应 115 ~ 230 攻速
; 实验数据: 110 延迟对应 175 ~ 250+ 攻速

global delayMsg := {190: "55 ~ 145", 160: "65 ~ 180",130: "105 ~ 230",100: "170 ~ 265"}

; 根据攻速调整 delay
^=::
    if (delayBetweenGhostAndBlade > 100) {
        delayBetweenGhostAndBlade -= 30
    }
    ToolTip1s(Format("{1}: {2}", delayBetweenGhostAndBlade, delayMsg[delayBetweenGhostAndBlade]))
    return

^-::
    if (delayBetweenGhostAndBlade < 190) {
        delayBetweenGhostAndBlade += 30
    }
    ToolTip1s(Format("{1}: {2}", delayBetweenGhostAndBlade, delayMsg[delayBetweenGhostAndBlade]))
    return

~h::
    boom(miniBoomGhostSkills, miniBoomBladeSkills)
    return

~u::
    boom(ultraBoomGhostSkills, ultraBoomBladeSkills)
    return

boom(ghostSkills, bladeSkills) {
    ; 释放真·三觉
    Sleep, delay
    RobustSend(GetSpecialKeycode("v"))
    RobustSend(GetSpecialKeycode("f"))
    Sleep, delayBetweenGhostAndBlade - delay * 2

    for _, key in ghostSkills {
        keycode := GetSpecialKeycode(key)
        RobustSend(keycode)
    }

    for _, keys in bladeSkills {
        for _, key in keys {
            keycode := GetSpecialKeycode(key)
            RobustSend(keycode)
        }
        Sleep, 150 - delay * 2
    }
}

#Include lib\common_post.ahk
