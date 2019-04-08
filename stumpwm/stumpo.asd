#-asdf3.1 (error "ASDF 3.1 or bust!")

(defpackage :stumpo-system
  (:use #:cl #:asdf))

(in-package #:stumpo-system)

(defsystem :stumpo
  :name "stumpo"
  :version "0.0.12"
  :description "StumpWM-agordo"
  :license "CC0"
  :author "Rommel MARTINEZ <ebzzry@ebzzry.io>"
  :depends-on ("stumpwm"
               "local-time"
               "swank"
               "scripts"
               "pelo")
  :serial t
  :components ((:file "gxeneralaj")
               (:file "komandoj")
               (:file "klavoj")
               (:file "grupoj")
               (:file "swanko")
               (:file "transpasoj")))
