-- Application Launchers
hl.bind("ALT + space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("vicinae deeplink vicinae://launch/clipboard/history"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("brave"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("ALT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen(1))
hl.bind("SUPER + I", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Move Focus
hl.bind("ALT + H", hl.dsp.focus({ direction = "left" }))
hl.bind("ALT + J", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + K", hl.dsp.focus({ direction = "up" }))
hl.bind("ALT + L", hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + left", hl.dsp.focus({ direction = "left" }))
hl.bind("ALT + down", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + up", hl.dsp.focus({ direction = "up" }))
hl.bind("ALT + right", hl.dsp.focus({ direction = "right" }))

-- Move Window
hl.bind("SUPER + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + J", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + right", hl.dsp.window.move({ direction = "r" }))

-- Switch Workspace
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

-- move active window to workspace
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- scroll through workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- special workspaces
hl.bind("SUPER + E", hl.dsp.workspace.toggle_special("magic-e"))
hl.bind("SUPER + SHIFT + E", hl.dsp.window.move({ workspace = "special:magic-e" }))
hl.bind("SUPER + D", hl.dsp.workspace.toggle_special("magic-d"))
hl.bind("SUPER + SHIFT + D", hl.dsp.window.move({ workspace = "special:magic-d" }))

-- Wayscriber
hl.bind("SUPER + W", hl.dsp.exec_cmd("pkill -SIGUSR1 wayscriber"))

-- Mouse Bindings
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

-- Gestures
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "fullscreen",
})
