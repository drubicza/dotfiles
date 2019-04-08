;;;; komandoj.lisp

(in-package #:stumpwm)


;;;-------------------------------------------------------------------------------------------------
;;; Ĉefaj
;;;-------------------------------------------------------------------------------------------------

(defcommand komando (&optional initial-input)
  (:rest)
  "Komandon el la uzanto legu."
  (let ((kmd (completing-read (current-screen)
                              "komando: "
                              (all-commands) :initial-input (or initial-input ""))))
    (unless kmd
      (throw 'error :abort))
    (when (plusp (length kmd))
      (eval-command kmd t))))

(defun kuru (komando &optional (mesagxo ""))
  "Ŝelan komandon kuru."
  (run-shell-command komando)
  (message mesagxo))

(defcommand nenio ()
  ()
  "Nenion faras.")


;;;-------------------------------------------------------------------------------------------------
;;; Sonforteco
;;;-------------------------------------------------------------------------------------------------

(defun pulseaudio-trua-indekso ()
  "La indekson de la defaŭlta PulseAudio-a truo revenu."
  (let* ((eligo (inferior-shell:run/lines "pacmd list-sinks"))
         (linio (first (remove-if-not #'(lambda (linio) (search "* index" linio)) eligo))))
    (parse-integer (cl-ppcre:regex-replace-all ".*: (\d*)" linio "\\1") :junk-allowed t)))

(defun sonfortecon-akiru ()
  "La valoron de la sonforteco akiru."
  (inferior-shell:run/ss "pamixer --get-volume"))

(defcommand sonfortecon-montru ()
  ()
  "La sisteman sonfortecon montru."
  (message "~A" (sonfortecon-akiru)))

(defun sonfortecon-formatu ()
  "La formatigitan valoron de la sonforteco revenu."
  (format nil "S: ~A" (sonfortecon-akiru)))

(defcommand sonfortecon-mutigu ()
  ()
  "La sisteman sonfortecon mutigu."
  (kuru "pamixer --mute" (sonfortecon-akiru)))

(defcommand sonfortecon-malpliigu ()
  ()
  "La sistema sonfortecon malpliigu."
  (kuru "pamixer --decrease 5" (sonfortecon-formatu)))

(defcommand sonfortecon-pliigu ()
  ()
  "La sisteman sonfortecon pliigu."
  (kuru "pamixer --increase 5" (sonfortecon-formatu)))

(defcommand sonfortecon-minimumigu ()
  ()
  "La sisteman sonfortecon plej malpliigu."
  (kuru "pamixer --set-volume 0" (sonfortecon-formatu)))

(defcommand sonfortecon-maksimumigu ()
  ()
  "La sisteman sonfortecon plej pliigu."
  (kuru "pamixer --set-volume 100" (sonfortecon-formatu)))

(defcommand sonfortecon-kvindekigu ()
  ()
  "La sisteman sonfortecon agordu al 50%."
  (kuru "pamixer --set-volume 50" (sonfortecon-formatu)))


;;;-------------------------------------------------------------------------------------------------
;;; Miksaĵo
;;;-------------------------------------------------------------------------------------------------

(defcommand staton-montru ()
  ()
  "La sisteman staton montru."
  (message "~A~%"
           (uiop:with-output (str nil)
             (local-time:format-timestring
              str
              (local-time:now)
              :format '(:short-weekday ", " (:day 2) #\  :short-month #\  (:year 4) #\  (:hour 2) #\:
                        (:min 2) #\: (:sec 2) #\  :gmt-offset-hhmm))
             (format str "~%~A" (scripts/utils:battery-status)))))

(defcommand datumon-montru ()
  ()
  "La sisteman datumon montru."
  (message "~A~%"
           (uiop:with-output (str nil)
             (format str "~%E: ~A" (pelo/pelo:get-ping "1.1.1.1"))
             (format str "~%S: ~A" (inferior-shell:run/ss "pamixer --get-volume"))
             ;; (format s "~%T: ~A" (write-to-string (or (scripts/tablet:intuos-ring-status) 0) :base 10))
             )))


;;;-------------------------------------------------------------------------------------------------
;;; Ekranbrileco
;;;-------------------------------------------------------------------------------------------------

(defcommand ekranbrilecon-malpliigu ()
  ()
  "La ekranan brilecon malpliigu."
  (kuru "xbacklight -dec 5" "-5"))

(defcommand ekranbrilecon-pliigu ()
  ()
  "La ekranan brilecon pliigu."
  (kuru "xbacklight -inc 5" "+5"))

(defcommand ekranbrilecon-minimumigu ()
  ()
  "La ekranan brilecon minimumigu."
  (kuru "xbacklight -set 0" "0%"))

(defcommand ekranbrilecon-maksimumigu ()
  ()
  "La ekranan brilecon maksimumigu."
  (kuru "xbacklight -set 100" "100%"))


;;;-------------------------------------------------------------------------------------------------
;;; Aplikaĵoj
;;;-------------------------------------------------------------------------------------------------

(defcommand je-x-sxargxu ()
  ()
  "Je x ŝarĝu."
  (scripts/general:x)
  (message "#"))

(defcommand je-intuos-ring-sxargxu ()
  ()
  "Je intuos-ring ŝarĝu."
  (scripts/tablet:intuos-ring)
  (message "T: ~A" (write-to-string (scripts/tablet:intuos-ring-status) :base 10)))

(defcommand ehxosondon-akiru ()
  ()
  "La resulton de ping akiru."
  (message (pelo/pelo:get-ping "1.1.1.1")))


;;;-------------------------------------------------------------------------------------------------
;;; Ekrankopioj
;;;-------------------------------------------------------------------------------------------------

(defcommand partan-ekrankopion-tenu ()
  ()
  "Partan ekrankopion tenu."
  (scripts/apps:screenshot "region"))

(defcommand plenan-ekrankopion-tenu ()
  ()
  "Plenan ekrankopion tenu."
  (scripts/apps:screenshot "full"))


;;;-------------------------------------------------------------------------------------------------
;;; Retkamerao
;;;-------------------------------------------------------------------------------------------------

(defcommand zomon-malpliigu ()
  ()
  "La retkameraan zomon malpliigu."
  (scripts/webcam:decrease-zoom))

(defcommand zomon-pliigu ()
  ()
  "La retkameraan zomon pliigu."
  (scripts/webcam:increase-zoom))

(defcommand minimumigu-zomon ()
  ()
  "La retkameraan zomon minimumigu."
  (scripts/webcam:minimum-zoom))

(defcommand maksimumigu-zomon ()
  ()
  "La retkameraan zomon maksimumigu."
  (scripts/webcam:maximum-zoom))


;;;-------------------------------------------------------------------------------------------------
;;; Klavoj
;;;-------------------------------------------------------------------------------------------------

(defun klavojn-mapu (mapo klavoj)
  "La klavajn-valarajn duojn en KLAVOJ al MAPO mapu."
  (loop :for (klavo . valoro) :in klavoj :do
       (define-key mapo (kbd klavo) valoro)))

(defun klavojn-malmapu (mapo klavoj)
  "La klavajn-valarajn duojn en KLAVOJ al MAPO mapu"
  (loop :for klavo :in klavoj :do
       (undefine-key mapo (kbd klavo))))


;;;-------------------------------------------------------------------------------------------------
;;; Musmontrilo
;;;-------------------------------------------------------------------------------------------------

(defcommand musmontrilon-centrigu ()
  ()
  "La musmontrilon centrigu."
  (let* ((ekrano (current-screen))
         (x (/ (screen-width ekrano) 2))
         (y (/ (screen-height ekrano) 2)))
    (ratwarp x y)))

(defcommand musmontrilon-stumpigu ()
  ()
  "La musmontrilon stumpigu [:."
  (ratwarp 0 0))
