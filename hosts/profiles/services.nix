{ self, ... }:

{
  imports = with self.modules; [
    services.core.audio
    services.core.bluetooth
    services.core.btrfs
    services.core.gpg
    services.core.keyring
    services.core.security
    services.core.time

    services.network.network
    services.network.sshd
    services.network.tailscale

    services.media.media
    services.media.printing

    services.gui.display-manager
    services.gui.noctalia-legacy
    #services.gui.noctalia
    services.gui.sddm
    #services.gui.noctalia-greeter

    services.coding.docker
  ];
}
