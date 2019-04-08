{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "kilolisp-${version}";
  version = "0.0.1";

  src = fetchurl {
    url = "http://t3x.org/klisp/klisp.tgz";
    sha256 = "1iizks65ffm9232n0ivggq1d0hhkaq5xxdz8paj25nygvg79qnrk";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp kl $out/bin
    cp kl $out/bin/kilolisp
  '';

  meta = with stdenv.lib; {
    description = "A Kilo Byte-Sized LISP System";
    longDescription = ''
      Kilo LISP is a small interpreter for purely symbolic LISP. Its source
      consists of 25K bytes of comprehensible code (20KB C, 5KB LISP) and
      it runs in 64K bytes of memory
    '';
    homepage = http://t3x.org/klisp/index.html;
    license = licenses.cc0;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.all;
  };
}
