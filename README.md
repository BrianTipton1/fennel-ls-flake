## fennel-ls flake

> A language server for fennel

### Use with NixOS without home-manager
> In your `flake.nix`
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    fennel-ls.url = "github:BrianTipton1/fennel-ls-flake";
  };

  outputs = {self, nixpkgs, fennel-ls, ...} @ inputs: {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    # ...
    };
  };
}
```
> In `configuration.nix`
```nix
{ config, pkgs, inputs, ... }: {
  # ...
  environment.systemPackages = with pkgs; [
      inputs.fennel-ls.packages.${pkgs.system}.default
  ];
  # ...
}
```


### Use with NixOS and home-manager
> In your `flake.nix`
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    fennel-ls.url = "github:BrianTipton1/fennel-ls-flake";
  };
  outputs = {self, nixpkgs, fennel-ls, ...} @ inputs: {
  # ...
    modules = [
      home-manager.nixosModules.home-manager
        {
	   home-manager.users.USER = import ./home.nix;
	   home-manager.extraSpecialArgs = { inherit inputs; };
        }
   ];
  # ...
}
```

> In `home.nix`
```nix
{ config, pkgs, inputs, ... }: {
  # ...
  home.packages = with pkgs; [
	inputs.fennel-ls.packages.${pkgs.system}.default
];
  # ...
```
