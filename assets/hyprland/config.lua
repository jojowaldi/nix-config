-- https://eiontusk.github.io/hyprlang2lua/
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_QPA_PLATFORMTHEME_QT6", "gtk3")

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    -- AUTOSTART_APPS is set per host in modules/home/hyprland/default.nix
    if AUTOSTART_APPS then
        hl.exec_cmd("discord")
        hl.exec_cmd("spotify")
    end
end)
