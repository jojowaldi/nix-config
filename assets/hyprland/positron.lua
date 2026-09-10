hl.bind("SUPER + N", hl.dsp.exec_cmd("positron ipc toggle"))

hl.layer_rule({
    match = { namespace = "^(positron)$" },
    no_anim = true,
})
