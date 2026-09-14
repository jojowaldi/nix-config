{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  libappindicator,
  webkitgtk_4_1,
  dbus,
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
    dbus
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

    substituteInPlace pkg/deej/session_linux.go \
      --replace-fail '"go.uber.org/zap"' '"os"
	"os/exec"
	"strings"
	"sync"

	"go.uber.org/zap"' \
      --replace-fail 'func (s *paSession) SetVolume(v float32) error {' \
'var (
	spotifyVolChan  = make(chan float32, 1)
	spotifySyncOnce sync.Once
)

func initSpotifySync() {
	spotifySyncOnce.Do(func() {
		go func() {
			dbusBin := "${dbus}/bin/dbus-send"
			if _, err := os.Stat(dbusBin); err != nil {
				dbusBin = "dbus-send"
			}
			for v := range spotifyVolChan {
				for {
					select {
					case newer := <-spotifyVolChan:
						v = newer
					default:
						goto drained
					}
				}
			drained:
				cmd := exec.Command(dbusBin,
					"--type=method_call",
					"--dest=org.mpris.MediaPlayer2.spotify",
					"/org/mpris/MediaPlayer2",
					"org.freedesktop.DBus.Properties.Set",
					"string:org.mpris.MediaPlayer2.Player",
					"string:Volume",
					fmt.Sprintf("variant:double:%f", v),
				)
				_ = cmd.Run()
			}
		}()
	})
}

func syncSpotifyVolume(v float32) {
	initSpotifySync()
	select {
	case spotifyVolChan <- v:
	default:
		select {
		case <-spotifyVolChan:
		default:
		}
		spotifyVolChan <- v
	}
}

func (s *paSession) SetVolume(v float32) error {' \
      --replace-fail 'if err := s.client.Request(&request, nil); err != nil {' \
'if strings.Contains(strings.ToLower(s.processName), "spotify") {
		syncSpotifyVolume(v)
	}

	if err := s.client.Request(&request, nil); err != nil {'
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
