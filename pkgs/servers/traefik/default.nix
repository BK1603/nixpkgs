{ stdenv, fetchurl, buildGoModule, go-bindata, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.2.11";

  src = fetchurl {
    url = "https://github.com/containous/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    sha256 = "00kprbr437ml33bxm4nhxm9vwh6ywrpxvlij7p3r306bfpwa4j3r";
  };

  unpackPhase = ''
    mkdir source
    cd source
    tar xf $src
  '';

  vendorSha256 = "06x2mcyp6c1jdf5wz51prhcn071d0580322lcv3x2bxk2grx08i2";

  doCheck = false;

  subPackages = [ "cmd/traefik" ];

  nativeBuildInputs = [ go-bindata ];

  passthru.tests = { inherit (nixosTests) traefik; };

  preBuild = ''
    go generate

    CODENAME=$(awk -F "=" '/CODENAME=/ { print $2}' script/binary)

    buildFlagsArray+=("-ldflags=\
      -X github.com/containous/traefik/v2/pkg/version.Version=${version} \
      -X github.com/containous/traefik/v2/pkg/version.Codename=$CODENAME")
  '';

  meta = with stdenv.lib; {
    homepage = "https://traefik.io";
    description = "A modern reverse proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ vdemeester ];
  };
}
