hl.monitor({
    output = "DP-3",
    mode = "2560x1440@240Hz",
    position = "1920x0",
})

hl.monitor({
    output = "DP-2",
    mode = "1920x1080@75Hz",
    position = "4480x0",
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60Hz",
    position = "0x0",
})

hl.workspace_rule({
    workspace = "1",
    monitor = "DP-3",
    default = true,
})

hl.workspace_rule({
    workspace = "2",
    monitor = "DP-2",
    default = true,
})

hl.workspace_rule({
    workspace = "3",
    monitor = "HDMI-A-1",
    default = true,
})

