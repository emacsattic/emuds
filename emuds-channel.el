(defvar emuds-channel-gag nil "list of gaged players")

(defun emuds-channel-detach ()
  "detach channel spam"
  (save-current-buffer
    (put 'emuds-world 'cbuf (get-buffer-create (concat emuds-world "-chat")))
    (unless (get-buffer-window (get 'emuds-world 'cbuf)
			       (get 'emuds-world 'gfrm))
      (select-window (get-buffer-window (get 'emuds-world 'obuf)
					(get 'emuds-world 'gfrm)))
      (set-window-buffer (selected-window) (get 'emuds-world 'cbuf))
      (set-window-buffer
       (split-window (selected-window) 5)
       (get 'emuds-world 'obuf)) )
    (set-buffer (get 'emuds-world 'cbuf))
    (goto-char (point-max))
    (setq buffer-read-only t) ))

(defun emuds-channel-display (string)
  "display output to screen"
  (when emuds-channel-gag
    (with-temp-buffer
      (insert string)
      (dolist (gag emuds-channel-gag)
	(goto-char (point-min))
	(when (re-search-forward (concat "^" gag) nil t)
	  (goto-char (point-min))
	  (insert "!") ) )
      (setq string (buffer-string)) ))
  (save-current-buffer
    (emuds-select-buffer-window 'cbuf)
    (setq buffer-read-only nil)
    (goto-char (point-max))
    (insert (concat string "\n"))
    (goto-char (point-max))
    (emuds-center-buffer-window 'cbuf)
    (setq buffer-read-only t)
    (emuds-select-buffer-window 'ibuf) ))

(defun emuds-channel-catch ()
  "catch chatting spam"
  (let ((ms (match-string 1)))
    (replace-match "")
    (emuds-channel-display ms) ))

(defun /channel (&optional match)
  "move chatting spam"
  (if (stringp match)
      (emuds-def 'emuds-user-chain
	     (cons (concat "^\\(" match "\\)$")
	      (cons 'emuds-channel-catch nil)))
    (set 'emuds-user-chain nil)))

(defun /gag (player) "gag a player" (interactive "sPlayer:")
  (push player emuds-channel-gag))

(message "detaching chat window")
(emuds-channel-detach)