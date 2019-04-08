;;;; gxeneralaj.lisp

(in-package #:stumpwm)


;;;-------------------------------------------------------------------------------------------------
;;; Ĝeneralaj
;;;-------------------------------------------------------------------------------------------------

(defvar *komenca-krocxilo* nil
  "Funkcioj por la StumpWM-an startigon kuri.")

(defun komencan-krocxilon-registru (krocxilo)
  "La krocxilan funkcion registru por kuri kiam StumpWM komenciĝas."
  (uiop:register-hook-function '*komenca-krocxilo* krocxilo))

(defun pravalorizu ()
  "La krocxilan funkcion kuru kiam StumpWM komenciĝas."
  (uiop:call-functions *komenca-krocxilo*))

(defun grupa-krocxilo (grupo-1a grupo-2a)
  "La krocxilo esti vokota dum grupa ŝaltado."
  (declare (ignore grupo-1a grupo-2a))
  (message "~A" (group-number (current-group))))

(defun gxeneralajn-sxargxu ()
  "La plej supra nivela funkcio."
  (clear-window-placement-rules)
  (add-hook *focus-group-hook* 'grupa-krocxilo)

  (setf *shell-program* "/bin/sh"
        *mouse-focus-policy* :click
        *window-border-style* :thin
        *maxsize-border-width* 1
        *transient-border-width* 1
        *normal-border-width* 1
        *input-window-gravity* :bottom-right
        *message-window-gravity* :bottom-right)

  (set-focus-color "#696969")
  (set-unfocus-color "#000000")
  (set-font "-*-speedy-*-*-*-*-12-*-*-*-*-*-*-*")

  (setf *window-format* "%m%n%s%c")
  (setf *screen-mode-line-format* (list "[^B%n^b] %W^>%d"))
  (setf *time-modeline-string* "%a %b %e %k:%M")

  (enable-mode-line (current-screen) (current-head) t))


;;;-------------------------------------------------------------------------------------------------
;;; Registrado
;;;-------------------------------------------------------------------------------------------------

(komencan-krocxilon-registru 'gxeneralajn-sxargxu)
