{ pkgs, ... }:

let
  settings = builtins.readFile ../../../assets/other/zed.json;

  cursor-agent-fix-script = ''
    #!/usr/bin/env node
    const { spawn } = require('child_process');
    const readline = require('readline');

    const CURSOR_AGENT = process.env.CURSOR_AGENT_BIN
      ?? "${pkgs.cursor-cli}/bin/cursor-agent";

    const child = spawn(CURSOR_AGENT, ['acp'], {
      stdio: ['pipe', 'pipe', 'inherit'],
      env: process.env,
    });

    const rl = readline.createInterface({ input: process.stdin });
    rl.on('line', line => {
      let msg;
      try { msg = JSON.parse(line); } catch { child.stdin.write(line + '\n'); return; }

      if (msg.method === 'initialize') {
        msg.params ??= {};
        msg.params.clientCapabilities ??= {};
        msg.params.clientCapabilities._meta ??= {};
        msg.params.clientCapabilities._meta.parameterizedModelPicker = true;
      }
      child.stdin.write(JSON.stringify(msg) + '\n');
    });
    rl.on('close', () => child.stdin.end());

    child.stdout.on('data', d => process.stdout.write(d));
    child.on('exit', code => process.exit(code ?? 0));
  '';

  cursor-agent-fix = pkgs.writeScriptBin "cursor-agent-fix" cursor-agent-fix-script;
in
{
  programs.zed-editor = {
    enable = true;
    userSettings = (builtins.fromJSON settings) // {
      agent_servers = {
        cursor = {
          type = "custom";
          command = "${cursor-agent-fix}/bin/cursor-agent-fix";
          args = [ ];
          default_config_options = {
            model = "composer-2.5";
            fast = "false";
          };
        };
      };
    };
    installRemoteServer = true;
  };

  programs.vscode = {
    enable = true;
  };

  home.packages = with pkgs; [
    cursor-cli
    code-cursor
    claude-code
  ];
}
