;;; ---------------------------------------------------------------------------
;;; ~/.emuds/emuds-config.el
;;; (c) LGPL kraehe@copyleft.de
;;; ---------------------------------------------------------------------------
;;; my emuds config

(autoload '/emuds     "emuds" "Talk to eMUDs." t)
(autoload '/addworld  "emuds" "Define a eMUDs world." t)

;;; set various pathes depending on OS

(unless *dothome*
(setq *dothome* (if (or (eq system-type 'windows-nt)
			(eq system-type 'ms-dos))
		    "c:/" "~/." )) )

(setq emuds-db   (concat *dothome* "emuds-db")
      emuds-logs (concat *dothome* "emuds-logs/")
      emuds-maps (concat *dothome* "emuds-maps/")
      emuds-pass (concat *dothome* "emuds-pass") )

;;; set font and size for game screen

(setq emuds-frame-alist (x-parse-geometry "80x44+2-30"))
(add-to-list 'emuds-frame-alist '(font . "9x15"))

;;; Last load the world definitions

(load "emuds-worlds.el")
