{ inputs, ... }:
{
  imports = [
    "${inputs.files}/flake-module.nix"
  ];

  perSystem = { ... }: {
    files.writer.app = true;
  };

  flake-file.inputs.files = {
    url = "github:mightyiam/files";
    flake = false;
  };
}
