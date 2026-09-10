{ pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    generateCompletions = true;

    shellInit = ''
      set fish_greeting
      set -U fish_color_command blue
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="$HOME/go/bin:$PATH"
      export PATH="$HOME/.pub-cache/bin:$PATH"
    '';

    interactiveShellInit = ''
      fastfetch
    '';

    shellAliases = {
      nix-shell = "nix-shell --run fish";
      k = "kubectl";
      tf = "terraform";
      ls = "eza";
      z = "zeditor";
      g = "git";
    };

    shellAbbrs = {
      l = "eza -l -a --icons --group-directories-first";
      gco = "git checkout";
      gcom = "git checkout main";
      gcob = "git checkout -b";
      gb = "git branch";
      gbd = "git branch -d";
      gbD = "git branch -D";
      gcm = "git commit -m";
      gacm = "git add -A && git commit -m";
      gca = "git commit --amend --no-edit";
      gcae = "git commit --amend";
      gpl = "git pull";
      gps = "git push";
      gpsu = "git push --set-upstream origin";
      ga = "git add";
      gaa = "git add -A";
      grao = "git remote add origin";
      gmm = "git merge main --no-edit";
      gmme = "git merge main";
      gbss = "git bisect start";
      gbsg = "git bisect good";
      gbsb = "git bisect bad";
      gbsr = "git bisect reset";
      c = "cargo";
      cb = "cargo build";
      cr = "cargo run";
      cbr = "cargo build --release";
      crr = "cargo run --release";
      entity-gen = "sea-orm-cli generate entity -o entity/src/entities --entity-format dense --with-serde both";
      migrate-gen = "sea-orm-cli migrate generate";
      rmf = "rm -rf";
      dco = "docker compose up";
      clr = "clear";
      k9s = "k9s -c ctx";
      pcr = "pre-commit run --all-files";
      pcu = "pre-commit authupdate";
      n = "nvim";
      ff = "fastfetch --config ~/.config/fastfetch/fastfetch.jsonc";
      stc = "sudo systemd-cryptenroll --wipe-slot=tpm2";
      ste = "sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=\"0+2+3+7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000\" --tpm2-with-pin=yes";
      stm = "sudo systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=true --tpm2-pcrlock=/var/lib/systemd/pcrlock.json";
    };

    functions = {
      envsource = {
        body = ''
          set -f envfile "$argv"
          if not test -f "$envfile"
            echo "Unable to load $envfile"
            return 1
          end
          while read line
            if not string match -qr '^#|^$' "$line"
              set item (string split -m 1 '=' $line)
              set -gx $item[1] (string trim -c '\'"' -- $item[2])
              echo "Exported key $item[1]"
            end
          end < "$envfile"
        '';
      };
    };

    plugins = [
      {
        name = "nvm";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "nvm.fish";
          rev = "abd3002b6d2d578d484a5aea94dd1517dded6d42";
          sha256 = "sha256-BNnoP9gLQuZQt/0SOOsZaYOexNN2K7PKWT/paS0BJJY=";
        };
      }
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
      {
        name = "abbr-tips";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-abbreviation-tips";
          rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
          sha256 = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
        };
      }
    ];
  };

  programs.man.generateCaches = lib.mkForce false;
}
