{ pkgs, isLinux, ... }:

{
  home.packages =
    with pkgs;
    [
      neovim
      lua-language-server
      luarocks
      lua
      tree-sitter
      # FIXME: upstream asm-lsp 0.10.1 missing zstd in buildInputs, revert once fixed
      (asm-lsp.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ zstd ];
      }))
      basedpyright
      cmake-language-server
      docker-compose-language-service
      docker-language-server
      eslint
      glsl_analyzer
      gopls
      helm-ls
      vscode-langservers-extracted
      jsonnet-language-server
      just-lsp
      nginx-language-server
      nixd
      rust-analyzer
      svelte-language-server
      tailwindcss-language-server
      terraform-ls
      typescript-language-server
      wgsl-analyzer
      yaml-language-server
      nixfmt
      actions-languageserver
      gitlab-ci-ls
    ]
    ++ (
      if isLinux then
        [
          csharp-ls
        ]
      else
        [ ]
    );
}
