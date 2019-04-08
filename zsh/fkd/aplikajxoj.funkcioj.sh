# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Ĝeneralaj
#---------------------------------------------------------------------------------------------------

function ck () {
  local sed_cmd='/On branch/d;/nothing to commit/d;/up-to-date/d'

  for i ($HOME/hejmo/fkd/ttt/ebzzry.github.io) {(
    cd $i
    if [[ -d .git ]]; then
        print "\e[0;32m${i:t}\e[0;0m"
        git status | sed $sed_cmd
    fi
  )}

  for i ($HOME/hejmo/ktp/*(/)) {(
    cd $i
    if [[ -d .git ]]; then
        print "\e[0;35m${i:t}\e[0;0m"
        git status | sed $sed_cmd
    fi
  )}
}

function imgura () {
  for x ("$@") {
    for i ($(lump "$x" \
      | grep -i http://i.imgur.com \
      | sed -e 's/^.*\. \(.*\)/\1/' \
      | sort \
      | uniq))
    wget -t 0 -c $i
  }
}

function emv () {
  if [[ $# -eq 2 ]]; then
    mute emacsclient -e "(dired-rename-file \"$1\" \"$2\" t)"
  fi
}

function ecp () {
  if [[ $# -eq 2 ]]; then
    mute emacsclient -e "(dired-copy-file \"$1\" \"$2\" t)"
  fi
}

function mvid3 () {
  local id_val=

  for i (*.[mM][pP]3) {
    id_val="$(id3tool $i | grep "^${1}" | awk '{print $2}')"
    if [[ -n "$id_val" ]]; then
      mkdir "$id_val"
      mv "$i" "$id_val"
    fi
  }
}

function yy () {
  if [[ $# -eq 3 ]]; then
    for i ($(seq $2 $3)) {
          lump "http://www.youtube.com/user/${1}/videos?sort=dd&view=0&page=${i}" \
              | grep youtube.com/watch \
              | awk '{print $2}' \
              | uniq \
              | tac \
                    >>| y.txt
    }
  fi
}

function click () {
  if (( $#1 )); then
    while :; do
      xdotool click 1
      sleep $1
    done
  else
    xdotool click 1
  fi
}

function def_getter () {
  local func=${1}get
  local handler=$1
  local handler_file=$2
  shift 2
  eval "function $func () {
          if (( ! \$#@ )); then
              if [[ -f $handler_file ]]; then
                  $handler $handler_file
              fi
          else
             $@ \"\$@\"
          fi
        }"
}

function def_mapper () {
  local name=$1
  eval "function $name () {
          #trap 'echo trap; return 1' INT
          local line=
          if [[ \$# > 1 ]]; then
              map $name "\$@"
          else
              if [[ -f "\$1" ]]; then
                  mapl $name "\$1"
              elif [[ -d "\$1" ]]; then
                  echo \* \$1
                  (cd "\$1"; $name)
              else
                  line="\$1"
                  if [[ ! \$line[1] == \"#\" ]]; then
                      ${1}get "\$@"
                  fi
              fi
          fi
        }"
}

def_getter y y.txt youtube-dl -c -i
def_getter ya y.txt youtube-dl -c -i --extract-audio --audio-quality 0 --audio-format mp3
def_getter ys y.txt youtube-dl --write-sub --sub-lang en --sub-format srt
def_getter q q.txt wget -t 0 -c

map def_mapper y ya ys q

function mplay () { =mpv $([[ -f mpv.opts ]] && cat mpv.opts) "$@" }

function media_player () {
  if [[ -d "${argv[-1]}" ]]; then
      cd "${argv[-1]}" $0
  else
    if [[ "$1" == *"http"* && "$1" == *"youtu"* ]]; then
        play_offset "$1"
    elif some_files $@; then
        play_offset $@
    else
      play_rest $@
    fi
  fi
}

function play_offset () {
  local times= start= stop=

  if [[ -f ${argv[-1]}.off ]]; then
    times=$(cat ${argv[-1]}.off)
    start=$(echo $times | cut -d ' ' -f 1)
    stop=$(echo $times | cut -d ' ' -f 2)
    if [[ ! "$start" = "$stop" ]]; then
      mplay --start=$start --stop=$stop $@
    else
      mplay --start=$start $@
    fi
  else
    mplay $@
  fi
}

function play_rest () {
  local listfile=in.m3u
  local lastfile=in.last

  if [[ -f $lastfile ]]; then
      mplay $@ "$(cat $lastfile)"
  elif [[ -f $listfile ]]; then
      mplay $@ --playlist=$listfile
  else
    mplay $@
  fi
}

autoload pg

function pk () {
  for name ($@) {
    for pid ($(pg $name | awk '{print $1}')) {
      kill $pid
    }
  }
}

function pk! () {
  for name ($@) {
    for pid ($(pg $name | awk '{print $1}')) {
      s kill -9 $pid
    }
  }
}

function addaptkey () {
  gpg --keyserver subkeys.pgp.net --recv-keys $1
  gpg --armor --export $1 | sudo apt-key add -
}

function aptselect () {
  local debian_version=`cat /etc/debian_version | cut -d \/ -f 1`
  local output_file=sources.list.`date "+%Y-%m-%d-%H-%M"`

  s netselect -s -n ${debian_version} -o ${output_file}
}

function bright () {
  case $1 in
    (off)  xset dpms force off ;;
    (l|low)  s setpci -s 00:02.0 f4.b=35 ;;
    (m|med)  s setpci -s 00:02.0 f4.b=55 ;;
    (h|high) s setpci -s 00:02.0 f4.b=75 ;;
  esac
}

function taf () {
  if (( $#@ >= 2 )); then
    tar -cf - ${argv[1,-2]} | tar -C ${argv[-1]} -xvf -
  else
    return 1
  fi
}

function pecho () {
  while true; do
    mu12 ping1 $1 && stumpish echo "$1 estas supren"
    sleep 60
  done
}


function mky () {
  local base_file="y.txt"

  if [[ -f "y.txt" ]]; then
    mv $base_file \
      ${base_file:r}-"$(print_date $base_file)".${base_file:e}
  fi

  if (( $#1 )); then
    egrep -o 'http(s)://(www.)youtube.com/watch\?v=.{11}' \
      "$1" | tac | uniq > $base_file
  fi
}

# doup pdflatex Zenjutsu.tex
function doup () {
  $1 $2

  while :; do
    local stat_mod="`statmod $2`"
    sleep 1
    if [[ "`statmod $2`" -gt $stat_mod ]]; then
      $1 $2
    fi
  done
}

function mkxspf () {
  local playlist=/dev/stdout
  local media_file=
  local index=0

  # [[ -f $playlist ]] && rm -f $playlist

  cat >>! $playlist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/" xmlns:vlc="http://www.videolan.org/vlc/playlist/ns/0/">
  <title>Playlist</title>
  <trackList>
EOF

for i ($@) {
  media_file=$(fullpath $i)
  UrlFile=file://$(echo $media_file | sed -e 's/\ /%20/g')

  cat >>! $playlist << EOF
    <track>
      <location>$UrlFile</location>
      <extension application="http://www.videolan.org/vlc/playlist/0">
        <vlc:id>$index</vlc:id>
      </extension>
    </track>
EOF

index=$(($index + 1))
}

cat >>! $playlist << EOF
  </trackList>
</playlist>
EOF
}

function y2xspf () {
  mkxspf $(for i ($(c y.txt /a -F = '{print $2}')) find . -maxdepth 1 -iname "${i}*")
}

function mkm3u () {
  local playlist=/dev/stdout

  # [[ -f $playlist ]] && rm -f $playlist

  for i ($@) { echo "$i" >>! $playlist }
}

function mk3 () { mkm3u *.mp3 >! in.m3u }

function y2m3u () {
  mkm3u $(for i ($(c y.txt /a -F = '{print $2}')) find . -maxdepth 1 -iname "${i}*" -print0 | xargs -0 -I x basename x)
}

function locate_db () {
  local db=

  if [[ -f /var/cache/locate/locatedb ]]; then
    db=/var/cache/locate/locatedb
  elif [[ -f $HOME/hejmo/dat/locate/locatedb ]]; then
    db=$HOME/hejmo/dat/locate/locatedb
  else
    db=
  fi

  echo $db

}

function loc () {
  local db="$(locate_db)"

  if [[ -n "$db" ]]; then
    locate -d "$db" -i "$@"
  else
    echo "Error: locate db not found."
    return 1
  fi
}

function loh () { loc "$@" | egrep -i $HOME }

function lou () {
  local db="$(locate_db)"

  if [[ -n "$db" ]]; then
      time s updatedb \
           --output="$db" \
           --prunepaths="/nix /tmp /var/tmp /media /run /home/ugarit /home/chrt /pub/mnt /b0 /mnt"
  else
    echo "Error: locate database not found."
    return 1
 fi
}

function a () {
  local op=

  if (( ! $#1 )); then
    page $0
  else
    op=$1
    shift

    case $op in
      (get) s apt-get $@ ;;
      (cache) apt-cache $@ ;;
      (file) s apt-file $@ ;;
      (att) s aptitude $@ ;;
      (s)  $0 cache search $@ ;;
      (fs) $0 file search $@ ;;
      (h)  $0 cache show $@ ;;
      (v)  $0 cache policy $@ ;;
      (i)  $0 get install $@ ;;
      (ri) $0 get install --reinstall $@ ;;
      (r)  $0 get remove $@ ;;
      (p)  $0 get purge $@ ;;
      (d)  $0 cache depends $@ ;;
      (rd) $0 cache rdepends $@ ;;
      (o)  $0 get source $@ ;;
      (u)  $0 get update $@ ;;
      (uf) $0 file update $@ ;;
      (fu) $0 get dist-upgrade $@ ;;
      (su) $0 get upgrade $@ ;;
      (c)  $0 get clean $@ ;;
      (ac) $0 get autoclean ;;
      (f)  $0 get -f install $@ ;;
      (y)  $0 get -q -y -d dist-upgrade $@ ;;
      (ar) $0 get autoremove ;;
      (rm) s rm /var/lib/dpkg/lock /var/lib/apt/lists/lock ;;
      (l) dpkg -l ;;

      (*)  return 1 ;;
    esac
  fi
}

function om () {
  if (( ! $#1 )); then
    page $0
  else
    op=$1
    shift

    case $op in
      (e) eval `opam config env` ;;

      (l) opam list $@ ;;
      (i) opam install $@ ;;
      (I) opam reinstall $@ ;;
      (r) opam remove $@ ;;
      (R) opam repository $@ ;;
      (d) opam show $@ ;;
      (s) opam search $@ ;;
      (S) opam switch $@ ;;
      (ud) opam update $@ ;;
      (ug) opam ugrade $@ ;;
      (u) opam update; opam upgrade $@ ;;
      (c) opam config $@ ;;

      (mli) ocamlfind ocamlc -package core -thread -i $1 > ${1:r}.mli ;;

      (C) find . \( -name _build -o -name configure -o -name 'setup.*' \
        -o -name Makefile -o -name '*.native' -o -name '*.byte' \) -print0 \
        | xargs -0 -I % rm -rf % ;;

      (O) oasis setup -setup-update dynamic ;;

      (co) map $0 C O ;;

      (*) opam $op $@ ;;
    esac
  fi

}

function kvm-net () {
  case $1 in
    up)
      s vde_switch -tap tap0 -mod 660 -group kvm -daemon
      s ip addr add 10.0.2.1/24 dev tap0
      s ip link set dev tap0 up
      s sysctl -q -w net.ipv4.ip_forward=1
      s iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -j MASQUERADE
      ;;
    down)
      s iptables -t nat -D POSTROUTING -s 10.0.2.0/24 -j MASQUERADE
      s sysctl -q -w net.ipv4.ip_forward=0
      s ip link set dev tap0 down
      s ip link delete tap0
      s pkill -9 vde_switch
      s rm -f /run/vde.ctl/ctl
      ;;
  esac
}

function kvm-boot () {
  s qemu-kvm -cpu host -m 2G -net nic,model=virtio -net vde \
    -soundhw all -vga qxl \
    -spice port=6900,addr=127.0.0.1,disable-ticketing \
    $@
}

function kvm-iso () { kvm-boot -boot once=d -cdrom $1 ${argv[2,-1]} }
function kvm-display () { spicy -p 6900 -h 127.0.0.1 $@ }

function epk () { if [[ -n "$1" ]]; then tar cJf - $1 | gpg -o $1.p -sec -; fi }
function dpk () { gpg -o - -d $1 | tar -xJf -; }

function ug ()  { ugarit ${argv[1]} $HOME/hejmo/ktp/ugarit/ugarit.conf ${argv[2,-1]} }
function ugs () { ug snapshot -v -c -a $@ }
function uge () { ug explore -v $@ }
function ugx () { ug extract -v $@ }
function ugi () { ug import -v $@ }

function bootswatch () {
  rm -f bootstrap.css bootstrap.min.css
  q http://bootswatch.com/$1/bootstrap.css http://www.bootswatch.com/$1/bootstrap.min.css
}

function v180 () {
  local temp_file=out1.mp4
  mencoder -ovc lavc -oac pcm -vf rotate=1 -o $temp_file $1
  mencoder -ovc lavc -oac pcm -vf rotate=1 -o ${1:r}_rotated.mp4 $temp_file
  rm -f $temp_file
}

function lpath () {
  local var=$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$1
  shift

  $@

  export LD_LIBRARY_PATH=$var
}

function lpathnix () {
  lpath $HOME/.nix-profile/lib $@
}

# scz pi google.com
function scz () { sc -d -m -S scz zsh -c "$*" }

# xl $HOME/hejmo/shop/logs pi dns1
function xlv () {
  if (( ! $#1 )); then
    return 1
  else
    local log=$1/$2.$3.log
    shift

    $@ | tee -a $log
  fi

}

# sczxl . pi dns1
function sczxl () { scz xl $@ }
function spzxlph () { sczxl . ph $@ }

function pingp () {
  if ping -c 1 -q $1 &> /dev/null; then
    return 0
  else
    return 1
  fi
}

function fur () {
  wget -crpk -nH -np --tries=0 \
       -e robots=off \
       --cut-dirs=${2:-1} $1
}

function screenp () {
  if screen -ls | grep -q $1; then
    return 0
  else
    return 1
  fi
}

function scs () {
  if ! screenp $1; then
    screen -S $1
  else
    screen -D -R $1
  fi
}

function nrepl_port () {
  local config_file=$HOME/.lein/profiles.clj
  local default_port=9999
  local port=

  if [[ -f $config_file ]]; then
      port="$(sed -n -e 's/^.*:port\ \([0-9]*\).*$/\1/p' $config_file)"
  fi

  echo -n ${port:-$default_port}
}

function mklp () {
  cat >! $HOME/.lein/profiles.clj < \
      <(cat $HOME/.lein/profiles.clj.skel | sed -e "s/_port_/${1:-$(nrepl_port)}/")
}

function mklr () {
  local port=${1:-$(nrepl_port)}

  if ! free_port $port; then
      port=$(inc $port)
  fi

  mklp $port

  if [[ -f $HOME/.lein/profiles.clj ]]; then
      lein live :headless
  fi
}

function mklr! () { cdx ${1:-$PWD} mklr $2 }
function lrs () { scdm lr zsh -c lr }

function hn () {
  nmap -sP 192.168.1.0/24 |
      egrep -o '^N.*for.*' |
      perl -pe 's/(N.*for\ )(.*)/\2/'
}

function meep () {
  local text="Meep!"
  msg $text
  mutex espeak $text
}

function obuild () {
  ocamlbuild -use-ocamlfind -classic-display -syntax camlp4o \
             -pkg core,core_extended,sexplib.syntax,comparelib.syntax,fieldslib.syntax,variantslib.syntax,bin_prot.syntax \
             -tag thread -tag debug -tag annot -tag bin_annot \
             -tag short_paths \
             -cflags \"-w A-4-33-40-41-42-43-34-44\" \
             -cflags -strict-sequence $@
}

function formulo () {
  local name=formulo
  local dir=$(xdg-user-dir DESKTOP)/${name}j
  local out=`date +"%Y%m%d%H%M%S"`.png

  [[ ! -d $dir ]] && mkdir -p $dir

  (
    cd $dir

    if [[ ! -f ${name}.tex ]]; then
        cat > ${name}.tex <<EOF
\ifdefined\formula
\else
    \def\formula{E = m c^2}
\fi
\documentclass[border=2pt]{standalone}
\usepackage{amsmath}
\usepackage{varwidth}
\begin{document}
\begin{varwidth}{\linewidth}
\[ \formula \]
\end{varwidth}
\end{document}

EOF
    fi

    mute pdflatex "\def\formula{$@}\input{${name}.tex}" && \
    mute convert -density 300 ${name}.pdf -quality 100 $out && \

    if [[ $! == 0 ]]; then
      for i (tex pdf log aux) {
        if [[ -f ${name}.$i ]]; then rm -f ${name}.$i; fi
      }

      echo ${dir}/${out}
    fi
  )
}

function merge () {
  local temp=

  if (( ! $#2 )); then
    return 1
  else
    temp=`mktemp`
    cat $1 $2 >! $temp
    mv -f $temp .zhistory.new
  fi
}

function rmlock () {
  case $1 in
    emacs)
      mute rm -i -f $HOME/.emacs.d/desktop.lock
      ;;
    apt)
      mute s rm /var/lib/dpkg/lock
      ;;
    *)
      return 1
      ;;
  esac
}

function ssh-vagrant () {
  local vm=$1
  local addr=$2
  shift 2

  ssh vagrant@$addr \
      -i $HOME/copa/$vm/.vagrant/machines/default/virtualbox/private_key \
      -o UserKnownHostsFile=/dev/null \
      -o StrictHostKeyChecking=no \
      -o PasswordAuthentication=no \
      -o IdentitiesOnly=yes \
      $@
}

function git_ri () {
  if (( $#1 )); then
      git rbi HEAD~$1
  fi
}

function git_rs () {
  if (( $#1 )); then
      git rt --soft HEAD~$1 && \
      git cm "$(git log --format=%B --reverse HEAD..HEAD@{1} | head -1)"
  fi
}

function cr_tv () {
  if ps aux | grep -q '/opt/teamviewer/tv_bin/teamviewerd -d'; then
      teamviewer $@
  else
    s teamviewer --daemon start
    teamviewer $@
  fi
}

function spkr () {
  case $1 in
    off) s modprobe -r pcspkr ;;
    on) s modprobe pcspkr ;;
    *) return 1 ;;
  esac
}

function rasg2e () {
  raown pebbles:users ~/Documents/Skullgirls ~pebbles/Documents
}

function pid () {
  local i
  for i in /proc/<->/stat; do
    [[ "$(< $i)" = *\((${(j:|:)~@})\)* ]] && echo $i:h:t
  done
}

function nman () {
  local item=$1
  local section=${2:-1}

  =man $(baf out-path $item)/share/man/man${section}/${item}.${section}.gz 2> /dev/null
}

function man () {
  env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
      LESS_TERMCAP_md=$(printf "\e[1;31m") \
      LESS_TERMCAP_me=$(printf "\e[0m") \
      LESS_TERMCAP_se=$(printf "\e[0m") \
      LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
      LESS_TERMCAP_ue=$(printf "\e[0m") \
      LESS_TERMCAP_us=$(printf "\e[1;32m") \
      =man $@ 2> /dev/null || nman $@
}

function cp_ico () {
  if [[ -f "ico" ]]; then
      mvb ico
  else
    if [[ -d $HOME/hejmo/bil/gxeneralaj/ikonoj/piktogramoj/"$1" ]]; then
        cp -a $HOME/hejmo/bil/gxeneralaj/ikonoj/piktogramoj/"$1" ico
    else
      error "The requested favicon $1 does not exist."
    fi
  fi
}

function cp_eo_ico () { cp_ico esperanto }

function cxu_enreta () {
  local host=${1:-google.com}
  ping -c 1 "$host" 2> /dev/null | sed -n '/bytes from/s/.*=\(.*\)/\1/p'
}

function cxu_elreta () { if cxu_enreta > /dev/null; then ne; else jes; fi }

function c () {
  local sel=clipboard

  if [[ $# == 1 ]]; then
      if [[ -f "$1" ]]; then
          echo -n "$(fullpath $1)" | xclip -selection $sel
      else
        echo -n "$@" | xclip -selection $sel
      fi
  else
    xclip -selection $sel "$@"
  fi
}

function c@ () { echo $@ | c }
function c% () { xclip -selection clipboard -t $(file -b --mime-type $1) $1 }
function c! () { xclip -selection clipboard $1 }

function caps () {
  if [[ $(tty) == /dev/tty[0-9]* ]]; then
      setleds -caps
  else
    xdotool key Caps_Lock
  fi
}

function tmux () {
  local res_dir=$HOME/.tmux/resurrect

  if [[ $# == 0 ]]; then
      =tmux
  elif [[ "$1" = <-> ]]; then
      =tmux attach -t $@
  else
    case $1 in
      (kill) shift; =tmux kill-session -t $@ ;;
      (lr) shift; ls $@ $res_dir ;;
      (clean) shift; (cd $res_dir; find . -type f ! -name $(basename $(readlink -f last)) -print0 | xargs -0 rm -vf) ;;
      (attack) tmux attach -t $(tmux list-sessions | awk -F : '{print $1}') ;;
      (*) =tmux $@
    esac
  fi
}

function fetch () {
  for i ($@) {
    aria2c "$i" || wget -t 0 -c "$i" || curl -O "$i" || error "Neniu el aria2c, wget, aŭ curl ekzistas.."
  }
}

function nm () {
  local con=

  case $1 in
    (rekonektu|r)
      con=$(nm c show --active | sed 1d | sed -n '/802-11-wireless/p' | sed -e 's/\(.*\)\ *.\{8\}-.\{4\}-.\{4\}-.\{4\}-.\{12\}.*/\1/;s/\ *$//')
      if [[ -n "$con" ]]; then nmcli c down "$con"; nmcli c up "$con"; fi
      ;;
    (nomo|n)
      nmcli d wifi list \
          | sed '/\^*  SSID/d' \
          | grep '^\*' \
          | sed 's/[[:space:]]//' \
          | awk 'BEGIN { FS = "* | Infra" } { print $2 }'
      ;;
    (listigu|l) nmcli d wifi list ;;
    (montru|m) nmcli c show ;;
    (renomu|R)  shift 1; nmcli c mod $1 connection.id $2  ;;
    (*)  nmcli $@  ;;
  esac
}

function uj () {
  local dir=/pub/apoj/jar

  lein uberjar
  find $dir -name 'emem-*SNAPSHOT-standalone.jar' -delete
  fx standalone.jar cp -vf % $dir

  (cdx $dir fx standalone.jar ln -sf % emem.jar)
}

function muziko () {
  local dir=/pub/muzikoj

  ph --playlist <(l "$dir/$1"/**/*.mp3)
}

function kreu-sxablonon () {
  local fonto=$HOME/hejmo/fkd/sxablonoj/

  case $1 in
    Makefile) cp $fonto/Makefile .;;
    *) warning "Ŝablono $1 ne ekzistas" ;;
  esac
}

function idr () {
  NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -L $(nix-env --query --out-path gmp | awk '{print $2}')/lib" idris $@
}

function nas () {
  local file=$1

  nasm -f elf64 -o ${file:r}.o ${file} && ld -o ${file:r} ${file:r}.o
  [[ -f ${file:r}.o ]] && rm -f ${file:r}.o
}

function heroku (){
  docker run -it --rm -u $(id -u):$(id -g) -w "$HOME" \
         -v /etc/passwd:/etc/passwd:ro \
         -v /etc/group:/etc/group:ro \
         -v /etc/localtime:/etc/localtime:ro \
         -v /home:/home \
         -v /tmp:/tmp \
         -v /run/user/$(id -u):/run/user/$(id -u) \
         --name heroku \
         johnnagro/heroku-toolbelt "$@"
}

function cool () {
  cr "coolc $1 && spim ${1:r}.s"
  [[ -f ${1:r}.s ]] && rm -f ${1:r}.s
}

function rmsample! () {
  find . -maxdepth 1 -type f -iname '*sample*' -delete
}

function emake () {
  if [[ -f Makefile ]]; then
      error "Jam ekzistas muntdosiero."
      return 1
  else
    if [[ -f $HOME/hejmo/fkd/sxablonoj/Makefile${1} ]]; then
        =cp -f $HOME/hejmo/fkd/sxablonoj/Makefile${1} Makefile
        shift
    else
      error "Ne ekzistas muntdosiero."
    fi

    =make $@
    rm -f Makefile
  fi
}

function btc () {
  coproc bluetoothctl
  echo -e "power on\nagent on\ndefault-agent\nconnect 04:FE:A1:31:0B:7E\nexit" >&p
  sleep 10
  pacmd set-default-sink bluez_sink.04_FE_A1_31_0B_7E.a2dp_sink
}

function btd () {
  coproc bluetoothctl
  echo -e "disconnect 04:FE:A1:31:0B:7E\nexit" >&p
}

function unzip! () {
  unzip $1
  [[ $? == 0 ]] && rm -f $1
}

function ed () {
  if [[ -n "$(pg 'emacs.*--daemon')" || -n "$(pg 'emacs --smid')" ]]; then
    return 1
  else
    [[ -f "$HOME/.emacs.d/desktop.lock" ]] && rm -f "$HOME/.emacs.d/desktop.lock"
    emacs --no-desktop --daemon
  fi
}

function make% () {
  local args=

  for arg ($@) {
      args=("${(@s,/,)arg}")
      make -C $args[1] $args[2].html
  }
}

function make+ () {
  local args=

  for file in $(git ls-files -m '*.md'); do
    args=("${(@s,/,)file}")
    make% $args[1]/${args[3]:r}
  done
}

function make, () {
  for arg in $@; do
    make ${arg}.html
  done
}

function pdf+ () {
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=${argv[-1]} ${argv[1,-2]}
}

function git () {
  local op=

  if (( ! $#1 )); then
    page "$0"
  else
    op="$1"
    shift

    case "${op}" in
      (i) touch .gitignore; =git init; "$0" a.; "$0" cm "$@" ;;
      (i!) "$0" i "Pravaloriziĝu" ;;

      (s) =git status ;;
      (c) =git clone "$@" ;;
      (h) =git show "$@" ;;

      (cr) =git clean "$@" ;;
      (cr!) "$0" cr -f ;;

      (ci) =git commit "$@" ;;
      (ca) "$0" ci --amend "$@" ;;
      (cm) "$0" ci --message "$@" ;;

      (co) =git checkout "$@" ;;
      (com) "$0" co master ;;
      (cot) "$0" co trunk ;;
      (co!) "$0" co --force "$@" ;;
      (cob) "$0" co -b "$@" ;;

      (ls) =git ls-files "$@" ;;
      (lsm) "$0" ls -m ;;
      (lsd) "$0" ls -d ;;
      (lsdrm) "$0" lsd | xargs =git rm ;;

      (rt) =git reset "$@" ;;
      (rt!) "$0" rt --hard "$@" ;;
      (rv) =git revert "$@" ;;

      (g) =git grep "$@" ;;
      (gi) "$0" g -i "$@" ;;

      (f) =git fetch "$@" ;;
      (fa) "$0" f --all "$@" ;;

      (rm) =git rm "$@" ;;
      (rmr) "$0" rm -r "$@" ;;
      (rm!) "$0" rm -rf "$@" ;;

      (rb) =git rebase "$@" ;;
      (rbi) "$0" rb --interactive "$@" ;;
      (rbc) "$0" rb --continue "$@" ;;
      (rbs) "$0" rb --skip "$@" ;;
      (rba) "$0" rb --abort "$@" ;;
      (rbs) "$0" rb --skip "$@" ;;
      (rbi!) "$0" rbi --root "$@" ;;

      (ri) "$0" rbi HEAD~"$1" ;;
      (rs) "$0" rt --soft HEAD~"$1" && "$0" cm "$(git log --format=%B --reverse HEAD..HEAD@{1} | head -1)" ;;

      (ph) =git push "$@" ;;
      (phu) "$0" ph -u "$@" ;;
      (ph!) "$0" ph --force "$@" ;;
      (pho) "$0" phu origin "$@" ;;
      (phom) "$0" pho master "$@" ;;

      (oo) "$0" ph origin "$(git brh)" ;;
      (oo!) "$0" ph! origin "$(git brh)" ;;

      (pl) =git pull "$@" ;;
      (pl!) "$0" pl --force "$@" ;;
      (plr) "$0" pl --rebase "$@" ;;
      (plro) "$0" plr origin "$@" ;;
      (plru) "$0" plr upstream "$@" ;;
      (plrom) "$0" plro master ;;
      (plrum) "$0" plru master ;;
      (plrot) "$0" plro trunk ;;
      (plrut) "$0" plru trunk ;;

      (a) =git add "$@" ;;
      (au) "$0" a -u ;;
      (a.) "$0" a . ;;

      (aum) "$0" au; "$0" cm "$@" ;;
      (aux) "$0" aum "x" ;;
      (a.m) "$0" a.; "$0" cm "$@" ;;
      (a.x) "$0" a.m "x" ;;

      (auxx) "$0" aux; "$0" rs 2 ;;
      (au.x) "$0" a.x; "$0" rs 2 ;;
      (auxx!) "$0" auxx; "$0" oo! ;;

      (l) =git log "$@" ;;
      (l1) "$0" l -1 --pretty=%B ;;
      (lo) "$0" l --oneline ;;
      (lp) "$0" l --patch ;;
      (lp1) "$0" lp -1 ;;
      (lpw) "$0" lp --word-diff=color ;;

      (br) =git branch "$@" ;;
      (bra) "$0" br -a ;;
      (brm) "$0" br -m "$@" ;;
      (brmh) "$0" brm "$(git brh)" ;;
      (brd) "$0" br -d "$@" ;;
      (brD) "$0" br -D "$@" ;;
      (brh) =git rev-parse --abbrev-ref HEAD ;;

      (d) =git diff "$@" ;;
      (dh) "$0" d HEAD ;;
      (dhw) "$0" d --word-diff=color ;;

      (re) =git remote "$@" ;;
      (rea) "$0" re add "$@" ;;
      (reao) "$0" rea origin "$@" ;;
      (reau) "$0" rea upstream "$@" ;;
      (rer) "$0" re remove "$@" ;;
      (ren) "$0" re rename "$@" ;;
      (rero) "$0" rer origin "$@" ;;
      (reru) "$0" rer upstream "$@" ;;
      (res) "$0" re show "$@" ;;
      (reso) "$0" res origin ;;
      (resu) "$0" res upstream ;;

      (rl) =git rev-list "$@" ;;
      (rla) "$0" rl --all "$@" ;;
      (rl0) "$0" rl --max-parents=0 HEAD ;;

      (bl) =git blame "$@" ;;
      (mv) =git mv "$@" ;;
      (me) =git merge "$@" ;;
      (ta) =git tag "$@" ;;

      (cp) =git cherry-pick "$@" ;;
      (cpc) "$0" cp --continue "$@" ;;
      (cpa) "$0" cp --abort "$@" ;;

      (fb) =git filter-branch "$@" ;;
      (fbm) "$0" -f --msg-filter "$@" ;;
      (fbm.) "$0" fbm 'sed "s/\.$//"' "$(git brh)" ;;

      (rp) =git rev-parse "$@" ;;
      (rph) "$0" rp HEAD ;;

      (st) =git stash "$@" ;;
      (stp) "$0" st pop "$@" ;;

      (subt) =git subtree "$@" ;;
      (subta) "$0" subt add "$@" ;;
      (subtph) "$0" subt push "$@" ;;
      (subtpl) "$0" subt pull "$@" ;;

      (subm) =git submodule "$@" ;;
      (subms) "$0" subm status "$@" ;;
      (submy) "$0" subm summary "$@" ;;
      (submu) "$0" subm update "$@" ;;
      (subma) "$0" subm add "$@" ;;
      (submi) "$0" subm init "$@" ;;

      (*) =git "${op}" "$@" ;;
    esac
  fi
}


#---------------------------------------------------------------------------------------------------
# Malgrandajoj 1-a
#---------------------------------------------------------------------------------------------------

function sayf () { for i ("$@") { while read x; do say "$x"; done < $i } }
function ffmp3 () { ffmpeg -y -i "$1" "${1:r}.mp3" }
function ffmp4 () { ffmpeg -strict -2 -i "$1" "${1:r}.mp4" }
function digest () { md5sum <(print "$@") | awk '{print $1}' }
function clhs () { for i ("$@") { emacsclient -nw -n -e "(hyperspec-lookup \"$i\")" } }
function wmclass () { xprop | grep "^WM_CLASS" | sed -e 's/^.*\"\(.*\)\".*/\1/' }
function pstty () { ps -t "$1" | sed 1d | awk '{print $1}' }
function lsofg () { s lsof | grep "$@" }
function tex2png () { for i ("$@") { tex2im -o ${i:r}.png -f png "$i" } }
function dpi () { s dpkg -i $1 }
function dps () { dpkg -S =$1 }
function dpl () { dpkg -L $1 }
function cap () { s tcpdump -s 65535 -i "$argv[1]" -w "$argv[2]" "$argv[3,-1]"}
function mklast () { if [[ -f $1 ]]; then echo $1 >>! in.last; fi }
function ping1 () { ping -c 1 "$@" }
function pdf2txt () { less "$@" | cat }
function statmod () { stat --printf "%Y\n" "$1" }
function mk2 () { eval "function 2${1} () { repeat 2 { $1 \"\$1\"} }" }; map mk2 pdflatex xelatex
function urlencode () { python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])" "$@" }
function urldecode () { python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])" "$@" }
function checkip () { lump checkip.dyndns.org | awk -F ': ' '{print $2}' }
function gitignore () { curl https://www.gitignore.io/api/$1 }
function transfer () { curl --upload-file $1 https://transfer.sh/$(basename $1) }
function yv () { y $(curl -s $1 /e -io '/watch\?v=.{11}' /u /d -e 's|^|youtube.com|') }
function xw () { =wine $HOME/.wine/drive_c/$@ }
function inc () { echo $(($1 + 1)) }
function res () { pkill $1; mutex $1 }
function calc () { echo $@ | bc }
function hnn () { mutex msg "$(hn)" }
function twitch () { livestreamer $1 ${2:-medium} }
function jj () { java -jar /pub/apoj/jar/$1.jar ${argv[2,-1]} }
function mr () { find $1 -type f | sort -r | head -1 }
function rot13 () { tr 'A-Za-z' 'N-ZA-Mn-za-m' }
function ublocks () { sort $1 | sed -e '/^!/d' | uniq }
function trim () { sed -i -e "$1,\$d" $2 }
function taf () { find $1 -maxdepth 1 -type d | egrep "(${2})\$" | tar -cf - -T - | tar -C $3 -xvf - }
function tats () { find $1 -maxdepth 1 -type d | egrep "(${2})\$" | s tar -cvJf $3 -T - }
function tn () { tac | sed -n ${1}p }
function bhelp () { bash -c "help $@" | less }
function zr () { xzcat "$1" >! ~/.zhistory }
function rml () { sed -i -e ${1}d $2 }
function rms () { rml $1 $HOME/.ssh/authorized_keys }
function mine () { s chown -R $USER $@ }
function wh () { watch -n "$@" }
function json2yaml () { ruby -ryaml -rjson -e 'puts YAML.dump(JSON.parse(STDIN.read))' < $1 > $2 }
function yaml2json () { ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))' < $1 > $2 }
function er () { emacsclient -nw --eval "(linum-mode -1)" --eval "(view-file \"$1\")" }
function gistc () { gist $@ | c }
function lym () { emem -Rwo - $@ | ly --stdin }
function wdi () { wdiff -n $@ | colordiff -u }
function e! () { e $(mktemp --dry-run -p ~/l) }
function mhtml! () { =emem -Fis -f -o ${2:-${1:r}.html} ${1} }
function mhtml@ () { =emem -Fis -o ${2:-${1:r}.html} ${1} }
function mpdf! () { mhtml! $1 - | wkhtmltopdf -s Letter -q - ${2:-${1:r}.pdf} }
function mpdf@ () { mhtml@ $1 - | wkhtmltopdf -s Letter -q - ${2:-${1:r}.pdf} }
function mhtml () { mhtml@ $@ }
function mpdf () { mpdf@ $@ }
function mu@ () { mu ${1:r}.pdf }
function lpr@ () { lpr ${1:r}.pdf }
function sbcl! () { d $HOME/hejmo/dat/sbcl gplrom }
function gif () { ffmpeg -i $1 -ss $2 -to $3 -r 30 -f image2pipe -vcodec ppm - | convert -loop 0 - $4 }
function bprofile () { PATH=$HOME/.baf/profiles/${1}/bin ${argv[2,-1]} }
function bp () { bprofile $1 $1 ${argv[2,-1]}}
function h! () { rmap $1 h 'baf h' }
function tex! () { for file (${@:-*.tex}) { xelatex $file && evince ${file:r}.pdf } }
function tex@ () { for file (${@:-*.tex}) xelatex $file }


#---------------------------------------------------------------------------------------------------
# Malgrandaĵoj 2-a
#---------------------------------------------------------------------------------------------------

funs=(
  ## sudo
  s "sudo"
  sue "s -Hiu"
  suc "s sh -c"
  root "sue root"

  ## ssh
  @ "ssh"

  ## rsync
  rz@ "raz -e 'ssh -T -x StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o Compression=no'"

  ## sistemprogramoj
  cryptsetup! "s =cryptsetup"
  losetup! "s =losetup"
  service! "s =service"
  journalctl! "s journalctl"
  pm-suspend! "s =pm-suspend"
  pm-hibernate! "s =pm-hibernate"
  blkid! "s =blkid"
  ipsec! "s =ipsec"
  hd "hexdump -C"
  rm+ "par 'rm! {}' :::"
  tup "watch -n 1 sudo netstat -tup"
  sen "watch -n 1 sudo sensors"
  tcpu 's =ps -eo pcpu,pid,user,args | sort -k 1 -r | head'
  tmem 's =ps -eo pmem,pid,user,args | sort -k 1 -r | head'

  ## aplikaĵoj
  docker! "docker run -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix"
  diff "=diff -Naur"
  ub "x s unetbootin isofile=\"\$1\""
  xl "x xscreensaver-command -lock"
  say "mute espeak -a 300 -s 140 -p 0"
  iu "imgurbash2"
  ly "=lynx -accept_all_cookies"
  lump "ly -dump"
  lsrc "ly -source"
  m3u 'mkm3u **/*.$1 >! in.m3u'
  dime "xdpyinfo | grep dimensions | awk '{print \$2}'"
  am "=alsamixer"
  tea "tee -a"
  pl "za /pub/dok/provlegado/proofreading.pdf"
  be "b \$HOME/hejmo/bil/ekrankopioj"
  xkd "setxkbmap dvorak"
  xku "setxkbmap us"
  fc! "fc-cache -fv"
  dm! "restart display-manager"
  xr! "xrdb ~/.Xresources"
  top! "s =top"
  htop! "s =htop"
  pstree! "s =pstree"
  pelo@ "pelo 1.1.1.1 | tee -a $HOME/hejmo/dat/pelo/pelo.log"
  mtr! "s =mtr 8.8.8.8"
  iftop! "s =iftop -i wlp3s0"
  nm! "nm r"
  rmnix! "echo rm -rf /etc/nix /nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels $HOME/.nix-profile $HOME/.nix-defexpr $HOME/.nix-channels"
  touchpad! "=touchpad disable"
  trackpoint! "=trackpoint 'TPPS/2 IBM TrackPoint'"
  spicy! "x spicy -h localhost -p 9999"
  zip! "zip -r"
  mi "mediainfo"
  vu "v $HOME/hejmo/dok/utf-confusables/utf-confusables.txt"
  vc "v $HOME/hejmo/ktp/xcompose/sistemo.xcompose"
  iotop! "sudo =iotop -oaP"
  xb! "res xbindkeys"
  dp! "res devilspie2"
  df "=di"

  ## reto
  gateway "netstat -rn | grep UG | awk '{print \$2}'"
  trl "trickle -s"
  nmap! "s =nmap"
  nmap@ "nmap -T4 -A -v -Pn -p 1-65535"
  nmap+ "nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script 'default or (discovery and safe)'"
  traceroute "s =traceroute"
  mtr! "s =mtr"
  iftop! "s =iftop"
  netstat! "s =netstat"
  vncd "x =x11vnc -display :0 -shared -forever -ncache 10 -rfbauth \$HOME/.vnc/passwd"
  progress! "s =progress -m"

  ## rubeno
  drails-nix "d ~/hejmo/fkd/nikso/rails-nix"
  rails-nix! "+ drails-nix baf shell"
  rails! "rails-nix!"
  rails-nix+ "D=\$PWD drails-nix baf impure-shell"

  ## xmonad
  dxmonad "d ~/.xmonad"

  ## rakido
  dracket 'cd $(baf out-path racket)'
  pkg "raco pkg"
  frog "raco frog"
  livefrog "raco livefrog"

  ## kloĵuro
  clo "lein deploy clojars"
  emem "jj emem"
  emem! "emem -Fis"
  emem@ "emem -Ffis"

  ## haskelo
  ghci! "stack ghci"

  ## lispo
  sbcl "rl =sbcl"
  ccl "rl =ccl"
  lisp "rl =lisp"
  ecl "rl =ecl"
  clisp "rl =clisp"
  mkcl "rl =mkcl"
  abcl "rl =abcl"

  ## skimo
  scheme "rl =scheme"
  racket "rl =racket"
  guile "rl =guile"
  scsh "rl =scsh"
  scheme48 "rl =scheme48"
  chibi-scheme "rl =chibi-scheme"
  gxi "rl =gxi"
  csi "rl =csi"
  bigloo "rl =bigloo"
  tinyscheme "rl =tinyscheme"

  ## scripts
  dscripts "dfkdlispo d scripts"
  scripts! "+ dscripts make install"

  ## baf
  dbaf "dfkdlispo d baf"
  baf "LANG=C =baf"
  baf! "+ dbaf make"

  ## apt
  apt "sudo =apt"

  ## stumpwm
  dstumpo "d $HOME/hejmo/fkd/lispo/stumpo"
  stumpo! "+ dstumpo make"
  dmof "dfkdlispo d mof"
  mof! "+ dmof make"

  ## nix
  dnixos "d /etc/nixos"
  enixos "se /etc/nixos/configuration.nix"
  nixos! "sudo nixos-rebuild switch"

  ## ssh
  sagent "ssh-agent \$SHELL"
  sadd "ssh-add"

  ## postgresql
  psql! "sue postgres psql"

  ## dosierujoj
  d~ "d ~"
  dh "d $HOME/hejmo"
  dhejmo "d $HOME/hejmo"
  dp "d /pub"
  dpub "d /pub"
  de "d $HOME/Elsxutajxoj"
  dl "d $HOME/Labortablo"
  dy "de y"
  dq "de q"

  ## rlwrap
  telnet "rl =telnet"
  mongo "rl =mongo"

  ## skim
  sk "=sk"
  sk@ "sk --regex"
  skt "sk-tmux"

  ## kapo
  kapo "$HOME/hejmo/fkd/sxelo/kapo/kapo"

  ## conda
  conda-shell "conda-shell-4.3.31"
); def_funs
