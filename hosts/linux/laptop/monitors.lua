do
    local internal = {
        output = "eDP-1",
        mode = "2880x1800@120Hz",
        position = "0x0",
        scale = "1.5",
        -- hl.monitor() merges into an existing rule for the same output, so
        -- this must be explicit to undo `disabled = true` from disable_internal().
        disabled = false,
    }

    hl.monitor(internal)

    -- Clamshell mode: turn off the internal panel when the lid closes while an
    -- external monitor is connected. logind ignores the lid when docked
    -- (HandleLidSwitchDocked = "ignore"), otherwise it suspends as usual.
    local function has_external_monitor()
        for _, m in ipairs(hl.get_monitors()) do
            if m.name ~= internal.output and m.enabled then
                return true
            end
        end
        return false
    end

    local function enable_internal()
        hl.monitor(internal)
    end

    local function disable_internal()
        hl.monitor({ output = internal.output, disabled = true })
    end

    hl.bind("switch:on:Lid Switch", function()
        if has_external_monitor() then
            disable_internal()
        end
    end, { locked = true })

    hl.bind("switch:off:Lid Switch", enable_internal, { locked = true })

    -- Never end up without any screen when the external monitor is unplugged
    -- while the lid is closed.
    hl.on("monitor.removed", function()
        if not has_external_monitor() then
            enable_internal()
        end
    end)
end
