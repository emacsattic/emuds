;;; Skill definitions for Warrior and Thiefs

(defun /bash-key ()                     "bash a victim"
  (interactive)
  (/send "bash")
  (/queue "group") )
(defun /kick-key ()                     "kick a victim"
  (interactive)
  (/send "kick") 
  (/queue "group") )
(defun /rescue-key ()                   "rescue a friend"
  (interactive)
  (/send (concat "rescue " /assist)) )
(defun /hide-key ()                     "hide myself"
  (interactive)
  (/send "hide") )
(defun /backstab-flee-key ()            "backstab a victim and flee"
  (interactive)
  (setq /track0 /victim)
  (/once)
  (/once "quickly avoids your backstab and you nearly cut your own finger!$"
	    '/queue "flee")
  (/once "makes a strange sound as you place .* in his back!$"
	    'if '(eq /wimp t) '(/queue "flee") )
  (/once "^PANIC!  You couldn't escape!^" '/queue "flee")
  (/send (concat "knockout " /victim))
  (/send (concat "backstab " /victim))
  )
(defun /cry-ko-bs-bash-key ()              "warcry backstab bash"
   (interactive)
   (/send "warcry")
   (/queue (concat "knockout " /victim)
        (concat "backstab " /victim)
        (concat "bash " /victim))
   )
(defun /knockout-key ()                 "knockout a victim"
  (interactive)
  (/send (concat "knockout " /victim)) )
(defun /nowimp-key ()                   "dont wimp"
  (interactive)
  (setq /wimp nil)
  (message "dont wimp") )
(defun /wimp-key ()                     "i am a wimp"
  (interactive)
  (setq /wimp t)
  (message "i am a wimp") )

(defvar /throw "recall" "throw item")
(defun /throw-key () "attack with throw" (interactive)
  (/send (concat "get " /throw " " /bag))
  (when /hold (/queue (concat "remove " /hold )))
  (/queue (concat "hold " /throw )
        (concat "throw " /throw " " /victim))
  (when /hold (/queue (concat "hold " /hold )))
)
(defun /throw (item) "define attack spell"
  (interactive "sItem:")
  (/mapkey [f8] '/throw-key)
  (setq /throw item) )

