hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("corona ipc screenshot"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("corona ipc color-picker"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("corona ipc session lock"))

hl.bind("SUPER + TAB", hl.dsp.exec_cmd("corona ipc switcher"))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.exec_cmd("corona ipc switcher --mode workspace --current-monitor"))

-- Repeatable and Locked Binds (e = repeat, l = works when locked)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("corona ipc volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("corona ipc volume down"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("corona ipc brightness up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("corona ipc brightness down"), { locked = true, repeating = true })

-- Locked Binds (l = works when locked)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("corona ipc volume mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("corona ipc mic mute"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("corona ipc media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("corona ipc media previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("corona ipc media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("corona ipc media pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("corona ipc media pause"), { locked = true })
hl.bind("XF86BrightnessMax", hl.dsp.exec_cmd("corona ipc brightness set 100"), { locked = true })
hl.bind("XF86BrightnessMin", hl.dsp.exec_cmd("corona ipc brightness set 1"), { locked = true })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("corona ipc session lock-and-suspend"), { locked = true })
hl.bind("XF86Suspend", hl.dsp.exec_cmd("corona ipc session lock-and-suspend"), { locked = true })

-- Unlocked XF86 Binds
hl.bind("XF86WLAN", hl.dsp.exec_cmd("corona ipc wifi toggle"))
hl.bind("XF86Bluetooth", hl.dsp.exec_cmd("corona ipc bluetooth toggle"))
hl.bind("XF86Battery", hl.dsp.exec_cmd("corona ipc power-profile cycle"))
hl.bind("XF86DoNotDisturb", hl.dsp.exec_cmd("corona ipc notification dnd toggle"))
hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("corona ipc session lock"))
hl.bind("XF86LogOff", hl.dsp.exec_cmd("corona ipc session logout"))
hl.bind("XF86SelectiveScreenshot", hl.dsp.exec_cmd("corona ipc screenshot selection"))
hl.bind("XF86ControlPanel", hl.dsp.exec_cmd("corona ipc settings toggle"))

-- Locked Key Binds
local opts = { non_consuming = true, locked = true }
hl.bind("Caps_Lock",   hl.dsp.exec_cmd("corona ipc lock-key caps"),   opts)
hl.bind("Num_Lock",    hl.dsp.exec_cmd("corona ipc lock-key num"),    opts)
hl.bind("Scroll_Lock", hl.dsp.exec_cmd("corona ipc lock-key scroll"), opts)

hl.config({
  decoration = {
    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      vibrancy = 0.1696,
    },
  },
})

hl.layer_rule({ match = { namespace = "corona_panel" }, no_anim = true })
hl.layer_rule({ match = { namespace = "corona_notification" }, no_anim = true })
hl.layer_rule({ match = { namespace = "corona_unlock" }, no_anim = true })
