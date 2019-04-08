;;;; fenestroj.lisp

(in-package #:stumpwm)


;;;-------------------------------------------------------------------------------------------------
;;; Fenestroj
;;;-------------------------------------------------------------------------------------------------

(defparameter *fenestraj-klasaj-nombroj*
  '(("Terminator" . 0)
    ("Firefox" . 2))
  "Asocia listo de fenestraj kursoj esti renumeri, kaj iliaj celaj nombroj.")

(defun fenestrojn-klase-renumerigu (win)
  "Fenestrojn renumeru"
  (let* ((class (window-class win))
         (target-number (cdr (assoc class *fenestraj-klasaj-nombroj*
                                    :test #'string=))))

    (when target-number
      (let ((other-win (find-if #'(lambda (win)
                                    (= (window-number win) target-number))
                                (group-windows (window-group win)))))
        (if other-win
            (when (string-not-equal class (window-class other-win))
              (setf (window-number other-win) (window-number win))
              (setf (window-number win) target-number))
            (setf (window-number win) target-number))
        (update-all-mode-lines)))))

(add-hook *new-window-hook* 'fenestrojn-klase-renumerigu)
