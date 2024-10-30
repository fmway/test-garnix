{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ascii-live";
  version = "unstable-2023-10-08";

  src = fetchFromGitHub {
    owner = "hugomd";
    repo = "ascii-live";
    rev = "0e53a4799f1e707a45d059cb326df06d70aa7925";
    hash = "sha256-0o+LuqyOscBKUr7fZXSF9UZoC/3Y4Q7DVZU9cZM4GgU=";
  };

  vendorHash = "sha256-rNBeFFkfw3iyzBvoa1QrsMC2qvvJUZ22RPB+qUARInA=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "An extension to parrot.live, with support for more animations! http://ascii.live";
    homepage = "https://github.com/hugomd/ascii-live";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ascii-live";
  };
}
