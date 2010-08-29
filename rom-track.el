;;; this defines the track function

				        ; track is one of the most powerful
					; skills in the realm 
					; its therefor on F1 key

(defun /walker-hook ()                  "hook to do after each walk"
  (if (and /walker (stringp /track0) )
      (/queue (concat "track " /track0))
      (/once)
      ))
(defalias '/track-hook '/walker-hook)   ; used as an alias in /track-key
(defun /track-key ()                    "track a step"
  (interactive)
  (/once)
  (/once "You're already in the same room!!" '/stop-walk )
  (/once "You can't see right now." 'setq '/stop-walk)
  (/once "No way!  You're fighting for your life!" '/stop-walk)
  (/once "You need a boat to go there." '/stop-walk)
  (/once "^You sense a trail \\(.\\)" 'progn
	    '(setq /track1 /track2)
	    '(setq /track2 (match-string 1))
	    '(if (equal /track1 /track2)
		 (progn
		   (/queue /track1)
		   (/track-hook)
		   (setq /track1 nil)
		   (setq /track2 nil)
		 )
	       (if (stringp /track0) (/queue (concat "track " /track0)))
	       )
	    )
  (setq /track1 nil)
  (setq /track2 nil)
  (if (stringp /track0) (/send (concat "track " /track0)))
  )
(defun /walker ()                       "become a walker"
  (interactive)
  (setq /walker t)
  (defalias '/track-hook '/walker-hook)
  (/track-key)
  )
(defun /stop-walk ()                    "stop walking around"
  (interactive)
  (setq /walker nil)
  (/once)
  )
(defun /walk-or-stop ()                 "toggle walking"
  (interactive)
  (if /walker (/stop-walk) (/walker)))

					; now define the keyboard

(defun /track (victim)                  "setup victim to track"
  (interactive "sVictim:")
  (if (stringp victim)
      (setq /track0 victim))
  (/mapkey [f1] '/track-key)
  (/mapkey [\C-f1] '/walk-or-stop)
  )

					; message for completeness

(message "loaded Realms of Magic track")
