(defvar rom-moonglow-shop () "receipts for alchemie in moonglow shop")
(defvar rom-color-potion () "some colors of some potions")

(setq rom-moonglow-shop
      (list
 
       (list "armor" "feather")                       ; 1
       (list "missile" "eye")                         ; 2
       (list "cureblind" "feather" "eye")             ; 3
       (list "dalign" "bark")                         ; 4
       (list "causelight" "feather" "bark")           ; 5
       (list "recall" "eye" "bark")                   ; 6
       (list "slow" "feather" "eye" "bark")           ; 7
       (list "curelight" "pine")                      ; 8
       (list "detpoi" "feather" "pine")               ; 9
       (list "bless" "eye" "pine")                    ; 10
       (list "causecrit" "feather" "eye"  "pine")     ; 11
       (list "blind" "bark" "pine")                   ; 12
       (list "weaken" "feather" "bark" "pine")        ; 13
       (list "dettrap" "eye" "bark" "pine")           ; 14
       (list "cblind" "feather" "eye" "bark" "pine")  ; 15

       (list "restore" "feather" "eye" "bark" "seashell") ; 23
       (list "sanctuary" "bark" "pine" "seashell") ; 28
 ))

(setq rom-color-potion
      (list 
       (list "pale white" "armor")
       (list "pale red" "magic missile")
       (list "misty green" "cure blind")
       (list "shimmering orange" "detect align")
					; cause light wounds = magic missile
       (list "pale blue" "recall")
       (list "dull gray" "slow")
					; whats that - failures and more
       (list "pale gray" "poison")
       (list "pale green" "cure light wounds")
       (list "light green" "cure critical wounds")
       (list "yellowish orange" "detect magic")
       (list "pale orange" "detect poison")
       (list "misty orange" "detect invis")
       (list "reddish orange" "detect trap")
       (list "light blue" "teleport")
       (list "sparkling yellow" "counter magic")
       (list "bluish white" "fly")
       (list "bluish gray" "weaken")
       (list "misty white" "bless")
       (list "light gray" "curse")
       (list "misty gray" "blindness")
       (list "sparkling green" "restore")
       (list "glowing white" "sanctuary")
))

(defun rom-classify-potion () "potion classification"
  (let ((cp (assoc (match-string 1) rom-color-potion)))
    (if cp (/queue (format "label homemade %s" (cadr cp)))
      (/queue "cast 'identify' homemade") ))
  (/once) )

(defun rom-shaker (vial buy zuta10) "shake a potion"
  (/send vial)
  (dolist (i zuta10) (/queue (format buy i) (format "put %s vial" i)) )
  (/queue "shake vial")
  (/exam-potion) )

(defun /exam-potion () "examine a potion" (interactive)
  (/once)
  (/once (concat "^You see a \\(.*\\) liquid.$") 'rom-classify-potion)
  (/queue "exam potion") )

(defun /shake (potion) "shake a potion in shop" (interactive)
  (let ((found (assoc potion rom-moonglow-shop)))
    (when found (rom-shaker "buy vial" "buy %s" (cdr found)) )) )

(defun /shake-get (potion) "shake a potion from bag" (interactive)
  (let ((found (assoc potion rom-moonglow-shop)))
    (when found (rom-shaker
		 (concat "get vial " /alchemie_bag)
		 (concat "get %s " /alchemie_bag)
		 (cdr found)) )) )

(defun /gather-shaker () "gather only for shops" (interactive)
  (/trigger "The leg of a spider is lying in the sand." '/alchemie_loot "leg")
  (/trigger "A small cactus has grown here." '/alchemie_loot "cactus")
  (/trigger "The fang of a white wolf is lying here." '/alchemie_loot "fang")
  (/trigger "A beautiful seashell is floating around." '/alchemie_loot "seashell")
)
