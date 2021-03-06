{ stdenv, fetchFromGitHub, cmake, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  pname = "librsync";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "131cd4asmpm4nskidzgiy8xibbnpibvvbq857a0pcky77min5g4z";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl zlib bzip2 popt ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  meta = with stdenv.lib; {
    homepage = "http://librsync.sourceforge.net/";
    license = licenses.lgpl2Plus;
    description = "Implementation of the rsync remote-delta algorithm";
    platforms = platforms.unix;
  };
}
