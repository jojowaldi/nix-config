{ lib, pkgs, ... }:

let
  hwOut = "alsa_output.usb-Topping_E2x2_OTG-00.analog-surround-71";
  hwIn = "alsa_input.usb-Topping_E2x2_OTG-00.multichannel-input";
  aux = first: [ "AUX${toString first}" "AUX${toString (first + 1)}" ];

  # Virtual stereo sink -> hardware channels `first`/`first+1`
  toppingOutputs = lib.imap0 (i: name: {
    name = "libpipewire-module-loopback";
    args = {
      "node.description" = "${name} (E2x2)";
      "capture.props" = {
        "node.name" = "topping_out_${toString (i * 2 + 1)}";
        "media.class" = "Audio/Sink";
        "audio.position" = [ "FL" "FR" ];
        # Playback 1/2 becomes the default output
        "priority.session" = 2000 - i;
      };
      "playback.props" = {
        "node.name" = "topping_out_${toString (i * 2 + 1)}.hw";
        "target.object" = hwOut;
        "audio.position" = aux (i * 2);
        "stream.dont-remix" = true;
        "node.dont-reconnect" = true;
        "node.passive" = true;
      };
    };
  }) [ "Playback 1/2" "Playback 3/4" "Playback 5/6" "Playback 7/8" ];

  # Hardware channels `first`/`first+1` -> virtual stereo source.
  # Loopback 1/2 (mic stereo mix) measured on hw ch 5/6; other loopback/Mobile IN slots unverified.
  toppingInputs = lib.imap0 (i: name: {
    name = "libpipewire-module-loopback";
    args = {
      "node.description" = "${name} (E2x2)";
      "capture.props" = {
        "node.name" = "topping_in_${toString (i * 2 + 1)}.hw";
        "target.object" = hwIn;
        "audio.position" = aux (i * 2);
        "stream.dont-remix" = true;
        "node.dont-reconnect" = true;
        "node.passive" = true;
      };
      "playback.props" = {
        "node.name" = "topping_in_${toString (i * 2 + 1)}";
        "media.class" = "Audio/Source";
        "audio.position" = [ "FL" "FR" ];
        "priority.session" = 2000 - i;
      };
    };
  }) [ "Analog 1/2" "Loopback 3/4" "Loopback 1/2" "Loopback 5/6" "Mobile IN" ];
in
{
  # Windows VM (USB passthrough) lowers the E2x2 hardware volume; reset to 0 dB on re-attach
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="sound", KERNEL=="controlC*", ATTRS{idVendor}=="152a", ATTRS{idProduct}=="8756", RUN+="${pkgs.alsa-utils}/bin/amixer -c %n cset name='E2x2 OTG Playback Volume' 127,127,127,127,127,127,127,127"
  '';

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
        # WebRTC (Discord etc.) asks for ~331 samples -> quantum 256 -> EasyEffects xruns (crackle)
        "default.clock.min-quantum" = 512;
      };
    };

    # Topping E2x2: 8 out / 10 in. Split into stereo pairs like the Windows driver does.
    extraConfig.pipewire."93-topping-pairs" = {
      "context.modules" = toppingOutputs ++ toppingInputs;
    };

    # Hardware nodes come up as 7.1 surround; expose raw channels so pairs map 1:1
    wireplumber.extraConfig."51-topping-raw" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~alsa_output.usb-Topping_E2x2_OTG.*"; } ];
          actions.update-props = {
            "audio.channels" = 8;
            "audio.position" = map (i: "AUX${toString i}") (lib.range 0 7);
            "priority.session" = 1;
          };
        }
        {
          matches = [ { "node.name" = "~alsa_input.usb-Topping_E2x2_OTG.*"; } ];
          actions.update-props."priority.session" = 1;
        }
      ];
    };
  };
}
