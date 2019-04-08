# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Malgrandaĵoj 1-a
#---------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------
# Malgrandaĵoj 2-a
#---------------------------------------------------------------------------------------------------

funs=(
  dusb "d /mnt/usb"
  mtp  "d /mnt/mtp"
  diso "d /mnt/iso"
  db0  "d /mnt/b0"
  dnfs  "d /mnt/nfs"
  dssh  "d /mnt/ssh"
); def_funs


#---------------------------------------------------------------------------------------------------
# Funkcioj
#---------------------------------------------------------------------------------------------------

function mountp () {
  if mount | egrep -q "^$1"; then
    return 0
  else
    return 1
  fi
}

function muser () {
  sudo mount -o uid=$(id -u) $@
}

function mvfat () {
  muser -t vfat $@
}

function m_usb () {
  local index=${2:-0}
  local id=usb${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -e $1 ]]; then
      return 1
  else
    muser -t vfat $1 $mnt \
    || sudo lowntfs-3g -o uid=$(id -u) $1 $mnt \
    || mount -t hfsplus -o force,rw $1 $mnt \
    || mount -t exfat $1 $mnt \
    || mount $1 $mnt
  fi
}

function u_usb () {
  local index=${1:-0}
  local id=usb${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function m_eusb () {
  local index=${2:-0}
  local id=eusb${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -e $1 ]]; then
      return 1
  else
    me $1 $id $mnt
  fi
}

function u_eusb () {
  local index=${2:-0}
  local id=eusb${index}
  local mnt=/mnt/$id

  ue $id
}

function m_iso () {
  local index=${2:-0}
  local id=iso${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -f $1 ]]; then
      return 1
  else
    sudo mount -o loop,ro $@ $mnt
  fi
}

function u_iso () {
  local index=${1:-0}
  local id=iso${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function loop_device () {
  index=$(sudo losetup -a | sed -n -e 's/\(\/dev\/loop\)\(.\):.*/\2/;$p')

  if [[ -n "$index" ]]; then
      echo /dev/loop$((index+1))
  else
    echo /dev/loop0
  fi
}

function m_elo () {
  local index=${2:-0}
  local id=elo${index}
  local mnt=/mnt/$id
  local loop=$(loop_device)

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -f $1 ]]; then
      return 1
  else
    sudo losetup $loop $1
    me $loop $id $mnt
  fi
}

function u_elo () {
  local index=${1:-0}
  local id=elo${index}
  local mnt=/mnt/$id
  local loop=/dev/loop${index}

  ue $id
  sudo losetup -d $loop
}

function m_arc () {
  local index=${2:-0}
  local id=arc${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -f $1 ]]; then
      return 1
  else
    archivemount $@ $mnt
  fi
}

function u_arc () {
  local index=${1:-0}
  local id=arc${index}
  local mnt=/mnt/$id

  umount $mnt
}

function m_smb () {
  local host=${1}

  if [[ ! -d /mnt/smb/${1}/c ]]; then
    sudo mkdir -p /mnt/smb/${1}/c
  fi
  sudo mount -t cifs -o user=$USER,uid=$USER //${1}/c /mnt/smb/${1}/c
}

function u_smb () {
  sudo umount /mnt/smb/${1}/c
}

function m_ssh () {
  local dir=/mnt/ssh

  sshfs -C $@
}

function u_ssh () {
  local dir=/mnt/ssh

  umount -fl $dir/$1
}

function me () {
  local dev=$1
  local name=$2
  local mnt=$3

  if (( ! $#3 )); then
      return 1
  else
    if ! mountp /dev/mapper/${name}; then
        if [[ ! -d ${mnt} ]]; then sudo mkdir -p ${mnt}; fi
        if [[ -e ${dev} ]]; then
            sudo cryptsetup luksOpen ${dev} ${name} && \
            sudo mount /dev/mapper/${name} ${mnt}
        else
          return 1
        fi
    else
      return 1
    fi
  fi
}

function ue () {
  local name=$1

  if mountp /dev/mapper/${name}; then
      sudo umount /dev/mapper/${name}
      sudo cryptsetup luksClose ${name}
  fi
}

function m_luks () {
  if mount | egrep -q "^/dev/mapper/${1}"; then
      return 0
  else
    me /dev/disk/by-uuid/$2 $1 /$1
  fi
}

function m_nfs () {
  local index=${2:-0}
  local id=nfs${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if ! mountp $1; then
    sudo mount.nfs -o nolock $1 $mnt
  else
    return 0
  fi

}

function u_nfs () {
  local index=${1:-0}
  local id=nfs${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}


function m_mtp () {
  local index=${2:-0}
  local id=mtp${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  mtp-detect
  sleep 10
  jmtpfs $mnt
}

function u_mtp () {
  local index=${1:-0}
  local id=mtp${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function m_drive () {
  local index=${1:-0}
  local id=drive${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  google-drive-ocamlfuse $mnt
}

function u_drive () {
  local index=${1:-0}
  local id=drive${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function m_s3 () {
  local index=${2:-0}
  local id=s3${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  s3fs $1 $mnt
}

function u_s3 () {
  local index=${1:-0}
  local id=s3${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function m () {
  local op=

  if (( ! $# )); then
      =mount
  else
    if [[ -e "$1" ]]; then
        sudo =mount "$@"
    else
      op=$1
      shift

      case $op in
        b0) m_luks b0 9563ccc5-fb1c-4631-8ccc-ac4e53c1501b ;;
        elo) m_elo $HOME/hejmo/dat/elo/kesto.elo ;;
        usb) m_usb $@ ;;
        eusb) m_eusb $@ ;;
        iso) m_iso $@ ;;
        nfs) m_nfs $@ ;;
        mtp) m_mtp $@ ;;
        ssh) m_ssh $@ ;;
        drive) m_drive $@ ;;
        s3) m_s3 $@ ;;
      esac
    fi
  fi
}

function u () {
  local op=

  if (( ! $# )); then
      page $0
  else
    if [[ -e "$1" ]]; then
        sudo =umount "$@"
    else
      op=$1
      shift

      case $op in
        b0) ue b0 ;;
        elo) u_elo ${2:-0} ;;
        usb) u_usb ${2:-0} ;;
        usbe) u_usbe ${2:-0} ;;
        iso) u_iso ;;
        nfs) u_nfs ${2:-0} ;;
        mtp) u_mtp ${2:-0} ;;
        drive) u_drive ;;
        s3) u_s3 ;;
      esac
    fi
  fi
}
