{
  description = "Statusline in the best language ever";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, self}: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };

    buildOptions = {
      pkgs,
      config,
      lib,
      ...
    }: let
      cfg = config.programs.statusline-cob;
    in {
      programs.statusline-cob = {
        enable = lib.mkEnableOption "statusline-cob";
        theme = lib.mkOption {
          type = lib.types.enum ["ROSEPINE" "GRUVBOX" "SOLARIZE"];
          default = "ROSEPINE";
          example = "SOLARIZE";
        };
        pollingInterval = lib.mkOption {
          type = lib.types.addCheck lib.types.int (x: x > 0 && x < 999);
          default = 1;
          example = 5;
        };
        modules = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule ({config, ...}: {
            options = {
              enable = lib.mkEnableOption "this module" // { default = true; };
              name = lib.mkOption {type = lib.types.str;};
              color = lib.mkOption {
                type = lib.types.str;
              };
              path = lib.mkOption {type = lib.types.str;};
              type = lib.mkOption {type = lib.types.str;};
              raw = lib.mkOption {type = lib.types.str;};
              user_section = lib.mkOption {type = lib.types.str;};
            };

            config = let
              makeString = str: n: let
                length = builtins.stringLength str;
                spaces = n - length;
                padding = assert spaces >= 0; lib.concatMapStrings (_: " ") (lib.range 1 spaces);
              in
                str + padding;
            in {
              user_section = lib.mkDefault (
                let
                  functions = {
                    BATTERY = (makeString config.path 41) + (makeString config.type 1);
                    SEPARATOR = (makeString config.path 41) + (makeString config.type 1);
                    SPACE = makeString "" 42;
                  };
                  data = functions.${config.name};
                in
                  data
              );
              raw = assert (builtins.stringLength config.user_section) <= 42;
                lib.mkDefault
                (
                  "MODULE  "
                  + (if config.enable then " " else "*")
                  + (makeString config.name 12)
                  + " "
                  + (makeString config.color 7)
                  + config.user_section
                );
            };
          }));
        };

        env = lib.mkOption {
          type = lib.types.attrs;
          default = {};
        };

        plugins = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [];
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = let
            exports = lib.concatLines (builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.env));
            connect = x: y: lib.concatStrings (lib.intersperse x y);
            config = pkgs.writeTextFile {
              name = "config";
              destination = "/config.cfg";
              text = cfg.config;
            };
          in
            pkgs.writeShellScriptBin "statusline-cob" ''
              ${exports}
              export COB_LIBRARY_PATH=${lib.makeLibraryPath cfg.plugins}
              export COB_PRE_LOAD=${connect ":" (builtins.map (v: v.name) cfg.plugins)}
              export STATUSLINE_CONFIG=${config}/config.cfg
              exec ${pkgs.statusline-cob-unwrapped}/bin/status
            '';
        };

        config = lib.mkOption {
          type = lib.types.lines;
          default = let
            polling' = builtins.toString cfg.pollingInterval;
            pollingSize = 3 - builtins.stringLength polling';
            polling = assert pollingSize <= 3; (lib.concatMapStrings (_: "0") (lib.range 1 pollingSize)) + polling';

            modules = builtins.map (x: x.raw) cfg.modules;
          in
            ''
              GENERAL               EBCDIC ${polling} ${cfg.theme}
            ''
            + lib.concatLines modules;
        };
      };
    };
  in {
    overlays.default = final: prev: {
      statusline-cob-unwrapped = final.callPackage ./default.nix {};
    };
    nixosModules.default = inputs @ {
      pkgs,
      config,
      lib,
      ...
    }: {
      options = buildOptions inputs;
      config = lib.mkIf config.programs.statusline-cob.enable {
        nixpkgs.overlays = [ self.overlays.default ];
        environment.systemPackages = [config.programs.statusline-cob.package];
      };
    };
    homeManagerModules.default = inputs @ {
      pkgs,
      config,
      lib,
      ...
    }: {
      options = buildOptions inputs;
      config = lib.mkIf config.programs.statusline-cob.enable {
        nixpkgs.overlays = [ self.overlays.default ];
        home.packages = [config.programs.statusline-cob.package];
      };
    };
    devShells.x86_64-linux.default = import ./shell.nix {inherit pkgs;};
  };
}
