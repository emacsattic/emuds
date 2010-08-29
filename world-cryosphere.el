;;; Cryosphere - SciFi MUD
;;;
;;; settings :
;;;   rows 99999
;;;
;;; this file mostly defines movement - i hope you enjoy

(emuds-setup-request-eor)  ; request EOR prompt marks

(defvar cryosphere-exit-flag nil)

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
	     ((string= "in" walk) "out")
	     ((string= "out" walk) "in")
	     ((string= "fore" walk) "aft")
	     ((string= "aft" walk) "fore")
	     ((string= "port" walk) "starboard")
	     ((string= "port" walk) "starboard")
	     ((string= "clockwise" walk) "anticlockwise")
	     ((string= "anticlockwise" walk) "clockwise")
	     ((string= "hubwards" walk) "rimwards")
	     ((string= "rimwards" walk) "hubwards")

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

(defun emuds-in-key () "go in" (interactive) (/go "in") )
(defun emuds-out-key () "go out"  (interactive) (/go "out") )
(defun emuds-fore-key () "go fore" (interactive) (/go "fore") )
(defun emuds-aft-key () "go aft"  (interactive) (/go "aft") )
(defun emuds-star-key () "go star" (interactive) (/go "starboard") )
(defun emuds-port-key () "go port"  (interactive) (/go "port") )
(defun emuds-clock-key () "go clockwise"  (interactive) (/go "clockwise") )
(defun emuds-anti-key () "go anticlock"  (interactive) (/go "anticlockwise") )
(defun emuds-hub-key () "go hubwards"  (interactive) (/go "hubwards") )
(defun emuds-rim-key () "go rimwards"  (interactive) (/go "rimwards") )

(defun emuds-look-in-key () "look in" (interactive) (/send "look in") )
(defun emuds-look-out-key () "look out"  (interactive) (/send "look out") )
(defun emuds-look-fore-key () "look fore" (interactive) (/send "look fore") )
(defun emuds-look-aft-key () "look aft"  (interactive) (/send "look aft") )
(defun emuds-look-star-key () "look star" (interactive) (/send "look starboard") )
(defun emuds-look-port-key () "look port"  (interactive) (/send "look port") )
(defun emuds-look-clock-key () "look clockwise"  (interactive) (/send "look clockwise") )
(defun emuds-look-anti-key () "look anticlock"  (interactive) (/send "look anticlockwise") )
(defun emuds-look-hub-key () "look hubwards"  (interactive) (/send "look hubwards") )
(defun emuds-look-rim-key () "look rimwards"  (interactive) (/send "look rimwards") )

					; now define the keyboard first time

(/mapkey [kp-begin] '/go-back)
(/mapkey [\M-kp-begin] 'emuds-go-pop)
(/mapkey [\C-kp-begin] 'emuds-look-key)

(/mapkey [kp-up]    'emuds-no-key)
(/mapkey [kp-right] 'emuds-ea-key)
(/mapkey [kp-down]  'emuds-so-key)
(/mapkey [kp-left]  'emuds-we-key)
(/mapkey [kp-prior] 'emuds-up-key)
(/mapkey [kp-next]  'emuds-do-key)
(/mapkey [kp-home]  'emuds-in-key)
(/mapkey [kp-end]   'emuds-out-key)

(/mapkey [\C-kp-up]    'emuds-look-no-key)
(/mapkey [\C-kp-right] 'emuds-look-ea-key)
(/mapkey [\C-kp-down]  'emuds-look-so-key)
(/mapkey [\C-kp-left]  'emuds-look-we-key)
(/mapkey [\C-kp-prior] 'emuds-look-up-key)
(/mapkey [\C-kp-next]  'emuds-look-do-key)
(/mapkey [\C-kp-home]  'emuds-look-in-key)
(/mapkey [\C-kp-end]   'emuds-look-out-key)

(defun cyrosphere-exit ()
  (let ((exit (match-string 1)))
    (when cryosphere-exit-flag 
      ;; (message (concat "catching exit " exit))

      (cond
       ((string= exit "fore") (progn
				(/mapkey [kp-up]    'emuds-fore-key)
				(/mapkey [\C-kp-up]    'emuds-look-fore-key)))
       ((string= exit "hubwards") (progn
				    (/mapkey [kp-up]    'emuds-hub-key)
				    (/mapkey [\C-kp-up]    'emuds-look-hub-key)))
       ((string= exit "north") (progn
				 (/mapkey [kp-up]    'emuds-no-key)
				 (/mapkey [\C-kp-up]    'emuds-look-no-key)))
       ((string= exit "aft") (progn
			       (/mapkey [kp-down]  'emuds-aft-key)
			       (/mapkey [\C-kp-down]  'emuds-look-aft-key)))
       ((string= exit "rimwards") (progn
				    (/mapkey [kp-down]  'emuds-rim-key)
				    (/mapkey [\C-kp-down]  'emuds-look-rim-key)))
       ((string= exit "south") (progn
				 (/mapkey [kp-down]  'emuds-so-key)
				 (/mapkey [\C-kp-down]  'emuds-look-so-key)))
       
       ((string= exit "port") (progn
				(/mapkey [kp-left]    'emuds-port-key)
				(/mapkey [\C-kp-left]    'emuds-look-port-key)))
       ((string= exit "clockwise") (progn
				     (/mapkey [kp-left]    'emuds-clock-key)
				     (/mapkey [\C-kp-left]    'emuds-look-clock-key)))
       ((string= exit "west") (progn
				(/mapkey [kp-left]    'emuds-we-key)
				(/mapkey [\C-kp-left]    'emuds-look-we-key)))
       ((string= exit "starboard") (progn
				     (/mapkey [kp-right]  'emuds-star-key)
				     (/mapkey [\C-kp-right]  'emuds-look-star-key)))
       ((string= exit "anticlockwise") (progn
					 (/mapkey [kp-right]  'emuds-anti-key)
					 (/mapkey [\C-kp-right]  'emuds-look-anti-key)))
       ((string= exit "east") (progn
				(/mapkey [kp-right]  'emuds-ea-key)
				(/mapkey [\C-kp-right]  'emuds-look-ea-key))) ))))

(/trigger "^Obvious exits are...$" 'progn '(setq cryosphere-exit-flag "ok"))
(/trigger "^  \\([a-z]+\\) +:" 'cyrosphere-exit)
(/trigger "^[^ ]" 'progn '(setq cryosphere-exit-flag nil))
(/go-mark)

(message "Loaded eMUDs Movement")
