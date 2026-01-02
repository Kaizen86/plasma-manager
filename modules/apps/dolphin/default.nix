{ config, lib, pkgs, ... }:

let
  cfg = config.programs.dolphin;

in
{
  options.programs.dolphin= {
    enable = lib.mkEnableOption "configuration module for KDE dolphin";
    package =
      lib.mkPackageOption pkgs
        [
          "kdePackages"
          "dolphin"
        ]
        {
          nullable = true;
          example = "pkgs.libsForQt5.dolphin";
          extraDescription = ''
            Use `pkgs.libsForQt5.dolphin` for Plasma 5 or `pkgs.kdePackages.dolphin` for Plasma 6.
            You can also set this to `null` if you're using a system-wide installation of Dolphin on NixOS.
          '';
        };

    foo = lib.types.submodule {
      bar = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "example value";
        description = ''
          Description for the option
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    programs.plasma.configFile."dolphinrc" =
      let
        some_helper_function = i: i;
      in
      lib.mkMerge [
        (lib.mkIf (cfg.foo.bar != null) {
          FooCategory.BarOption.value = cfg.foo.bar;
        })
      ];
  };
}
