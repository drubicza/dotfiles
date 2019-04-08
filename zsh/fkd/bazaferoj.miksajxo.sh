# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Alinomoj
#---------------------------------------------------------------------------------------------------

global_aliases=(
  A='`grla`'
  B='`gbrh`'
  K='`sk`'
  C="|& c"
  V="|& less"
  G="|& rg --color auto"
  S="|& sort"
  R="S -rn"
  Y="|& tee"
  H="|& head"
  T="|& tail"
  H1="H -n 1"
  T1="T -n 1"
  L="|& wc -l | sed 's/^\ *//'"
  N.='*(.L0)'     # nulo-longecaj regulaj dosieroj
  N/='*(/L0)'     # nulo-longecaj dosierujoj
  Z,='{,.}*'      # ĉiuj dosieroj, inkluzive punkto-dosieroj
  Z.='**/*(.)'    # ĉiuj regulaj dosieroj
  Z/='**/*(/)'    # ĉiuj dosierujoj
  Z@='**/*(@)'    # ĉiuj simbolligiloj
  M.='*(.om[-1])' # malplej nova regula dosiero
  M/='*(/om[-1])' # malplej nova dosierujo
  M@='*(@om[-1])' # malplej nova simbolligilo
  P.='*(.om[1])'  # plej nova regula dosiero
  P/='*(/om[1])'  # plej nova dosierujo
  P@='*(@om[1])'  # plej nova simblolligilo
); def_global_aliases

program_aliases=(
  md="e"
  txt="e"
  rkt="e"
  lisp="e"
  scm="e"
  ss="e"
  nix="e"
  tex="e"

  pdf="za"
  dvi="ok"
  epub="eb"
  html="o"

  mp4="p"
  mkv="p"

  kra="kr"

  jpg="b"
  png="b"
  gif="b"

  ods="lo"
  odt="lo"
  odg="lo"
  odf="lo"
  docx="lo"
  xlsx="lo"

  exe="wine"
); def_program_aliases


#---------------------------------------------------------------------------------------------------
# Diversaĵoj
#---------------------------------------------------------------------------------------------------

ulimit -c 0
umask 027
