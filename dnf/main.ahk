#NoEnv
#SingleInstance force

SetWorkingDir %A_ScriptDir%

#Include, lib\common_pre.ahk
#Include, config.ahk

if not A_IsAdmin {
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

global processes = {}

; Main

for k, v in presets {
	processes[k] := []
	fn := Func("ApplyPreset").bind(k)
	Hotkey, %k%, %fn%
}

ApplyPreset(defaultPreset)

; Class & Function

class MyProcess {
	__New(targetScriptPath, arg) {
		Run, "%A_AhkPath%" /f "%targetScriptPath%" "%arg%", , , pid
		this.pid := pid
	}

	__Delete() {
		Process, Close, % this.pid
	}
}

ApplyPreset(toggleKey) {
	for k, v in presets {
		if (k != toggleKey) {
			processes[k].Delete(processes[k].MinIndex(), processes[k].MaxIndex())
		}
		else {
			if (processes[k].Length() == 0) {
				if (not Instr(v[2], ".ahk")) {
					; 常规连发
					for _, keys in StrSplit(v[2], ";") {
						processes[k].push(new MyProcess("lib\autofire.ahk", keys))
					}
				} else {
					; 特殊方案
					processes[k].push(new MyProcess(v[2], ""))
				}
				ToolTip1s("切换至 -> " . v[1])
			}
		}
	}
}

#Include, lib\common_post.ahk