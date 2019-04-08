;;;; klavoj.lisp

(in-package #:stumpwm)


;;;-------------------------------------------------------------------------------------------------
;;; Ĝeneralaj
;;;-------------------------------------------------------------------------------------------------

(set-prefix-key (kbd "C-;"))            ; Jes, mi konsentas. :)
(define-key *root-map* (kbd "h") '*help-map*)


;;;-------------------------------------------------------------------------------------------------
;;; Supraj mapklavoj
;;;-------------------------------------------------------------------------------------------------

(defparameter *supraj-mapklavoj*
  '(;; fenestroj
    ("M-space"    . "only")
    ("C-Escape"   . "delete")
    ("C-S-Escape" . "kill-window")
    ("M-Tab"      . "fnext")

    ("C-S-Up"    . "exchange-direction up")
    ("C-S-Down"  . "exchange-direction down")
    ("C-S-Left"  . "exchange-direction left")
    ("C-S-Right" . "exchange-direction right")

    ("M-S-Up"    . "move-window up")
    ("M-S-Down"  . "move-window down")
    ("M-S-Left"  . "move-window left")
    ("M-S-Right" . "move-window right")

    ;; grupoj
    ("M-Next"     . "gprev")
    ("M-Prior"    . "gnext")

    ("C-M-Prior" . "gprev-with-window")
    ("C-M-Next"  . "gnext-with-window")

    ("C-1" . "gselect 1")
    ("C-2" . "gselect 2")
    ("C-3" . "gselect 3")
    ("C-4" . "gselect 4")
    ("C-5" . "gselect 5")
    ("C-6" . "gselect 6")
    ("C-7" . "gselect 7")
    ("C-8" . "gselect 8")
    ("C-9" . "gselect 9")
    ("C-0" . "gselect 0")

    ("C-M-1" . "gmove 1")
    ("C-M-2" . "gmove 2")
    ("C-M-3" . "gmove 3")
    ("C-M-4" . "gmove 4")
    ("C-M-5" . "gmove 5")
    ("C-M-6" . "gmove 6")
    ("C-M-7" . "gmove 7")
    ("C-M-8" . "gmove 8")
    ("C-M-9" . "gmove 9")
    ("C-M-0" . "gmove 0")

    ;; desegna tabuleto
    ("XF86Go"                 . "je-intuos-ring-sxargxu")
    ("XF86Back"               . "zomon-malpliigu")
    ("XF86Forward"            . "zomon-pliigu")
    ("XF86AudioLowerVolume"   . "sonfortecon-malpliigu")
    ("XF86AudioRaiseVolume"   . "sonfortecon-pliigu")

    ;; la “plurmediaj” klavoj
    ("XF86AudioMute"          . "sonfortecon-mutigu")
    ("S-XF86AudioMute"        . "sonfortecon-kvindekigu")

    ("S-XF86AudioLowerVolume" . "sonfortecon-minimumigu")
    ("S-XF86AudioRaiseVolume" . "sonfortecon-maksimumigu")

    ("XF86MonBrightnessDown"  . "ekranbrilecon-minimumigu")
    ("XF86MonBrightnessUp"    . "ekranbrilecon-maksimumigu")

    ("S-XF86MonBrightnessDown" . "ekranbrilecon-malpliigu")
    ("S-XF86MonBrightnessUp"   . "ekranbrilecon-pliigu"))
  "Asocia listo de klavaj:komandaj duoj por *TOP-MAP*.")


;;;-------------------------------------------------------------------------------------------------
;;; Radikaj mapklavoj
;;;-------------------------------------------------------------------------------------------------

(defparameter *radikaj-mapklavoj*
  '(("C-;" . "send-escape")
    ("x"   . "je-x-sxargxu")
    ("."   . "loadrc")
    (";"   . "komando")
    ("!"   . "run-shell-command")

    ("t"   . "musmontrilon-stumpigu")
    ("z"   . "banish")
    ("c"   . "musmontrilon-centrigu")

    ("e"   . "partan-ekrankopion-tenu")
    ("E"   . "plenan-ekrankopion-tenu")
    ("a"   . "staton-montru")
    ("z"   . "datumon-montru")
    ("f"   . "fullscreen")
    ("w"   . "windowlist")
    ("s"   . "select-window-by-name")
    ("%"   . "hsplit")
    ("\""  . "vsplit")

    ("Return"   . "pull-hidden-next")
    ("C-Return" . "pull-hidden-next")
    ("SPC"      . "gother")
    ("C-SPC"    . "gother"))
  "Asocia listo de klavaj:komandaj duoj por *ROOT-MAP*.")

(defparameter *ne-radikaj-mapklavoj*
  `("C-e"
    ;; "c"
    "C-c" "C-q"
    "M-Left" "M-Right"
    "F1" "F2" "F3" "F4" "F5"
    "F6"
    "F7" "F8"
    "o"
    "F9" "F10"
    "C-0" "C-1" "C-2" "C-3" "C-4"
    "C-5" "C-6" "C-7" "C-8" "C-9")
  "Asocia listo de klavoj por malmapado.")


;;;-------------------------------------------------------------------------------------------------
;;; Funkcioj
;;;-------------------------------------------------------------------------------------------------

(defun klavojn-sxargxu ()
  "La plej supra nivelo funkcio."
  (klavojn-mapu *top-map* *supraj-mapklavoj*)
  (klavojn-mapu *root-map* *radikaj-mapklavoj*)
  (klavojn-malmapu *root-map* *ne-radikaj-mapklavoj*))


;;;-------------------------------------------------------------------------------------------------
;;; Registrado
;;;-------------------------------------------------------------------------------------------------

(komencan-krocxilon-registru 'klavojn-sxargxu)
