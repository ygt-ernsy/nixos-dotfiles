 { config, pkgs, ... }:

{
    home.username = "yigit";
    home.homeDirectory = "/home/yigit";
    home.stateVersion = "26.05";

    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
        };

        plugins = [
            {
                name = "powerlevel10k";
                src = pkgs.zsh-powerlevel10k;
                file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
        ];

        shellAliases = {
            btw = "echo I use nixos btw";
            t = "tmux a || tmux";
            v = "nvim";
            nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-dotfiles#nixos-btw";
        };

        initContent = ''
        # Force git to prompt in the terminal instead of the GUI askpass dialog
        unset SSH_ASKPASS
        unset GIT_ASKPASS
        export GOPATH=$HOME/.go
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.local/scripts:$PATH"
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        if [ -f "$HOME/.zshrc.secrets" ]; then
            source "$HOME/.zshrc.secrets"
        fi
        '';
    };

    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.git = {
        enable = true;
        package = pkgs.git.override { withLibsecret = true; };
        lfs.enable = true;
        settings = {
            user.name = "ygt-ernsy";
            user.email = "yigiterensoy@hotmail.com";
            credential.helper = "libsecret";
        };
    };

    qt = {
        enable = true;
        platformTheme.name = "qt6ct";
        style.name = "kvantum";
    };

    gtk.enable = true;

    # clean up later
    home.file.".config/Kvantum/Kvantum-Tokyo-Night".source = 
    "${pkgs.fetchFromGitHub {
      owner = "0xsch1zo";
      repo = "Kvantum-Tokyo-Night";
      rev = "main";
      hash = "sha256-mcxTggpj2SVhHur7xzZxHeOZO7QtWCZsq0m6eJKy6aQ=";
    }}/Kvantum-Tokyo-Night";

    home.file.".config/Kvantum/KvLibadwaita".source = 
    "${pkgs.fetchFromGitHub {
      owner = "GabePoel";
      repo = "KvLibadwaita";
      rev = "main";
      hash = "sha256-jCXME6mpqqWd7gWReT04a//2O83VQcOaqIIXa+Frntc=";
    }}/src/KvLibadwaita";

    home.file.".config/Kvantum/rose-pine-iris".source = 
        "${pkgs.rose-pine-kvantum}/share/Kvantum/themes/rose-pine-iris";

    # sort later
    home.packages = with pkgs; [
    dgop
    obsidian
    matugen
    libsecret
    github-cli
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
    oh-my-zsh
    fzf
    fnm
    adw-gtk3
    gtk-engine-murrine
    sassc
    gnome-themes-extra
    rose-pine-gtk-theme
    tokyonight-gtk-theme
    glib
    stow
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    kdePackages.qt6ct
    libsForQt5.qt5ct
    nwg-look
    tela-icon-theme
	fastfetch
	waybar
	unzip
    neovim
	rofi
	dms-shell
	kdePackages.dolphin	
	bibata-cursors
	lxqt.lxqt-policykit
	hypridle
	hyprshot
	ripgrep
	nixpkgs-fmt
	tree-sitter
	quickshell
	nodejs
	gcc
    ];
}
