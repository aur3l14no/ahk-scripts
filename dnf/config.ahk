; 说明
; presets: 方案 (用逗号隔开的是不能无冲的, 用分号隔开的是无冲的)
;          举例说明 "x,a,q" 是有冲突的, 同时按 xaq 不能同时连发; "x,q;a;s" xq 有冲突但 xas 或 qas 都是无冲连发
; defaultPreset: 默认开启的方案
; 逗号在下一行是 AHK 的蹩脚 parser 不支持常规多行声明的写法所致

global presets := { "F5": ["基本", "x,a,q"]
                  , "F6": ["力法/剑影/剑魂", "x,z,d,f,g,q,w,e,r,t,y;a"]
                  , "F7": ["DK", "x,a,s,d,f,g,e,r,t"]
                  , "F8": ["精灵骑士", "presets\elven_knight.ahk"]
                  , "F10": ["剑鬼 (测试版)", "presets\experimental\ghostblade.ahk"]}

global defaultPreset = "F6"
