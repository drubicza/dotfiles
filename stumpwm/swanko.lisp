;;;; swanko.lisp

(in-package #:stumpwm)


;;;-------------------------------------------------------------------------------------------------
;;; Swanko
;;;-------------------------------------------------------------------------------------------------

(defvar *swanka-pordo* 4004
  "La defaŭlta pordo por swanka uzado")

(defun swankon-certigu ()
  "La swankon ŝarĝu se gxi ne funkcias"
  (let* ((prefikso "lsof -i :")
         (pordo *swanka-pordo*)
         (komando (concatenate 'string prefikso (write-to-string pordo))))
    (when (zerop (length (ignore-errors (uiop:run-program komando :output :string))))
      (swank-loader:init)
      (swank:create-server :port *swanka-pordo*
                           :style swank:*communication-style*
                           :dont-close t))))

(defun swankon-sxargxu ()
  "La plej supra nivela funkcio"
  (swankon-certigu))


;;;-------------------------------------------------------------------------------------------------
;;; Registrado
;;;-------------------------------------------------------------------------------------------------

(komencan-krocxilon-registru 'swankon-sxargxu)
