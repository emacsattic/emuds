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
	     ((string= "up" walk) "down")
	     ((string= "down" walk) "up")
	     ((string= "north" walk) "south")
	     ((string= "south" walk) "north")
	     ((string= "east" walk) "west")
	     ((string= "west" walk) "east")
	     ((string= "northeast" walk) "southwest")
	     ((string= "northwest" walk) "southeast")
	     ((string= "southeast" walk) "northwest")
	     ((string= "southwest" walk) "northeast")
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

(defun emuds-no-key () "go north" (interactive) (/go "north") )
(defun emuds-ea-key () "go east"  (interactive) (/go "east") )
(defun emuds-so-key () "go south" (interactive) (/go "south") )
(defun emuds-we-key () "go west"  (interactive) (/go "west") )
(defun emuds-nw-key () "go nw"    (interactive) (/go "northwest") )
(defun emuds-ne-key () "go ne"    (interactive) (/go "northeast") )
(defun emuds-sw-key () "go sw"    (interactive) (/go "southwest") )
(defun emuds-se-key () "go se"    (interactive) (/go "southeast") )
(defun emuds-up-key () "go up"    (interactive) (/go "up") )
(defun emuds-do-key () "go down"  (interactive) (/go "down") )

(defun emuds-look-key ()    "look"      (interactive) (/send "look") )
(defun emuds-look-no-key () "look north"(interactive) (/send "look north") )
(defun emuds-look-ea-key () "look east" (interactive) (/send "look east") )
(defun emuds-look-so-key () "look south"(interactive) (/send "look south") )
(defun emuds-look-we-key () "look west" (interactive) (/send "look west") )
(defun emuds-look-nw-key () "look nw"   (interactive) (/send "look northwest"))
(defun emuds-look-ne-key () "look ne"   (interactive) (/send "look northeast"))
(defun emuds-look-sw-key () "look sw"   (interactive) (/send "look southwest"))
(defun emuds-look-se-key () "look se"   (interactive) (/send "look southeast"))
(defun emuds-look-up-key () "look up"   (interactive) (/send "look up") )
(defun emuds-look-do-key () "look down" (interactive) (/send "look down") )

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
