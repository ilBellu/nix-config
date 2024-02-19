{
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  # Dependencies
  cat = "${pkgs.coreutils}/bin/cat";
  cut = "${pkgs.coreutils}/bin/cut";
  find = "${pkgs.findutils}/bin/find";
  grep = "${pkgs.gnugrep}/bin/grep";
  pgrep = "${pkgs.procps}/bin/pgrep";
  tail = "${pkgs.coreutils}/bin/tail";
  wc = "${pkgs.coreutils}/bin/wc";
  timeout = "${pkgs.coreutils}/bin/timeout";
  ping = "${pkgs.iputils}/bin/ping";

  jq = "${pkgs.jq}/bin/jq";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  wofi = "${pkgs.wofi}/bin/wofi";

  # Function to simplify making waybar outputs
  jsonOutput = name: {
    pre ? "",
    text ? "",
    tooltip ? "",
    alt ? "",
    class ? "",
    percentage ? "",
  }: "${pkgs.writeShellScriptBin "waybar-${name}" ''
    set -euo pipefail
    ${pre}
    ${jq} -cn \
      --arg text "${text}" \
      --arg tooltip "${tooltip}" \
      --arg alt "${alt}" \
      --arg class "${class}" \
      --arg percentage "${percentage}" \
      '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
  ''}/bin/waybar-${name}";

  hasSway = config.wayland.windowManager.sway.enable;
  sway = config.wayland.windowManager.sway.package;
  hasHyprland = config.wayland.windowManager.hyprland.enable;
  hyprland = config.wayland.windowManager.hyprland.package;
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
    systemd.enable = lib.mkForce false; # Waybar needs to be run by hyprland else the custom/gpu module doesn't work for nvidia
    settings = {
      secondary = {
        layer = "top";
        position = "bottom";
        height = 40;
        width = 30;
        fixed-center = true;

        modules-center = (lib.optionals hasHyprland ["hyprland/workspaces" "hyprland/submap"]) ++ (lib.optionals hasSway ["sway/workspaces" "sway/mode"]);
      };
      primary = {
        layer = "top";
        position = "top";
        height = 40;
        margin = "6";
        mode = "dock";
        fixed-center = true;

        modules-left = [
          "custom/menu"
          "custom/currentplayer"
          "custom/player"
        ];

        modules-center = [
          # "battery"
          "cpu"
          "memory"
          "custom/gpu"
          "clock"
          "pulseaudio"
          "custom/unread-mail"
          #"custom/gpg-agent"
          "idle_inhibitor"
        ];

        modules-right = [
          "custom/tailscale-ping"
          "network"
          "tray"
          "custom/hostname"
        ];

        cpu = {
          format = "  {usage}%";
        };

        "custom/gpu" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "gpu" {
            text = "$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader)";
            tooltip = "GPU Usage";
          };
          format = "󰍛  {}";
        };

        memory = {
          format = "󰒋  {}%";
          interval = 5;
        };

        clock = {
          interval = 1;
          format = "{:%d/%m %H:%M:%S}";
          format-alt = "{:%d-%m-%Y %H:%M:%S %z}";
          on-click-left = "mode";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = ["" "" ""];
          };
          on-click = pavucontrol;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };

        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };

        network = {
          interval = 3;
          format-wifi = "   {essid} {ipaddr}/{cidr}   {bandwidthUpBits}   {bandwidthDownBits}";
          format-ethernet = "󰈁  {essid} {ipaddr}/{cidr}   {bandwidthUpBits}   {bandwidthDownBits}";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };

        "custom/tailscale-ping" = {
          interval = 10;
          return-type = "json";
          exec = let
            inherit (builtins) concatStringsSep attrNames;
            hosts = attrNames outputs.nixosConfigurations;
            homeMachine = "lust";
          in
            jsonOutput "tailscale-ping" {
              # Build variables for each host
              pre = ''
                set -o pipefail
                ${concatStringsSep "\n" (map (host: ''
                    ping_${host}="$(${timeout} 2 ${ping} -c 1 -q ${host} 2>/dev/null | ${tail} -1 | ${cut} -d '/' -f5 | ${cut} -d '.' -f1)ms" || ping_${host}="Disconnected"
                  '')
                  hosts)}
              '';
              # Access a remote machine's and a home machine's ping
              # text = "  $ping_${remoteMachine} /  $ping_${homeMachine}";
              text = "  $ping_${homeMachine}";
              # Show pings from all machines
              tooltip = concatStringsSep "\n" (map (host: "${host}: $ping_${host}") hosts);
            };
          format = "{}";
          on-click = "";
        };
        "custom/menu" = let
          isFullScreen =
            if hasHyprland
            then "${hyprland}/bin/hyprctl activewindow -j | ${jq} -e '.fullscreen' &>/dev/null"
            else "false";
        in {
          interval = 1;
          return-type = "json";
          exec = jsonOutput "menu" {
            text = "";
            tooltip = ''$(${cat} /etc/os-release | ${grep} PRETTY_NAME | ${cut} -d '"' -f2)'';
            class = "$(if ${isFullScreen}; then echo fullscreen; fi)";
          };
          on-click-left = "${wofi} -S drun -x 10 -y 10 -W 25% -H 60%";
          on-click-right = lib.concatStringsSep ";" (
            (lib.optional hasHyprland "${hyprland}/bin/hyprctl dispatch togglespecialworkspace")
            ++ (lib.optional hasSway "${sway}/bin/swaymsg scratchpad show")
          );
        };

        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
        };

        "custom/unread-mail" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "unread-mail" {
            pre = ''
              count=$(${find} ~/Mail/*/Inbox/new -type f | ${wc} -l)
              if ${pgrep} mbsync &>/dev/null; then
                status="syncing"
              else if [ "$count" == "0" ]; then
                status="read"
              else
                status="unread"
              fi
              fi
            '';
            text = "$count";
            alt = "$status";
          };
          format = "{icon}  ({})";
          format-icons = {
            "read" = "󰇯";
            "unread" = "󰇮";
            "syncing" = "󰁪";
          };
        };

        # "custom/gpg-agent" = {
        # interval = 2;
        # return-type = "json";
        # exec =
        # let gpgCmds = import ../../../cli/gpg-commands.nix { inherit pkgs; };
        # in
        # jsonOutput "gpg-agent" {
        # pre = ''status=$(${gpgCmds.isUnlocked} && echo "unlocked" || echo "locked")'';
        # alt = "$status";
        # tooltip = "GPG is $status";
        # };
        # format = "{icon}";
        # format-icons = {
        # "locked" = "";
        # "unlocked" = "";
        # };
        # on-click = "";
        # };

        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = jsonOutput "currentplayer" {
            pre = ''
              player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No player active" | ${cut} -d '.' -f1)"
              count="$(${playerctl} -l 2>/dev/null | ${wc} -l)"
              if ((count > 1)); then
                more=" +$((count - 1))"
              else
                more=""
              fi
            '';
            alt = "$player";
            tooltip = "$player ($count available)";
            text = "$more";
          };
          format = "{icon}{}";
          format-icons = {
            "No player active" = " ";
            "Celluloid" = "󰎁 ";
            "spotify" = "󰓇 ";
            "ncspot" = "󰓇 ";
            "qutebrowser" = "󰖟 ";
            "firefox" = " ";
            "discord" = " 󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
            "chromium" = " ";
          };
          on-click = "${playerctld} shift";
          on-click-right = "${playerctld} unshift";
        };

        "custom/player" = {
          exec-if = "${playerctl} status 2>/dev/null";
          exec = ''${playerctl} metadata --format '{"text": "{{title}} - {{artist}}", "alt": "{{status}}", "tooltip": "{{title}} - {{artist}} ({{album}})"}' 2>/dev/null '';
          return-type = "json";
          interval = 1;
          max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = "${playerctl} play-pause";
        };
      };
    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    style = let
      inherit (config.colorscheme) palette;
    in
      /*
      css
      */
      ''
        * {
          font-family: ${config.fontProfiles.regular.family}, ${config.fontProfiles.monospace.family};
          font-size: 12pt;
          padding: 0 8px;
        }

        window#waybar {
          padding: 0;
          opacity: 0.75;
          border-radius: 0.5em;
          background-color: #${palette.base00};
          color: #${palette.base05};
        }

        .modules-left {
          margin-left: -15px;
        }

        .modules-right {
          margin-right: -15px;
        }

        window#waybar.top {
          opacity: 0.95;
          background-color: #${palette.base00};
          border: 2px solid #${palette.base0C};
          border-radius: 10px;
        }

        window#waybar.bottom {
          opacity: 0.95;
          margin: 0;
          padding: 0;
          background-color: #${palette.base00};
          border: 2px solid #${palette.base0C};
          border-radius: 10px;
        }

        #workspaces button {
          background-color: #${palette.base01};
          color: #${palette.base05};
          padding: 5px 10px;
          margin: 3px 0;
        }

        #workspaces button.hidden {
          background-color: #${palette.base00};
          color: #${palette.base04};
        }

        #workspaces button.focused,
        #workspaces button.active {
          background-color: #${palette.base0A};
          color: #${palette.base00};
        }

        #clock {
          background-color: #${palette.base0C};
          color: #${palette.base00};
          padding-left: 15px;
          padding-right: 15px;
          margin-top: 0;
          margin-bottom: 0;
          border-radius: 10px;
        }

        #custom-menu {
          background-color: #${palette.base0C};
          color: #${palette.base00};
          padding-left: 15px;
          padding-right: 22px;
          margin: 0;
          border-radius: 10px;
        }
        #custom-hostname {
          background-color: #${palette.base0C};
          color: #${palette.base00};
          padding-left: 15px;
          padding-right: 18px;
          margin-right: 0;
          margin-top: 0;
          margin-bottom: 0;
          border-radius: 10px;
        }
        #custom-currentplayer {
          padding-right: 0;
        }
        #tray {
          color: #${palette.base05};
        }
      '';
  };
}
