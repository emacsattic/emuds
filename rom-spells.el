;;; Spell definitions for a Cleric

;; forget about learning 'cure' spells - healing potion in moonglow
;; is cheap and easy to get - and power potion in Rodavi does the
;; better cure's - only learn 'heal' and 'restore'

(defvar /heal "restore"                 "best healing spell")
(defun /heal (spell)                    "set your healing spell"
  (interactive "sSpell:")
  (setq /heal spell))
(defun /heal-key ()                     "heal myself"
  (interactive)
  (/send (concat "cast '" /heal "' self" )) 
  (/queue "group") )
(defun /healass-key ()                  "heal assist"
  (interactive)
  (/send (concat "cast '" /heal "' " /assist)) 
  (/queue "group") )

(defvar /cast "curse" "attack spell")
(defun /cast-key () "attack with spell" (interactive)
  (/send (concat "cast '" /cast "' " /victim)) )
(defun /cast (spell) "define attack spell"
  (interactive "sSpell:")
  (/mapkey [f8] '/cast-key)
  (setq /cast spell) )

;; the clerics staff is realy usefull - peace and sanctuary
(defun /peace-key () "peace up" (interactive) (/send "beg peace"))
(defun /sanctuary-on-key () "sanctuary on" (interactive) (/send "sanctuary on"))
(defun /sanctuary-off-key () "sanctuary off" (interactive) (/send "sanctuary off"))

;; 'call undead' is realy usefull - forget about 'animate dead'
(defun /undead () "call undead" (interactive)
  (/once)
  (/once "An undead creature appears out of nowhere!\n[A-Za-z ]* \\([a-zA-Z]+\\) starts following you.$" 'progn
	 '(setq /assist (match-string 1))
	 '(/queue "group all")
	 '(/once))
  (/send "cast 'call undead'") )
(defun /order-fol-kill-assist-key () "order followers to kill and assist"
  (interactive)
  (/send (concat "order " /assist " kill " /victim)) 
  (/queue (concat "order followers assist " /assist)
	    (concat "assist " /assist))
  )

;; illusion is not realy a cleric spell but it fits well into clerics style
(defun /illusion-key () "illusion" (interactive) (/send "cast 'illusion'"))
(defun /illusion-sanct-assist-key ()           "illusion, sanctuary assist"
  (interactive)
  (/send "cast 'illusion'")
  (/queue "sanctuary on" "assist illusion") )
;; rift is also mage - but think about groups of followers
(defun /rift (person) "rift to person" (interactive "sPerson:")
  (/queue
        (concat "cast 'rift' " person)
        "order followers enter rift"
        (concat "order " emuds-rqe-mob1 " enter rift")
        "enter rift") )

;;; ---------------------------------------------------------------------------
;;; Contemplation - looking at score and casting spells

;;; "You are flying."
;;; "You're spreading an aura of peace."
;;; "You are invisible."
;;; "You feel righteous."
;;; "You have been aided."
;;; "The difference between good and evil is very clear to you."
;;; "You are sensitive to the presence of invisible things."
;;; "You can see what lies ahead."
;;; "You are sensitive to the presence of magical things."
;;; "You can feel the aggressiveness of other beings."
;;; "You can feel the presence of living beings around you."
;;; "You have skin as tough as stone."
;;; "You are protected by Sanctuary."
;;; "You feel protected."
;;; "A dome of magical energy is protecting you."
;;; "You are summonable by other players."
;;; "You finished [0-9]+ random quests"
;;; "You are poisoned!"

(defun /contemplate ()                  "contemplate about score"
  (setq emuds-score "score")
  (setplist 'emuds-score ())

  (/once)

  (/once "^You are resting." 'progn '(put 'emuds-score 'resting 'true))
  (/once "^You are flying." 'progn '(put 'emuds-score 'flying 'true))
  (/once "^You feel righteous." 'progn '(put 'emuds-score 'right 'true))
  (/once "^You feel protected." 'progn '(put 'emuds-score 'armor 'true))
  (/once "^You are invisible." 'progn '(put 'emuds-score 'invis 'true))
  (/once "^You are thirsty." 'progn '(put 'emuds-score 'thirsty 'true))
  (/once "^You are hungry." 'progn '(put 'emuds-score 'hungry 'true))
  (/once "^You are thirsty." 'progn '(put 'emuds-score 'thirsty 'true))
  (/once "^You are poisoned!" 'progn '(put 'emuds-score 'poisoned 'true))
  (/once "^You have been aided." 'progn '(put 'emuds-score 'aided 'true))
  (/once "^You're spreading an aura of peace."
	 'progn '(put 'emuds-score 'peace 'true))
  (/once "^You can see what lies ahead."
	 'progn '(put 'emuds-score 'wizeye 'true))
  (/once "^You have skin as tough as stone."
	 'progn '(put 'emuds-score 'stone 'true))
  (/once "^You are protected by Sanctuary." 
	 'progn '(put 'emuds-score 'sanct 'true))
  (/once "^You are summonable by other players."
	 'progn '(put 'emuds-score 'summon 'true))
  (/once "^The difference between good and evil is very clear to you."
	 'progn '(put 'emuds-score 'dalign 'true))
  (/once "^You are sensitive to the presence of invisible things."
	 'progn '(put 'emuds-score 'dinvis 'true))
  (/once "^You are sensitive to the presence of magical things."
	 'progn '(put 'emuds-score 'dmagic 'true))
  (/once "^You can feel the aggressiveness of other beings."
	 'progn '(put 'emuds-score 'daggr 'true))
  (/once "^You can feel the presence of living beings around you."
	 'progn '(put 'emuds-score 'dliving 'true))
  (/once "^A dome of magical energy is protecting you."
	 'progn '(put 'emuds-score 'dome 'true))
  (/once "You finished [0-9]+ random quests" 'progn
    '(/once)
    '(/contemplate-hook)
    '(if (get 'emuds-score 'summon) (/queue "nosummon")) ) )

(defalias '/contemplate-hook 'nil)

(defun /peace ()                        "peace up"
  (interactive)
  (defalias '/contemplate-hook '/peace-hook)
  (/contemplate)
  (/queue "score") )
(defun /fight ()                        "fight up"
  (interactive)
  (defalias '/contemplate-hook '/fight-hook)
  (/contemplate)
  (/queue "score") )

(message "loaded Cleric")
