;;; ---------------------------------------------------------------------------
;;; ~/.emacs dot-emacs-1-2-3
;;; (c) LGPL kraehe@copyleft.de

;;; ---------------------------------------------------------------------------
;;; 1th: Turn on debug on init and off after init

(setq debug-on-error t)
(add-hook 'after-init-hook (lambda () (setq debug-on-error nil)))

;;; ---------------------------------------------------------------------------
;;; 2nd: Detect operating system and install load-path

(setq *dothome* (if (or (eq system-type 'windows-nt)
			(eq system-type 'ms-dos))
		    "c:/" "~/." ))

;;; my configurations are in ~/.site-lisp while eMUDs is in ~/.emuds

(setq load-path (append
		 (mapcar '(lambda (x) (concat *dothome* x))
			 '("site-lisp" "emuds"))
		 load-path))

;;; ---------------------------------------------------------------------------
;;; 3rd: load configuration files

;; (load "mouse-config")
;; (load "style-config")
;; (load "lisp-config")
(load "emuds-config")
;; (load "erc-config")
;; (load "browser-config")
;; (load "artist-color")
;; (load "smalltalk-mode")
;; (setq gst-args '("-qgp"))
