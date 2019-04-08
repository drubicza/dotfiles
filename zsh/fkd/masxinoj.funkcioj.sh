# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Sistemspecifaj funkcioj
#---------------------------------------------------------------------------------------------------

function os_test () {
  if [[ $OS == $1 ]]; then
    return 0
  else
    return 1
  fi
}

function arch_test () {
  if [[ $ARCH == $1 ]]; then
    return 0
  else
    return 1
  fi
}

function linux_test () {
  if os_test linux; then return 0; else return 1; fi
}

function linux_x86_test () {
  if os_test linux && (arch_test i686 || arch_test i386); then
    return 0
  else
    return 1
  fi
}

function linux_nixos_test () {
  if linux_test; then
    if [[ -f /etc/nixos/configuration.nix  ]]; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

function linux_x86_64_test () {
  if os_test linux && (arch_test x86_64); then
    return 0
  else
    return 1
  fi
}

function linux_arm_kali_test () {
  if os_test linux && arch_test armv7l; then
    if [[ "$(uname -n)" == "phoebe" ]]; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

function linux_pc_test () {
  if linux_x86_test || linux_x86_64_test || linux_arm_kali_test; then
    return 0
  else
    return 1
  fi
}

function freebsd_test () {
  if os_test freebsd; then
    return 0
  else
    return 1
  fi
}

function darwin_test () {
  if os_test darwin; then
    return 0
  else
    return 1
  fi
}

function bsd_test () {
  if freebsd_test || darwin_test; then
    return 0
  else
    return 1
  fi
}

function unix_test () {
  if os_test linux || os_test bsd; then
    return 0
  else
    return 1
  fi
}

freebsd_test && {
  function search {
    local type="$1"
    shift
    for i ($@) make -C /usr/ports search \
          ${type}="${i}" display=name,path,info
  }

  function searchname { search name $@ }
  function searchkey { search key $@ }
}



function randomize_file () {
  sort -R $i
}


function print_sum () {
  local check_sum=

  for i ("$@") {
      if freebsd_test; then
        check_sum=$(md5 -r "$i" | awk '{print $1}')
      else
        check_sum=$($(hs tthsum sha256sum md5sum) "$i" | awk '{print $1}')
      fi

      print $check_sum[0,10]
    }
}

function ping () {
  =ping $@
}


#---------------------------------------------------------------------------------------------------
# Diversaĵoj
#---------------------------------------------------------------------------------------------------

linux_test && {
  export LSOPTS="-A -F --color"
}

freebsd_test || darwin_test && {
    export LSOPTS="-A -F -G"
  }


#---------------------------------------------------------------------------------------------------
# Malgrandaĵoj
#---------------------------------------------------------------------------------------------------

linux_pc_test && {
  if hh exa; then
    function l () { exa --all --time modified --sort newest $@ }
    function ll () { l --long --header --git --time-style long-iso $@ }
    function la () { exa --all $@ }
    function lk () { la --long --header --git --time-style long-iso $@ }
  else
    function l () { ls -tr -A -F --color $@ }
    function ll () { l -l $@ }
    function la () { ls -A -F --color $@ }
    function lk () { la -l $@ }
  fi
}

freebsd_test && {
  funs=(
    l "ls -tr $LSOPTS"
    la "ls $LSOPTS"
    pm "s portmaster -v -P -g -G --no-term-title"
  ); def_funs
}

darwin_test && {
  funs=(
    l "ls -tr $LSOPTS"
    la "ls $LSOPTS"
  ); def_funs
}

linux_test && {
  if uname -a | grep -iq synology_; then
    function sys () { sudo initctl $@ }
  else
    function sys () { sudo systemctl $@ }
    function list () { sys list-units $@ }
  fi

  function stop () { sys stop $@ }
  function start () { sys start $@ }
  function restart () { sys restart $@ }
  function status () { sys status $@ }
  function scat () { sys cat $@ }
  function logs () { s journalctl -fu $@ }
}

darwin_test && {
  function sys () { sudo launchctl $@ }
  function stop () { sys stop $@ }
  function start () { sys start $@ }
  function unload () { sys unload $@ }
  function load () { sys load $@ }
  function restart () { rmap $1 stop start }
}

if linux_nixos_test; then
  function pg () {
    pgrep --list-full --list-name --full --ignore-case $@
  }
else
  function pg () {
    pgrep --list-full --list-name --full $@
  }
fi
