{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.vscodium = {
    enable = true;

    package = pkgs.vscodium;

    profiles.default = {
      userSettings = {

        # ----------------------------------------------------------------------
        # Editor
        # ----------------------------------------------------------------------

        "editor.fontSize" = 14;
        "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace";

        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.6;

        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.detectIndentation" = false;

        "editor.renderWhitespace" = "all";
        "editor.renderControlCharacters" = true;
        "editor.renderLineHighlight" = "all";

        "editor.minimap.enabled" = false;

        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;

        "editor.wordWrap" = "on";

        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;

        # ----------------------------------------------------------------------
        # Files
        # ----------------------------------------------------------------------

        "files.autoSave" = "onFocusChange";
        "files.insertFinalNewline" = true;
        "files.trimTrailingWhitespace" = true;
        "files.trimFinalNewlines" = true;
        "files.eol" = "\n";

        "files.exclude" = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/.DS_Store" = true;
          "**/__pycache__" = true;
          "**/*.pyc" = true;
          "**/.venv" = true;
          "**/venv" = true;
          "**/env" = true;
          "**/node_modules" = true;
        };

        # ----------------------------------------------------------------------
        # Git
        # ----------------------------------------------------------------------

        "git.enable" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.allowForcePush" = false;
        "git.fetchOnPull" = true;
        "git.pullTags" = true;
        "git.pruneOnFetch" = true;

        "git.decorations.enabled" = true;
        "git.detectSubmodules" = true;
        "git.path" = "git";

        "git.rebaseWhenSync" = false;
        "git.enableStatusBarSync" = true;

        "git.showActionButton" = {
          commit = true;
          publish = true;
          sync = true;
        };

        # ----------------------------------------------------------------------
        # Terminal
        # ----------------------------------------------------------------------

        "terminal.integrated.defaultProfile.linux" = "bash";
        "terminal.integrated.fontSize" = 14;

        "terminal.integrated.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";

        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.cursorBlinking" = true;

        "terminal.integrated.scrollback" = 10000;
        "terminal.integrated.shellIntegration.enabled" = true;

        "terminal.integrated.enablePersistentSessions" = false;

        # ----------------------------------------------------------------------
        # Workbench
        # ----------------------------------------------------------------------

        "workbench.startupEditor" = "none";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.tree.indent" = 20;
        "workbench.sideBar.location" = "left";
        "workbench.editor.enablePreview" = false;
        "workbench.editor.labelFormat" = "short";
        "workbench.editor.tabSizing" = "shrink";
        "workbench.editor.tabCloseButton" = "right";
        "workbench.editor.tabActionLocation" = "right";
        "workbench.statusBar.visible" = true;

        # ----------------------------------------------------------------------
        # Window
        # ----------------------------------------------------------------------

        "window.titleBarStyle" = "custom";
        "window.menuBarVisibility" = "compact";
        "window.zoomLevel" = 0;
        "window.nativeTabs" = false;

        # ----------------------------------------------------------------------
        # Explorer
        # ----------------------------------------------------------------------

        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "explorer.compactFolders" = false;
        "explorer.autoReveal" = true;

        # ----------------------------------------------------------------------
        # Python
        # ----------------------------------------------------------------------

        "python.defaultInterpreterPath" = "python3";

        "python.terminal.activateEnvironment" = true;
        "python.terminal.activateEnvInCurrentTerminal" = true;

        "python.analysis.typeCheckingMode" = "basic";
        "python.analysis.diagnosticMode" = "workspace";

        "python.analysis.autoSearchPaths" = true;
        "python.analysis.useLibraryCodeForTypes" = true;

        "python.analysis.autoImportCompletions" = true;
        "python.analysis.completeFunctionParens" = true;

        # ----------------------------------------------------------------------
        # Nix
        # ----------------------------------------------------------------------

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # ----------------------------------------------------------------------
        # Markdown
        # ----------------------------------------------------------------------

        "markdown.preview.fontSize" = 16;
        "markdown.preview.lineHeight" = 1.6;

        # ----------------------------------------------------------------------
        # Telemetry
        # ----------------------------------------------------------------------

        "telemetry.telemetryLevel" = "off";

        "update.mode" = "none";

        # ----------------------------------------------------------------------
        # Search
        # ----------------------------------------------------------------------

        "search.exclude" = {
          "**/node_modules" = true;
          "**/.venv" = true;
          "**/venv" = true;
          "**/env" = true;
          "**/dist" = true;
          "**/build" = true;
          "**/__pycache__" = true;
          "**/*.pyc" = true;
          "**/.git" = true;
        };

        # ----------------------------------------------------------------------
        # Scrolling
        # ----------------------------------------------------------------------

        "editor.smoothScrolling" = true;
        "editor.cursorSmoothCaretAnimation" = "on";

        # ----------------------------------------------------------------------
        # Diff
        # ----------------------------------------------------------------------

        "diffEditor.ignoreTrimWhitespace" = true;
        "diffEditor.renderSideBySide" = true;

        # ----------------------------------------------------------------------
        # Security
        # ----------------------------------------------------------------------

        # Keep Workspace Trust enabled: unknown repositories may contain tasks,
        # extensions, and settings capable of executing code.
        "security.workspace.trust.untrustedFiles" = "prompt";
        "security.workspace.trust.enabled" = true;
      };

      extensions = with pkgs.vscode-extensions; [

        # Themes
        pkief.material-icon-theme

        # Git
        mhutchie.git-graph

        # Python
        ms-python.vscode-pylance
        ms-python.debugpy
        charliermarsh.ruff
        njpwerner.autodocstring

        # Nix
        jnoortheen.nix-ide

        # Build / languages
        ms-vscode.makefile-tools
        redhat.vscode-yaml
        rust-lang.rust-analyzer

        # Docker
        ms-azuretools.vscode-docker

        # Markdown
        yzhang.markdown-all-in-one

        # Bash
        mads-hartmann.bash-ide-vscode

        # Editor
        editorconfig.editorconfig
      ];

      # ------------------------------------------------------------------------
      # KEYBINDINGS
      # ------------------------------------------------------------------------

      keybindings = [
        {
          key = "ctrl+shift+t";
          command = "workbench.action.terminal.new";
        }

        {
          key = "ctrl+shift+e";
          command = "workbench.view.explorer";
        }

        {
          key = "ctrl+shift+g";
          command = "workbench.view.scm";
        }

        {
          key = "ctrl+shift+d";
          command = "workbench.view.debug";
        }

        {
          key = "ctrl+shift+x";
          command = "workbench.view.extensions";
        }

        {
          key = "ctrl+shift+p";
          command = "workbench.action.showCommands";
        }

        {
          key = "ctrl+shift+f";
          command = "workbench.action.findInFiles";
        }

        {
          key = "ctrl+`";
          command = "workbench.action.terminal.toggleTerminal";
        }

        {
          key = "ctrl+shift+s";
          command = "git.sync";
        }

        {
          key = "ctrl+shift+c";
          command = "git.commit";
        }

        {
          key = "ctrl+shift+r";
          command = "python.sortImports";
        }

        {
          key = "ctrl+tab";
          command = "workbench.action.nextEditor";
        }

        {
          key = "ctrl+shift+tab";
          command = "workbench.action.previousEditor";
        }

        # Ctrl+W/Ctrl+Shift+W retain the default VSCodium/desktop shortcuts instead
        # of being overridden by this public example.
      ];
    };
  };
}
