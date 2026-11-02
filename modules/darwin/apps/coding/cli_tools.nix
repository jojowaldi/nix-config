{ pkgs, ... }:

# claude-code comes from home.coding.editor, gh from home.coding.git
{
  environment.systemPackages = with pkgs; [
    devenv
  ];
}
