; ==================== 说明开始 ====================

; 在 elven_knight.ahk 的基础上, 在自动释放小技能和自动剑盾的过程中按 C 可取消最末的剑盾, 从而实现边打边跑的效果
; 但由于我的脚本提供了自动释放小技能, 所以断C并不要紧, 一键放两个小技能就瞬间回来了
; 因此, 此功能或许更多是为了应对老精灵玩家不希望断C的强迫症
; 但本脚本本就是为萌新服务, 基于此考虑, 本分支不再继续迭代
; 最新功能仍在 eleven_knight.ahk 中

; ==================== 说明结束 ====================

#NoEnv
#NoTrayIcon

SetWorkingDir ..

#Include lib\common_pre.ahk

#IfWinActive ahk_exe DNF.exe

; ==================== Customization Begin ====================

global smallSkills := [["盾挑", [""], 2], ["盾击", ["Up", "z"], 3], ["盾牌格挡", ["Down", "z"], 1.8], ["致命突刺", ["Up", "Up", "z"], 3]]
; 用来叠 C 的小技能, 之所以我盾挑留空是因为我下面触发键 (x & z) 中包含了 z, 所以不需要再在这里写 z 了

global showSkills := False
; 是否在释放小技能叠 C 后显示放出的技能

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

global mutex := False

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
    mutex := True
    Sleep, delay
    if (fireLastJianDun) {
        RobustSend(keycodeJianDun)
    }
    fireLastJianDun := True
    mutex := False
}

; 自动叠C快捷键 (此处为同时按x和z时触发)
LAlt::
    mutex := True
    fireSmallSkills()
    mutex := False
    return

~c::
    if (mutex) {
        fireLastJianDun := False
    }
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

            if (fired == smallSkillsCount - 1 and not fireLastJianDun) {
                ; 小技能放完了, 收尾的剑盾不放了
                fireLastJianDun := True
                break
            }
            else {
                Sleep, 225 - delay * 1.5  ; 减去 2 个 delay 是因为 RobustSend 本身已经有延迟了
                RobustSend(keycodeJianDun)
                fired += 1
                usedSkills .= skill[1] . " "
            }
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
