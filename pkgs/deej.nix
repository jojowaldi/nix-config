{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  libappindicator,
  webkitgtk_4_1,
  deejSrc ? null,
  gitCommit ? "9c0307b",
  versionTag ? "0.9.10-unstable",
}:

buildGoModule rec {
  pname = "deej";
  version = versionTag;

  src =
    if deejSrc != null then
      deejSrc
    else
      fetchFromGitHub {
        owner = "omriharel";
        repo = "deej";
        rev = "9c0307b96341538ec46f18d2e9b18aaa84441175";
        hash = "sha256-ztaVbWQiX59gPlrtvxNqJGqpMYApOKwIUvE4lS/sWVw=";
      };

  vendorHash = "sha256-1gjFPD7YV2MTp+kyC+hsj+NThmYG3hlt6AlOzXmEKyA=";

  subPackages = [ "pkg/deej/cmd" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    libappindicator
    webkitgtk_4_1
  ];

  postPatch = ''
        substituteInPlace pkg/deej/session_finder_linux.go \
          --replace-fail '"github.com/jfreymuth/pulse/proto"' '"github.com/jfreymuth/pulse/proto"
    	"strings"' \
          --replace-fail 'newSession := newPASession(sf.sessionLogger, sf.client, info.SinkInputIndex, info.Channels, name.String())' \
                         'procName := name.String()
    		newSession := newPASession(sf.sessionLogger, sf.client, info.SinkInputIndex, info.Channels, procName)
    		cleanName := strings.TrimSuffix(strings.TrimPrefix(procName, "."), "-wrapped")
    		if cleanName != procName {
    			cleanSession := newPASession(sf.sessionLogger, sf.client, info.SinkInputIndex, info.Channels, cleanName)
    			*sessions = append(*sessions, cleanSession)
    		}'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.gitCommit=${gitCommit}"
    "-X main.versionTag=${versionTag}"
    "-X main.buildType=release"
  ];

  preBuild = ''
    # getlantern/systray hardcodes webkit2gtk-4.0
    for file in $(grep -rl "webkit2gtk-4.0" . 2>/dev/null || true); do
      chmod +w "$file" 2>/dev/null || true
      substituteInPlace "$file" --replace-quiet "webkit2gtk-4.0" "webkit2gtk-4.1"
    done
  '';

  postInstall = ''
        if [ -f "$out/bin/cmd" ]; then
          mv $out/bin/cmd $out/bin/.deej-unwrapped
        elif [ -f "$out/bin/deej" ]; then
          mv $out/bin/deej $out/bin/.deej-unwrapped
        fi

        cat << 'WRAPPER' > $out/bin/deej
    #!/bin/sh
    if [ ! -f "config.yaml" ] && [ -d "$HOME/.config/deej" ]; then
      cd "$HOME/.config/deej"
    fi
    exec "@out@/bin/.deej-unwrapped" "$@"
    WRAPPER
        substituteInPlace $out/bin/deej --subst-var out
        chmod +x $out/bin/deej
  '';

  meta = with lib; {
    description = "Open-source hardware volume mixer for Windows and Linux";
    homepage = "https://github.com/omriharel/deej";
    license = lib.licenses.mit;
    mainProgram = "deej";
    platforms = lib.platforms.linux;
  };
}
