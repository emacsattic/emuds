(defun /dopath (walk) "do a speedwalk" (interactive "sSpeedwalk:")
  (let ((count nil))
    (dolist (step (split-string walk ""))
      (if (or (string< step "0") (string< "9" step))
	  (when (or (string= step "n")
		    (string= step "e")
		    (string= step "s")
		    (string= step "w")
		    (string= step "u")
		    (string= step "d"))
	    (if count (progn
			(dotimes (i count) (/queue step) )
			(setq count nil))
	      (/queue step)))
	(if count
	    (setq count (+ (* 10 count) (string-to-number step)))
	  (setq count (string-to-number step))
	  )
	)
      )
    )
  )
  
(defvar emuds-speedwalk nil "list of speedwalks")

(defun /speedwalk (from to) "speedwalk from list"
  (interactive "sFrom: \nsTo:")
  (let ((done nil) (walk nil))
    (dolist (walk emuds-speedwalk)
;;;   (message (format "%s -> %s : %s" (car walk) (cadr walk) (cddr walk)))
      (when (and (not done)
		 (string= from (car walk))
		 (string= to (cadr walk)))
	(setq done t)
	(dolist (step (cddr walk))
;;;	  (message step)
	  (emuds-interprete-queue step)
	  )
	)
      )
    (unless done
      (message (format "Speedwalk from %s to %s not found." from to)))
    )
  )
