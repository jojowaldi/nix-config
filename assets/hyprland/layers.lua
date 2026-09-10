hl.window_rule({
    match = {
        class = "^(org.gnome.)",
    },
    rounding = 12,
    border_size = 0,
})

hl.window_rule({
    match = {
        class = "^(org.wezfurlong.wezterm)$",
    },
    border_size = 0,
})

hl.window_rule({
    match = {
        class = "^(Alacritty)$",
    },
    border_size = 0,
})

hl.window_rule({
    match = {
        class = "^(zen)$",
    },
    border_size = 0,
})

hl.window_rule({
    match = {
        class = "^(com.mitchellh.ghostty)$",
    },
    border_size = 0,
})

hl.window_rule({
    match = {
        class = "^(kitty)$",
    },
    border_size = 0,
})

hl.window_rule({
    match = {
        class = "^(gnome-calculator)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(blueman-manager)$",
    },
    float = true,
})

-- windowrulev2 = float, class:^(org.gnome.Nautilus)$
hl.window_rule({
    match = {
        class = "^(org.quickshell)$",
    },
    float = true,
})

-- Unreal Engine Editor Rules
hl.window_rule({
    match = {
        class = "^(UnrealEditor)$",
        title = "^\\w*$",
    },
    no_initial_focus = true,
    suppress_event = "activate",
    group = "unset"
})
