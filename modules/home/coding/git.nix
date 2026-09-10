{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    git
    delta
  ];

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-skyline
      gh-stack
      gh-classroom
      gh-webhook
    ];
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = config.userSpec.git_user;
        email = config.userSpec.git_email;
      };

      alias = {
        a = "add";
        aa = "add -A";
        cm = "commit -m";
        com = "checkout main";
        b = "branch";
        bd = "branch -d";
        bdd = "branch -D";
        pl = "pull";
        ps = "push";
        psu = "push --set-upstream origin";
        co = "checkout";
        cob = "checkout -b";
        rao = "remote add origin";
        mm = "merge main --no-edit";
        mme = "merge main";
      };

      pull = {
        rebase = true;
      };

      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_${config.userSpec.git_sign_key}.pub";

      push = {
        autoSetupRemote = true;
        followTags = true;
        recurseSubmodules = "on-demand";
      };

      rebase = {
        autoStash = true;
      };

      init = {
        defaultBranch = "main";
      };

      submodule = {
        recurse = true;
      };

      core = {
        pager = "delta";
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      delta = {
        navigate = true;
        dark = true;
      };

      merge = {
        conflictstyle = "zdiff3";
      };
    };
  };
}
