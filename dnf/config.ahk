; 说明
; presets: 方案 (用逗号隔开的是不能无冲的, 用分号隔开的是无冲的)
;          举例说明 "x,a,q" 是有冲突的, 同时按 xaq 不能同时连发; "x,q;a;s" xq 有冲突但 xas 或 qas 都是无冲连发
; defaultPreset: 默认开启的方案
; duration: 如果键没按出来, 适当调高此参数
; delay: 如果键没按出来, 适当调高此参数 (优先调 duration, 不行再调 delay)
; 逗号在下一行是 AHK 的蹩脚 parser 不支持常规多行声明的写法所致

global duration := 50
global delay := 2

global presets := { "F5": ["基本", "x,a,q"]
                  , "F6": ["力法/剑影/剑魂", "x;a;z,f,g,q,w,e,t,y"]
                  , "F7": ["精灵骑士", "presets\elven_knight.ahk"]
                  ; , "F8": ["DK", "x,a,s,d,f,g,e,r,t"]
                  ; , "F9": ["剑魂 (PK)", "x;z;a,d,f,g,v,b,q,e,r,t"]
                  ; , "F10": ["鹦鹉 (PK)", "x;z;a,s,d,f,g,v,b,w,e,r,t,y,tab"]
                  , "F10": ["鼠标连点", "presets\click.ahk"]}

global defaultPreset = "F7"
