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

    substituteInPlace pkg/deej/session_map.go \
      --replace-fail '	targets, ok := m.deej.config.SliderMapping.get(event.SliderID)

	// if slider not found in config, silently ignore
	if !ok {
		return
	}' '	targets, ok := m.deej.config.SliderMapping.get(event.SliderID)

	// if slider not found in config, silently ignore
	if !ok {
		return
	}

	for _, target := range targets {
		if strings.Contains(strings.ToLower(target), "spotify") {
			setSpotifyTargetVolume(event.PercentValue)
		}
	}'

    substituteInPlace pkg/deej/session_linux.go \
      --replace-fail '"go.uber.org/zap"' '"net"
	"strings"
	"sync"
	"time"

	"go.uber.org/zap"' \
      --replace-fail 'func (s *paSession) SetVolume(v float32) error {' \
'var (
	spotifyTargetVol   float32 = -1.0
	spotifyTargetVolMu sync.RWMutex
	spotifyWatcherOnce sync.Once
)

func setSpotifyTargetVolume(v float32) {
	spotifyTargetVolMu.Lock()
	spotifyTargetVol = v
	spotifyTargetVolMu.Unlock()
	ensureSpotifyWatcherRunning()
}

func getSpotifyTargetVolume() float32 {
	spotifyTargetVolMu.RLock()
	defer spotifyTargetVolMu.RUnlock()
	return spotifyTargetVol
}

func isSpotifySinkInput(props proto.PropList) bool {
	keys := []string{
		"application.process.binary",
		"application.name",
		"application.icon_name",
	}
	for _, k := range keys {
		if val, ok := props[k]; ok {
			if strings.Contains(strings.ToLower(val.String()), "spotify") {
				return true
			}
		}
	}
	return false
}

func ensureSpotifyWatcherRunning() {
	spotifyWatcherOnce.Do(func() {
		go runSpotifyVolumeMonitor()
	})
}

func init() {
	ensureSpotifyWatcherRunning()
}

func runSpotifyVolumeMonitor() {
	var client *proto.Client
	var conn net.Conn

	connect := func() bool {
		c, rawConn, err := proto.Connect("")
		if err != nil {
			return false
		}
		req := proto.SetClientName{
			Props: proto.PropList{
				"application.name": proto.PropListString("deej-spotify-monitor"),
			},
		}
		var reply proto.SetClientNameReply
		if err := c.Request(&req, &reply); err != nil {
			_ = rawConn.Close()
			return false
		}
		client = c
		conn = rawConn
		return true
	}

	ticker := time.NewTicker(100 * time.Millisecond)
	defer ticker.Stop()

	for range ticker.C {
		target := getSpotifyTargetVolume()
		if target < 0 {
			continue
		}

		if client == nil {
			if !connect() {
				continue
			}
		}

		req := proto.GetSinkInputInfoList{}
		var reply proto.GetSinkInputInfoListReply
		if err := client.Request(&req, &reply); err != nil {
			if conn != nil {
				_ = conn.Close()
			}
			client = nil
			conn = nil
			continue
		}

		for _, info := range reply {
			if !isSpotifySinkInput(info.Properties) {
				continue
			}

			if len(info.ChannelVolumes) == 0 {
				continue
			}

			chans := info.Channels
			if chans == 0 {
				chans = byte(len(info.ChannelVolumes))
			}
			if chans == 0 {
				continue
			}

			currentVol := parseChannelVolumes(info.ChannelVolumes)
			diff := currentVol - target
			if diff < -0.01 || diff > 0.01 {
				setReq := proto.SetSinkInputVolume{
					SinkInputIndex: info.SinkInputIndex,
					ChannelVolumes: createChannelVolumes(chans, target),
				}
				if err := client.Request(&setReq, nil); err != nil {
					if conn != nil {
						_ = conn.Close()
					}
					client = nil
					conn = nil
					break
				}
			}
		}
	}
}

func (s *paSession) SetVolume(v float32) error {
	if strings.Contains(strings.ToLower(s.processName), "spotify") {
		setSpotifyTargetVolume(v)
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
