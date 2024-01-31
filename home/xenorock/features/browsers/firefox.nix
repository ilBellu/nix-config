{ pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.xenorock = {
      isDefault = true;
      extensions = with pkgs.inputs.firefox-addons; [
        # Privacy
        ublock-origin
        decentraleyes
        privacy-badger
        # Youtube
        return-youtube-dislikes
        sponsorblock
        youtube-shorts-block
        # youtube-recommended-videos.overrideAttrs TODO: Fix licensing issue.
        # Password Manager
        keepassxc-browser
      ];
      search.default = "DuckDuckGo";
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          iconUpdateURL = "https://search.nixos.org/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = ["@nixp"];
        };
        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "type";
                  value = "options";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          iconUpdateURL = "https://search.nixos.org/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = ["@nixo"];
        };
        "Nix Flakes" = {
          urls = [
            {
              template = "https://search.nixos.org/flakes";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          iconUpdateURL = "https://search.nixos.org/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = ["@nixf"];
        };
        "Home Manager" = {
          urls = [
            {
              template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";
            }
          ];
          iconUpdateURL = "https://mipmip.github.io/home-manager-option-search/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = ["@nixho"];
        };
        "NixOS Wiki" = {
          urls = [
            {
              template = "https://nixos.wiki/index.php?search={searchTerms}";
            }
          ];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["@nixw"];
        };
        "Github Repositories" = {
          urls = [
            {
              template = "https://github.com/search?q={searchTerms}&type=repositories";
            }
          ];
          iconUpdateURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["@ghr"];
        };
        "Github Users" = {
          urls = [
            {
              template = "https://github.com/search?q={searchTerms}&type=users";
            }
          ];
          iconUpdateURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["@ghu"];
        };
        "Google".metaData.alias = "@g";
      };
      search.order = ["DuckDuckGo" "google"];
      search.force = true;
      bookmarks = {};
      settings = {
        "browser.disableResetPrompt" = true;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.homepage" = "https://start.duckduckgo.com";
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotectionenabled" = true;
      };
    };
  };
}
