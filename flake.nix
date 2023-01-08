{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs"; };
  description = "Fennel Language Server";
  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in with pkgs; {
          default = stdenv.mkDerivation {
            pname = "fennel-ls";
            version = "extra-hooks-2";

            src = fetchGit {
              url = "https://git.sr.ht/~xerool/fennel-ls";
              rev = "70e434839fdf9fad7512118d3f72e38aa8d3ca9f";
            };

            nativeBuildInputs = [ luaPackages.fennel ];

            buildInputs = [ lua ];

            LUA_PATH = "./src/?.lua;./src/?/init.lua";
            FENNEL_PATH = "./src/?.fnl;./src/?/init.fnl";

            buildPhase = ''
              runHook preBuild

              echo "#!${lua}/bin/lua" > fennel-ls
              ${luaPackages.fennel}/bin/fennel --require-as-include --compile src/fennel-ls.fnl >> fennel-ls
              chmod +x fennel-ls

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              install -D ./fennel-ls $out/bin/fennel-ls

              runHook postInstall
            '';

            meta = with lib; {
              description = "Language Server for fennel";
              homepage = "https://git.sr.ht/~xerool/fennel-ls";
              license = licenses.mit;
              platforms = lua.meta.platforms;
            };
          };
        });
    };
}
