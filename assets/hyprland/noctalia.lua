hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("noctalia msg session lock"))

hl.bind("SUPER + TAB", hl.dsp.exec_cmd("noctalia msg window-switcher hold"))

-- Repeatable and Locked Binds (e = repeat, l = works when locked)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd("noctalia msg keyboard-backlight-up"), { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("noctalia msg keyboard-backlight-down"), { locked = true, repeating = true })

-- Locked Binds (l = works when locked)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia msg media pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("noctalia msg media stop"), { locked = true })
hl.bind("XF86BrightnessMax", hl.dsp.exec_cmd("noctalia msg brightness-set 100"), { locked = true })
hl.bind("XF86BrightnessMin", hl.dsp.exec_cmd("noctalia msg brightness-set 1"), { locked = true })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("noctalia msg session lock-and-suspend"), { locked = true })
hl.bind("XF86Suspend", hl.dsp.exec_cmd("noctalia msg session lock-and-suspend"), { locked = true })
hl.bind("XF86KbdLightOnOff", hl.dsp.exec_cmd("noctalia msg keyboard-backlight-toggle"), { locked = true })

-- Unlocked XF86 Binds
hl.bind("XF86WLAN", hl.dsp.exec_cmd("noctalia msg wifi-toggle"))
hl.bind("XF86Bluetooth", hl.dsp.exec_cmd("noctalia msg bluetooth-toggle"))
hl.bind("XF86Battery", hl.dsp.exec_cmd("noctalia msg power-cycle"))
hl.bind("XF86DoNotDisturb", hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"))
hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind("XF86LogOff", hl.dsp.exec_cmd("noctalia msg session logout"))
hl.bind("XF86SelectiveScreenshot", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("XF86ControlPanel", hl.dsp.exec_cmd("noctalia msg settings-toggle"))

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

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
  },
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})
