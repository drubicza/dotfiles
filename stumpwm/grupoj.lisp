;;;; grupoj.lisp

(in-package #:stumpwm)


;;;-------------------------------------------------------------------------------------------------
;;; Grupoj
;;;-------------------------------------------------------------------------------------------------

(defcommand grename (name) ((:string "Nova nomo de grupo: "))
  "La nunan grupon renomu"
  (let ((group (current-group)))
    (cond ((find-group (current-screen) name)
           nil)
          ((or (zerop (length name))
               (string= name "."))
           (message "^1*^BError: empty name"))
          (t
           (cond ((and (char= (char name 0) #\.) ;change to hidden group
                       (not (char= (char (group-name group) 0) #\.)))
                  (setf (group-number group) (find-free-hidden-group-number (current-screen))))
                 ((and (not (char= (char name 0) #\.)) ;change from hidden group
                       (char= (char (group-name group) 0) #\.))
                  (setf (group-number group) (find-free-group-number (current-screen)))))
           (setf (group-name group) name)))))

(defun grupojn-sxargxu ()
  "La plej supra nivela funkcio."
  (run-commands
   "grename unu"
   "gnewbg du"
   "gnewbg tri"
   "gnewbg kvar"
   "gnewbg kvin"
   "gnewbg ses"
   "gnewbg sep"
   "gnewbg ok"
   "gnewbg naux"
   "gnewbg dek"))


;;;-------------------------------------------------------------------------------------------------
;;; Registrado
;;;-------------------------------------------------------------------------------------------------

(komencan-krocxilon-registru 'grupojn-sxargxu)
