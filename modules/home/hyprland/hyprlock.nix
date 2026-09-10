{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprlock
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        immediate_render = true;
      };

      auth = {
        "fingerprint:enabled" = true;
      };

      background = {
        color = "rgba(10, 14, 20, 1)";
      };

      image = [
        # Profile icon
        {
          path = "/var/lib/AccountsService/icons/$USER";
          border_size = 0;
          size = 120;
          rounding = -1;
          rotate = 0;
          reload_time = -1;
          position = "0, 35";
          halign = "center";
          valign = "center";
        }
        # Input icon
        {
          path = "${../../../assets/images/key.png}";
          size = 20;
          border_size = 0;
          rounding = -1;
          rotate = 0;
          reload_time = -1;
          position = "-100, -79";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # Username
        {
          text = "<span font_weight=\"700\">$USER</span>";
          color = "rgba(255, 255, 255, 1)";
          font_size = 14;
          font_family = "RedHatDisplay";
          position = "0, -45";
          halign = "center";
          valign = "center";
        }
        #Power off
        {
          text = "󰐥 ";
          color = "rgba(255, 255, 255, 1)";
          font_size = 14;
          onclick = "reboot now";
          position = "-55, 55";
          halign = "right";
          valign = "bottom";
        }
        # Reboot
        {
          text = "󰜉 ";
          color = "rgba(255, 255, 255, 1)";
          font_size = 14;
          onclick = "shutdown now";
          position = "-85, 55";
          halign = "right";
          valign = "bottom";
        }
        # Suspend
        {
          text = "󰤄 ";
          color = "rgba(255, 255, 255, 1)";
          font_size = 14;
          onclick = "systemctl suspend";
          position = "-115, 55";
          halign = "right";
          valign = "bottom";
        }
      ];

      input-field = {
        size = "235, 30";
        outline_thickness = 0;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(255, 255, 255, 0)";
        inner_color = "rgba(255, 255, 255, 0.1)";
        font_color = "rgb(255, 255, 255)";
        fade_on_empty = false;
        font_family = "RedHatDisplay";
        placeholder_text = "<i>Password⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀</i>";
        hide_input = false;
        position = "0, -79";
        rounding = 10;
        halign = "center";
        valign = "center";
      };
    };
  };

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ../../../assets/hyprland/hyprlock.lua;
}
