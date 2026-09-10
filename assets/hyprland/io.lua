hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1",
})

hl.device({
    name = "norwii-norwii-wireless-presenter-keyboard",
    enabled = true,
})

hl.device({
    name = "norwii-norwii-wireless-presenter-consumer-control",
    enabled = true,
})

hl.config({
    input = {
        kb_layout = "de",
        numlock_by_default = true,
        accel_profile = "flat",
        sensitivity = 0.4,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
        },
    },
})
