{ self, ... }:

{
  imports = with self.modules; [
    inputs
    users.normal
  ];
}
