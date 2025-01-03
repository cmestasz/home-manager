{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cricro";
  home.homeDirectory = "/home/cricro";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    vscodium
    swaynotificationcenter
    wireplumber
    hyprpolkitagent
    waybar
    hyprpaper
    wofi
    wl-clipboard
    cliphist
    nautilus
    hypridle
    hyprlock
    hyprshot
    hyprcursor
    nerd-fonts.caskaydia-mono
    libsForQt5.qt5ct
    catppuccin-gtk
    nwg-look
    brightnessctl
    neovim
    fzf
    gotop
    tree
    devbox
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.neovim.extraLuaPackages = [ pkgs.luajitPackages.luarocks_bootstrap ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      nixroot="/etc/nixos"
      nixhome="$HOME/.config/home-manager"
      codiumdata="$HOME/.config/VSCodium"
      eval "$(direnv hook zsh)"
      nix-devbox-init() { 
        $nixhome/programs/devbox-init/combine "$@"
        echo '.devbox\n.envrc' >> .gitignore
        devbox generate direnv
      }    
    '';

    shellAliases = {
      nix-root-config = "sudo codium --no-sandbox --user-data-dir $codiumdata $nixroot";
      nix-config = "codium $nixhome";
      nix-reload = "sudo nixos-rebuild switch";
      nix-flakereload = "cd $nixroot && sudo nix flake update && sudo nixos-rebuild switch --flake .";
      nix-cleanup = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cls = "clear";
      git-ac = "git add . && git commit -m";
      git-p = "git push";
    };
    
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  programs.starship.enable = true;

  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "Christian";
    userEmail = "cmestasz@unsa.edu.pe";
    extraConfig.init.defaultBranch = "main";
  };

  programs.kitty.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  home.sessionVariables = {
    
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
