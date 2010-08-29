(defun /doctor-chat (ask) "play the doctor"
  (let ((answer))
      (with-current-buffer "*doctor*"
	(goto-char (point-max))
	(insert ask)
	(insert "\n")
	(setq emuds-doctor (point))
	(doctor-read-print)

	(setq answer (substring (buffer-substring emuds-doctor (point)) 1 -2) )
	)
;      (with-temp-buffer
;	(dolist (a (split-string walk "[\r\n]"))
;	  (insert a) (insert " ")
;	  )
;	)
      )
  )

(defun /doctor-reply () "reply with doctor"
  (/queue (concat "tell " (match-string 1) " "
		       (/doctor-chat (match-string 3))))
  )

(defun /doctor (victim) "trigger the doctor on victim"
  (interactive "sPlayer:")
  (when (get-buffer "*doctor*")
      (/trigger (concat "^\\("
			victim
			"\\) \\(says\\|tells\\|tells you\\|asks\\|asks you\\|replys\\), '\\(.+\\)'") '/doctor-reply) ))



