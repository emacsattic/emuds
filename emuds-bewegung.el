;;; eMUDs basic movment

(defvar emuds-walk-stack nil "old walk")
(defvar emuds-back-stack nil "old walk back")

(defun /go-mark () "mark this position" (interactive)
  (setq emuds-back-stack nil)
  (setq emuds-walk-stack nil)
  (message "go-mark reset") )

(defun emuds-go-pop () "just pop the stack" (interactive)
  (when emuds-walk-stack
    (setq emuds-back-stack (cdr emuds-back-stack))
    (setq emuds-walk-stack (cdr emuds-walk-stack))
    (message "go backward") ))

(defun /go (walk) "go into direction" (interactive "sDir:")
  (if (and emuds-back-stack
	   (string= (car emuds-back-stack) walk) )
      (emuds-go-pop)
    (let (( back 
	    (cond
	     ((string= "oben" walk) "unten")
	     ((string= "unten" walk) "oben")
	     ((string= "norden" walk) "sueden")
	     ((string= "sueden" walk) "norden")
	     ((string= "osten" walk) "westen")
	     ((string= "westen" walk) "osten")
	     ((string= "nordosten" walk) "suedwesten")
	     ((string= "nordwesten" walk) "suedosten")
	     ((string= "suedosten" walk) "nordwesten")
	     ((string= "suedwesten" walk) "nordosten")
	     (t "scratch") )))
      (setq emuds-back-stack (cons back emuds-back-stack))
      (setq emuds-walk-stack (cons walk emuds-walk-stack)) ))
  (/send walk) )

(defun /go-back () "go back" (interactive)
  (if emuds-back-stack
      (progn
	(/send (car emuds-back-stack))
	(emuds-go-pop) )
    (message "go where ?") ))

(defun emuds-no-key () "go north" (interactive) (/go "norden") )
(defun emuds-ea-key () "go east"  (interactive) (/go "osten") )
(defun emuds-so-key () "go south" (interactive) (/go "sueden") )
(defun emuds-we-key () "go west"  (interactive) (/go "westen") )
(defun emuds-nw-key () "go nw"    (interactive) (/go "nordwesten") )
(defun emuds-ne-key () "go ne"    (interactive) (/go "nordosten") )
(defun emuds-sw-key () "go sw"    (interactive) (/go "suedwesten") )
(defun emuds-se-key () "go se"    (interactive) (/go "suedosten") )
(defun emuds-up-key () "go up"    (interactive) (/go "oben") )
(defun emuds-do-key () "go down"  (interactive) (/go "unten") )

(defun emuds-look-key ()    "look"      (interactive) (/send "schau") )
(defun emuds-look-no-key () "look north"(interactive) (/send "schau norden") )
(defun emuds-look-ea-key () "look east" (interactive) (/send "schau osten") )
(defun emuds-look-so-key () "look south"(interactive) (/send "schau sueden") )
(defun emuds-look-we-key () "look west" (interactive) (/send "schau westen") )
(defun emuds-look-nw-key () "look nw"   (interactive) (/send "schau nordwesten"))
(defun emuds-look-ne-key () "look ne"   (interactive) (/send "schau nordosten"))
(defun emuds-look-sw-key () "look sw"   (interactive) (/send "schau suedwesten"))
(defun emuds-look-se-key () "look se"   (interactive) (/send "schau suedosten"))
(defun emuds-look-up-key () "look up"   (interactive) (/send "schau oben") )
(defun emuds-look-do-key () "look down" (interactive) (/send "schau unten") )

					; now define the keyboard

(/mapkey [kp-begin] '/go-back)
(/mapkey [kp-up]    'emuds-no-key)
(/mapkey [kp-right] 'emuds-ea-key)
(/mapkey [kp-down]  'emuds-so-key)
(/mapkey [kp-left]  'emuds-we-key)
(/mapkey [kp-prior] 'emuds-ne-key)
(/mapkey [kp-next]  'emuds-se-key)
(/mapkey [kp-home]  'emuds-nw-key)
(/mapkey [kp-end]   'emuds-sw-key)
(/mapkey [prior]    'emuds-up-key)
(/mapkey [next]     'emuds-do-key)

(/mapkey [\M-kp-begin] 'emuds-go-pop)
(/mapkey [\C-kp-begin] 'emuds-look-key)
(/mapkey [\C-kp-up]    'emuds-look-no-key)
(/mapkey [\C-kp-right] 'emuds-look-ea-key)
(/mapkey [\C-kp-down]  'emuds-look-so-key)
(/mapkey [\C-kp-left]  'emuds-look-we-key)
(/mapkey [\C-kp-prior] 'emuds-look-ne-key)
(/mapkey [\C-kp-next]  'emuds-look-se-key)
(/mapkey [\C-kp-home]  'emuds-look-nw-key)
(/mapkey [\C-kp-end]   'emuds-look-sw-key)
(/mapkey [\C-prior]    'emuds-look-up-key)
(/mapkey [\C-next]     'emuds-look-do-key)

(message "Loaded eMUDs Movement")
