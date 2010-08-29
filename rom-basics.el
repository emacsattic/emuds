;;; this will setup the basics, any char in realm may need

(defvar /bag "bag"                      "your current container")
(defvar /eat "bread"                    "your current food")
(defvar /drink "bottle"                 "your current drink")
(defvar /sacr  "sacrifice"              "the way to sarcrifice")
(defvar /rcl   "recite"                 "the way to recall")
(defvar /track0 nil                     "whom to track")
(defvar /track1 nil                     "first direction")
(defvar /track2 nil                     "2nd direction")
(defvar /victim nil                     "whom to kill")
(defvar /assist nil                     "whom to assist")
(defvar /walker nil                     "i am no walker")
(defvar /wimp   nil                     "i am no wimp")
(defvar /penny  t                       "staymos dont need to loot")
(defvar /hold   nil                     "item to hold in hand all the time")

					; change your bag, eat and drink
					; interactive by typing m-x

(defun /bag (container)                 "set your container"
  (interactive "sContainer:")
  (setq /bag container))
(defun /eat (food)                      "set your food"
  (interactive "sFood:")
  (setq /eat food))
(defun /drink (container)               "set your drink"
  (interactive "sContainer:")
  (setq /drink container))
(defun /victim (foo)                    "setup victim"
  (interactive "sFoo:")
  (setq /victim foo))
(defun /assist (friend)                 "setup assist"
  (interactive "sFriend:")
  (setq /assist friend))
(defun /rcl (way)                       "setup your recall"
  (interactive "sRecall:")
  (setq /rcl way))
(defun /sacr (way)                      "setup your sacrifie"
  (interactive "sSacrifice:")
  (setq /sacr way))
(defun /consider (foo)                  "consider a victim"
  (interactive "sVictim: ")
  (/send (concat "consider " foo))
  (setq /victim foo))
(defun /follow (friend)                 "follow a friend"
  (interactive "sFriend:")
  (/send (concat "follow " friend))
  (/assist friend))
(defun /hold (item)                     "set your hold item"
  (interactive "sItem:")
  (setq /hold item))

(defun /dw () "door w" (interactive) (/queue "open door w" "w" "close door e"))
(defun /de () "door w" (interactive) (/queue "open door e" "e" "close door w"))
(defun /ds () "door w" (interactive) (/queue "open door s" "s" "close door n"))
(defun /dn () "door w" (interactive) (/queue "open door n" "n" "close door s"))

(defun /get (thing) "get from bag" (interactive "sThing:")
  (/queue (concat "get " thing " " /bag) ) )
(defun /put (thing) "put into bag" (interactive "sThing:")
  (/queue (concat "put " thing " " /bag) ) )

					; define some triggers
					; to eat and drink, and to loot gold 

(/trigger "^You are thirsty.$" 'unless
	  '(string= /drink "")
	  '(/queue (concat "drink " /drink)))
(/trigger "^You are hungry.$" 'unless
	  '(string= /eat "")
	  '(/queue (concat "get " /eat " " /bag))
	  '(/queue (concat "eat " /eat)))
(/trigger "^A large fountain carved from blue-streaked marble is here,"
	  'when '(equal /drink "bottle")
	  '(/queue "fill bottle fountain" ) )
(/trigger "^A great blue fountain of clear water is bubbling here."
	  'when '(equal /drink "bottle")
	  '(/queue "fill bottle fountain" ) )

(/trigger "^There were \\([0-9]*\\) coins." '/queue
        '(concat "split " (match-string 1)))
(/trigger "^A .* of gold coins .* here." 'when '/penny
        '(/queue "get gold" ))

(/trigger "^You gain one measly exp for this fight." '/queue
	  "get gold corpse"
	  "exam corpse")
(/trigger "^You gain .* for killing this opponent." '/queue
	  "get gold corpse"
	  "exam corpse")

(/trigger "sends you sprawling with a powerful bash!$" '/queue "stand" )
(/trigger "^As .* avoids your bash, you topple over and fall to the ground!$" '/queue "stand" )
(/trigger "^As you step on something very slippery, you lose your\nbalance and fall.$" '/queue "stand" )
(/trigger "^Damn! You let go of.* \\([A-Za-z]*\\)! You" '/queue
	  '(concat "get " (match-string 1))
	  '(concat "wield " (match-string 1)) )

(/trigger "^A token of the wind has fallen on the ground here - ready to be taken...It has a soft glowing aura!..It emits a faint humming sound!$" '/send "get token")

(defun /group-key ()                    "group status"
  (interactive)
  (/send "group"))
(defun /loot-key ()                     "loot a corpse"
  (interactive)
  (/send "get all corpse"))
(defun /sacr-key ()                     "sacrifice a corpse"
  (interactive)
  (/send (concat /sacr " corpse")))
(defun /kill-key ()                     "kill a victim"
  (interactive)
  (/send (concat "kill " /victim)))
(defun /assist-key ()                   "assist a friend"
  (interactive)
  (/send (concat "assist " /assist)) )
(defun /flee-key ()                     "wimp out"
  (interactive)
  (/send "flee") )
(defun /healing-key ()                  "heal myself"
  (interactive)
  (/send (concat "get healing " /bag))
  (/queue "quaff healing" "group") )
(defun /recall-key ()                   "recall myself"
  (interactive)
  (/send (concat /rcl " recall"))
  (/queue (concat "get recall " /bag)) )
(defun /rest-key ()                     "sit down"
  (interactive)
  (/send "rest") )
(defun /stand-key ()                    "stand up"
  (interactive)
  (/send "stand") )

(defun /north-key () "go north" (interactive) (/send "north") )
(defun /east-key ()  "go east"  (interactive) (/send "east") )
(defun /south-key () "go south" (interactive) (/send "south") )
(defun /west-key ()  "go west"  (interactive) (/send "west") )
(defun /up-key ()    "go up"    (interactive) (/send "up") )
(defun /down-key ()  "go down"  (interactive) (/send "down") )

(defun /look-key () "look" (interactive) (/send "look") )
(defun /look-north-key () "look north" (interactive) (/send "look north") )
(defun /look-east-key ()  "look east"  (interactive) (/send "look east") )
(defun /look-south-key () "look south" (interactive) (/send "look south") )
(defun /look-west-key ()  "look west"  (interactive) (/send "look west") )
(defun /look-up-key ()    "look up"    (interactive) (/send "look up") )
(defun /look-down-key ()  "look down"  (interactive) (/send "look down") )

					; now define the keyboard

(/mapkey [kp-up] '/north-key)
(/mapkey [kp-right] '/east-key)
(/mapkey [kp-down] '/south-key)
(/mapkey [kp-left] '/west-key)
(/mapkey [kp-prior] '/up-key)
(/mapkey [kp-next] '/down-key)
(/mapkey [kp-home] '/stand-key)
(/mapkey [kp-end] '/rest-key)

(/mapkey [\C-kp-begin] '/look-key)
(/mapkey [\C-kp-up] '/look-north-key)
(/mapkey [\C-kp-right] '/look-east-key)
(/mapkey [\C-kp-down] '/look-south-key)
(/mapkey [\C-kp-left] '/look-west-key)
(/mapkey [\C-kp-prior] '/look-up-key)
(/mapkey [\C-kp-next] '/look-down-key)

(/mapkey [home] '/recall-key)
(/mapkey [prior] '/stand-key)
(/mapkey [next] '/rest-key)
                                        ; this does'nt work on some keyboards
                                        ; dont know why ?
(/mapkey [kp-8] '/north-key)
(/mapkey [kp-6] '/east-key)
(/mapkey [kp-2] '/south-key)
(/mapkey [kp-4] '/west-key)
(/mapkey [kp-9] '/up-key)
(/mapkey [kp-3] '/down-key)
					; message for completeness

(message "loaded Realms of Magic basics")