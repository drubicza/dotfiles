;;;; -*- mode: lisp; coding: utf-8 -*-

;; (declaim (optimize (debug 3)))


;;;-------------------------------------------------------------------------------------------------
;;; Quicklisp
;;;-------------------------------------------------------------------------------------------------

#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))


;;;-------------------------------------------------------------------------------------------------
;;; Helpiloj
;;;-------------------------------------------------------------------------------------------------

(defparameter +base-path+
  (uiop:subpathname* (user-homedir-pathname) "hejmo/ktp/lisp/")
  "The base location for the init files.")

(defun make-path (path)
  "Load file from PATH."
  (uiop:merge-pathnames* +base-path+ path))

(defun load-subsystem (path)
  "Load subsystem from PATH."
  (load (make-path path)))

(defun make (system)
  "Call ASDF:MAKE."
  (asdf:make system))


;;;-------------------------------------------------------------------------------------------------
;;; Ĝeneralaj
;;;-------------------------------------------------------------------------------------------------

;(make :mof)
(load-subsystem "common")


;;;-------------------------------------------------------------------------------------------------
;;; Realigospecifaj
;;;-------------------------------------------------------------------------------------------------

#+sbcl
(load-subsystem "sbcl")

#+lispworks
(load-subsystem "lispworks")
