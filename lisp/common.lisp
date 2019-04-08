;;;; -*- mode: lisp; coding: utf-8 -*-

(defvar *common-lisp-directory*
  (pathname
   (concatenate 'string
                (namestring (merge-pathnames (user-homedir-pathname)
                                             "common-lisp"))
                "/")))

(when (find-package :asdf)
  (push *common-lisp-directory* asdf:*central-registry*))
