{ self, ... }:

{
  imports = with self.modules; [
    darwin.services.core.security
    darwin.services.network.net_tools
  ];
}
