{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    extraConfig.pipewire."92-samplerates" = {
      "context.properties" = {
        "default.clock.rate" = 44100;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
      };
    };

    # Topping E2x2 comes up as 7.1 surround; force the hardware sink to stereo (ch 1/2)
    wireplumber.extraConfig."51-topping-stereo" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~alsa_output.usb-Topping_E2x2_OTG.*"; } ];
          actions.update-props = {
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
        }
      ];
    };
  };
}
