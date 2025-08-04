#!/bin/bash

# ┏━┓┏━┓┏━┓┏┓ ┏━┓
# ┃ ┃┃ ┃┃ ┃┣┻┓┃ ┃  Modular Kali ARM64 Setup by @iamsoftware
# ┗━┛┗━┛┗━┛┗━┛┗━┛  v1.0 with Theme + Tools + Stealth Flags

# ┌────────────────────────────┐
# │     Default Flag Values    │
# └────────────────────────────┘
INSTALL_VPN=false
INSTALL_OSCP=false
RUN_MINIMAL=false
ENABLE_STEALTH=false
APPLY_DOTFILES=false
APPLY_PURPLE_THEME=false
APPLY_XFCE_THEME=false

# ┌────────────────────────────┐
# │      Flag Parsing Logic     │
# └────────────────────────────┘
for arg in "$@"; do
  case $arg in
    --vpn) INSTALL_VPN=true ;;
    --oscp-pack) INSTALL_OSCP=true ;;
    --minimal) RUN_MINIMAL=true ;;
    --stealth) ENABLE_STEALTH=true ;;
    --dotfiles) APPLY_DOTFILES=true ;;
    --kali-purple) APPLY_PURPLE_THEME=true ;;
    --xfce-vanilla) APPLY_XFCE_THEME=true ;;
    --help)
      echo "Usage: $0 [flags]"
      echo "Flags:"
      echo "  --vpn            Install WireGuard and OpenVPN"
      echo "  --oscp-pack      Install tools for OSCP prep"
      echo "  --minimal        Skip tool installs"
      echo "  --stealth        Enable stealth mode with hardened rules"
      echo "  --dotfiles       Apply custom shell dotfiles from @iamsoftware"
      echo "  --kali-purple    Apply Kali Purple UI"
      echo "  --xfce-vanilla   Reset XFCE theme to upstream defaults"
      exit 0
      ;;
    *) echo "❗ Unknown option: $arg" ;;
  esac
done

# ┌────────────────────────────┐
# │      Modular Functions      │
# └────────────────────────────┘

install_vpn_tools() {
  echo "🛡️ Installing VPN tools..."
  sudo apt install -y wireguard openvpn dnscrypt-proxy
}

install_oscp_pack() {
  echo "⚔️ Installing OSCP prep tools..."
  sudo apt install -y gobuster seclists nmap metasploit-framework netcat
}

enable_stealth_mode() {
  echo "🕵️ Enabling stealth mode..."
  sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
  sudo iptables -A INPUT -p tcp --dport 1:65535 -j DROP
  sudo apt install -y dnscrypt-proxy
  sudo systemctl enable dnscrypt-proxy && sudo systemctl start dnscrypt-proxy
}

apply_dotfiles() {
  echo "🎨 Applying @iamsoftware's dotfiles..."
  git clone https://github.com/iamsoftware/dotfiles ~/.dotfiles
  cp ~/.dotfiles/.bashrc ~/.bashrc
  cp ~/.dotfiles/.zshrc ~/.zshrc
  [ -f ~/.bashrc ] && source ~/.bashrc
}

apply_kali_purple_theme() {
  echo "🟣 Applying Kali Purple UI..."
  sudo apt update
  sudo apt install -y kali-community-wallpapers kali-purple-theme
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path \
    -s /usr/share/backgrounds/kali/kali-purple-wallpaper.png
}

apply_xfce_vanilla_theme() {
  echo "🌿 Resetting XFCE to vanilla..."
  sudo apt install -y lightdm-gtk-greeter-settings
  xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita"
  xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"
}

# ┌────────────────────────────┐
# │        Execution Logic      │
# └────────────────────────────┘

[ "$RUN_MINIMAL" = true ] && echo "🌿 Minimal mode active. Skipping installs."
[ "$INSTALL_VPN" = true ] && install_vpn_tools
[ "$INSTALL_OSCP" = true ] && install_oscp_pack
[ "$ENABLE_STEALTH" = true ] && enable_stealth_mode
[ "$APPLY_DOTFILES" = true ] && apply_dotfiles
[ "$APPLY_PURPLE_THEME" = true ] && apply_kali_purple_theme
[ "$APPLY_XFCE_THEME" = true ] && apply_xfce_vanilla_theme

# ┌────────────────────────────┐
# │         Final Summary       │
# └────────────────────────────┘

echo ""
echo "✅ Setup by @iamsoftware complete!"
echo "Flags enabled:"
[ "$INSTALL_VPN" = true ] && echo "  ➤ VPN tools"
[ "$INSTALL_OSCP" = true ] && echo "  ➤ OSCP pack"
[ "$RUN_MINIMAL" = true ] && echo "  ➤ Minimal mode"
[ "$ENABLE_STEALTH" = true ] && echo "  ➤ Stealth mode"
[ "$APPLY_DOTFILES" = true ] && echo "  ➤ Dotfiles applied"
[ "$APPLY_PURPLE_THEME" = true ] && echo "  ➤ Kali Purple