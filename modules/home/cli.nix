{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ============================================================================
  # BASH
  # ============================================================================

  programs.bash = {
    enable = true;

    historyControl = [
      "ignoreboth"
      "erasedups"
    ];

    historySize = 10000;
    historyFileSize = 20000;

    shellAliases = {

      # ------------------------------------------------------------------------
      # Navigation
      # ------------------------------------------------------------------------

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "~" = "cd ~";

      md = "mkdir -p";
      rmr = "rm -rIv";
      mktoday = "mkdir -p \"$(date +%Y-%m-%d)\"";

      # ------------------------------------------------------------------------
      # Eza (ls replacement)
      # ------------------------------------------------------------------------

      ll = "eza -lah --group-directories-first";
      la = "eza -la --group-directories-first";
      lt = "eza --tree --level=2 --group-directories-first";
      l = "eza -l --group-directories-first";
      ltree = "eza --tree --level=3 --group-directories-first";
      lsize = "eza -lah --sort=size --group-directories-first";
      lold = "eza -lah --sort=oldest --group-directories-first";

      # ------------------------------------------------------------------------
      # Git
      # ------------------------------------------------------------------------

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gpl = "git pull";
      gl = "git log --oneline --graph --decorate --all";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      gr = "git restore";
      gst = "git stash";
      gsp = "git stash pop";
      gcl = "git clone";
      gf = "git fetch";

      # ------------------------------------------------------------------------
      # Python / UV
      # ------------------------------------------------------------------------

      py = "python";
      py3 = "python3";

      uvi = "uv init";
      uva = "uv add";
      uvr = "uv remove";
      uvs = "uv sync";
      uvb = "uv build";
      uvp = "uv publish";
      uvl = "uv lock";
      uvtree = "uv tree";

      serve = "python -m http.server 8000";
      http = "python -m http.server";
      json = "python -m json.tool";

      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";

      # ------------------------------------------------------------------------
      # Docker
      # ------------------------------------------------------------------------

      dps = "docker ps";
      dpsa = "docker ps -a";
      di = "docker images";
      dirm = "docker rmi";
      drm = "docker rm";
      dstop = "docker stop";
      dex = "docker exec -it";
      dlogs = "docker logs -f";

      dcp = "docker compose";
      dcpu = "docker compose up -d";
      dcpd = "docker compose down";
      dcps = "docker compose ps";
      dclogs = "docker compose logs -f";

      lb = "lazydocker";

      # ------------------------------------------------------------------------
      # Nix
      # ------------------------------------------------------------------------

      # NIXOS_DOTFILES can be overridden in the shell when the repository is cloned
      # elsewhere. The default is defined in bashrcExtra below.
      nix-rebuild = "(cd \"$NIXOS_DOTFILES\" && sudo nixos-rebuild switch --flake .#$(hostname))";
      nix-drybuild = "(cd \"$NIXOS_DOTFILES\" && sudo nixos-rebuild dry-build --flake .#$(hostname))";
      nix-lock = "(cd \"$NIXOS_DOTFILES\" && nix flake lock)";
      nix-clean = "sudo nix-collect-garbage -d";
      nix-gen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nix-check = "(cd \"$NIXOS_DOTFILES\" && nix flake check)";

      # Dev Shells
      nix-default = "nix develop \"$NIXOS_DOTFILES#default\"";
      nix-native = "nix develop \"$NIXOS_DOTFILES#native\"";
      nix-runtimes = "nix develop \"$NIXOS_DOTFILES#runtimes\"";
      nix-python = "nix develop \"$NIXOS_DOTFILES#python\"";
      nix-ai = "nix develop \"$NIXOS_DOTFILES#ai\"";
      nix-devops = "nix develop \"$NIXOS_DOTFILES#devops\"";
      nix-cuda = "nix develop \"$NIXOS_DOTFILES#cuda\"";

      reload = "source ~/.bashrc";

      # ------------------------------------------------------------------------
      # Network
      # ------------------------------------------------------------------------

      myip = "ip -4 -brief addr show scope global";
      pubip = "curl -s ifconfig.me && echo";
      localip = "sudo arp-scan --localnet";
      ping = "ping -c 20";
      ports = "ss -tulpn";
      listen = "ss -tulpn | grep LISTEN";

      # ------------------------------------------------------------------------
      # Tmux
      # ------------------------------------------------------------------------

      t = "tmux";
      ta = "tmux attach";
      tn = "tmux new -s";
      tl = "tmux list-sessions";
      tk = "tmux kill-session -t";

      # ------------------------------------------------------------------------
      # Misc
      # ------------------------------------------------------------------------

      weather = "curl -s wttr.in";
      qr = "qrencode -t utf8";

      batp = "bat --paging=always";
      batc = "bat --paging=never";
      soff = "kscreen-doctor --dpms off";
    };

    bashrcExtra = ''
      # Conventional path for the public clone. Override it before this file is
      # loaded if you prefer another location.
      export NIXOS_DOTFILES="''${NIXOS_DOTFILES:-$HOME/NIXOS-Blueprint}"

      # =========================================================================
      # FUNCTIONS
      # =========================================================================

      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      backup() {
        cp -v "$1" "''${1}.bak"
      }

      backup-date() {
        cp -v "$1" "''${1}.$(date +%Y-%m-%d).bak"
      }

      ff() {
        fd "$@"
      }

      extract() {
        if [ -f "$1" ]; then
          case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      tmp() {
        local file
        file=$(mktemp "''${TMPDIR:-/tmp}/tmp.XXXXXX")
        "''${EDITOR:-nano}" "$file"
      }

      dirsize() {
        dust "$@"
      }

      diskus() {
        duf "$@"
      }

      ytsub() {
        if [ "$#" -ne 1 ]; then
          echo 'Usage: ytsub "URL"'
          return 1
        fi

        local url="$1"

        URL="$url" nix-shell -p yt-dlp ffmpeg --run '
          yt-dlp \
            --skip-download \
            --write-auto-subs \
            --sub-langs "en-orig" \
            --convert-subs srt \
            --sleep-requests 1 \
            --sleep-subtitles 5 \
            --retries 10 \
            --retry-sleep "http:exp=1:20" \
            --no-playlist \
            "$URL"
        '
      }

      # =========================================================================
      # EDITOR
      # =========================================================================

      export EDITOR=nano
      export VISUAL=nano
      export PAGER=less
      export LESS="-R -M --shift 5"

      export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

      # =========================================================================
      # GIT PROMPT
      # =========================================================================

      parse_git_branch() {
        git branch 2>/dev/null |
          sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
      }

      export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '

      # =========================================================================
      # BASH OPTIONS
      # =========================================================================

      shopt -s histappend
      shopt -s checkwinsize
      shopt -s globstar
      shopt -s cdable_vars

      # =========================================================================
      # TIPS
      # =========================================================================

      tips() {
        echo "┌─ NixOS - Dev Shells ─────────────────────────────┐"
        echo "│                                                  │"
        echo "│  nix-default   → Base environment                │"
        echo "│  nix-native    → C/C++ development               │"
        echo "│  nix-runtimes  → Node/Go/Java/Rust               │"
        echo "│  nix-python    → Python/UV stack                 │"
        echo "│  nix-ai        → ML/AI + CUDA toolkit            │"
        echo "│  nix-devops    → Kubernetes tools                │"
        echo "│  nix-cuda      → CUDA development                │"
        echo "└──────────────────────────────────────────────────┘"
        echo ""
        echo "  Available Nix commands:"
        echo "  nix-rebuild   → Apply system changes"
        echo "  nix-drybuild  → Simulate changes (dry-run)"
        echo "  nix-lock      → Update flake.lock"
        echo "  nix-clean     → Clean store (garbage collection)"
        echo "  nix-gen       → List system generations"
        echo "  nix-check     → Check flake"
        echo ""
      }
    '';
  };

  # ============================================================================
  # FZF
  # ============================================================================

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;

    defaultOptions = [
      "--height 40%"
      "--border"
      "--layout reverse"
      "--preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'"
    ];

    fileWidgetOptions = [
      "--preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'"
    ];

    changeDirWidgetOptions = [
      "--preview 'eza --tree --color=always {} | head -200'"
    ];
  };

  # ============================================================================
  # BAT
  # ============================================================================

  programs.bat = {
    enable = true;

    config = {
      paging = "never";
      style = "numbers,changes,header,grid";
      theme = "Dracula";
    };
  };

  # ============================================================================
  # ZOXIDE
  # ============================================================================

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  # ============================================================================
  # TMUX
  # ============================================================================

  programs.tmux = {
    enable = true;

    clock24 = true;
    mouse = true;

    terminal = "screen-256color";

    historyLimit = 100000;

    extraConfig = ''
      set -g escape-time 10

      setw -g mode-keys vi

      set -g renumber-windows on

      bind | split-window -h
      bind - split-window -v

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind Tab next-window
      bind S-Tab previous-window

      set -g status-left "#[fg=green]#S "
      set -g status-right "#[fg=blue]%H:%M #[fg=white]%d/%m/%y"

      set -g status-style "bg=black,fg=white"
      set -g window-status-current-style "bg=blue,fg=white,bold"
    '';
  };
}
