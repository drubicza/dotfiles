# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Sistemspecifaj variabloj
#---------------------------------------------------------------------------------------------------

linux_pc_test && {
  WWW_BROWSER=o
  IMAGE_BROWSER=b
  IMAGE_VIEWER=b
  FIND=find
  GREP=rg
  XARGS=xargs
}

darwin_test && {
  WWW_BROWSER=firefox
  IMAGE_BROWSER=geeqie
  IMAGE_VIEWER=gpicview
  FIND=find
  GREP=egrep
  XARGS=xargs
}

freebsd_test && {
  WWW_BROWSER=firefox
  IMAGE_BROWSER=geeqie
  IMAGE_VIEWER=gpicview
  FIND=find
  GREP=egrep
  XARGS=xargs
}
