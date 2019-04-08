;;;; transpasoj.lisp

(in-package #:stumpwm)


;;;-------------------------------------------------------------------------------------------------
;;; Funkcioj
;;;-------------------------------------------------------------------------------------------------

(defcommand loadrc () ()
  "Reload the @file{~/.stumpwmrc} file."
  (handler-case
      (with-restarts-menu (load-rc-file nil))
    (error (c)
      (message "^1*^BError loading rc file: ^n~A" c))
    (:no-error (&rest args)
      (declare (ignore args))
      (message "@"))))
