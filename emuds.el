;;; emuds.el (c) GPL 2001 kraehe(at)copyleft.de
;;; ---------------------------------------------------------------------------

;;; License: GPL

(require 'cl)

(defvar emuds-world nil "current world and its properties")
(defvar emuds-worlds nil "assoc of worlds hosts and ports")
(defvar emuds-keymap nil "keymap of the current world")
(defvar emuds-sys-chain nil "first chain of triggers to process")
(defvar emuds-prompt-chain nil "second chain of triggers to process")
(defvar emuds-once-chain nil "third chain of triggers to process")
(defvar emuds-user-chain nil "last chain of triggers to process")
(defvar emuds-queue nil "queue of commands to send to and eMUDs session")
(defvar emuds-logs "~/.emuds-logs/" "emuds logfiles")
(defvar emuds-maps "~/.emuds-maps/" "emuds mapfiles")
(defvar emuds-db "~/.emuds-db" "emuds database")
(defvar emuds-frame-alist nil "prefered w h x y geometry")
(defvar emuds-pass nil "emuds password")
(defvar emuds-enter-string "\r\n" "emuds cr/lf combo")
(defvar emuds-prompt-replace "" "replace string for prompt")
(defvar emuds-command-slash "/" "prefix for /commands")
(defvar emuds-command-dot nil "prefix for .commands")
(defvar emuds-command-split ";" "command split char")

;;; ---------------------------------------------------------------------------

(defun emuds-def (list val) "append or change value in emuds-assoc list"
  (let ((x (assoc (car val) (eval list))))
    (if x (setcdr x (cdr val)) 
      (set list (nconc (eval list) (list val))) )))

;;; ---------------------------------------------------------------------------
;;; Handling of the emuds-worlds assoc, and the emuds-world plist

(defun emuds-ask-world () "ask for a World"
  (setq emuds-world (completing-read "World:" emuds-worlds nil t ""))
  (let ((worlds (assoc emuds-world emuds-worlds)))
    (setplist 'emuds-world ())
    (put 'emuds-world 'name (car worlds))
    (put 'emuds-world 'host (nth 1 worlds))
    (put 'emuds-world 'port (nth 2 worlds)) ))

;;; ---------------------------------------------------------------------------

(defun emuds-send-raw (string) "send a string to the eMUDs session"
  (process-send-string (get 'emuds-world 'proc) string))

(defun emuds-buffer-window (buf) "retrieve buffer-window"
  (get-buffer-window (get 'emuds-world buf) (get 'emuds-world 'gfrm)))

(defun emuds-select-buffer-window (buf) "select buffer-window"
  (let ((bw (emuds-buffer-window buf)))
    (when bw (select-window bw)))
  (set-buffer (get 'emuds-world buf)) )

(defun emuds-center-buffer-window (buf) "recenter buffer-window"
  (let ((bw (emuds-buffer-window buf)))
    (when bw (select-window bw)
	  (recenter (- (window-height (selected-window)) 2)) )))

(defun emuds-display-output (string) "display output to screen"
  (save-current-buffer
    (emuds-select-buffer-window 'obuf)
    (setq buffer-read-only nil)
    (goto-char (point-max))
    (insert string)
    (goto-char (point-max))
    (set-marker (process-mark (get 'emuds-world 'proc)) (point))
    (emuds-center-buffer-window 'obuf)
    (setq buffer-read-only t)
    (emuds-select-buffer-window 'ibuf) ))

(defun emuds-send (line) "send a line to the eMUDs session"
  (interactive "sLine: ")
  (if (get 'emuds-world 'echo) (emuds-display-output (concat line "\n"))
    (emuds-display-output "\n"))
  (emuds-send-raw (concat line emuds-enter-string)) )

(defun emuds-interprete-eval (&rest strings) "evaluate a command line"
  (with-temp-buffer (insert (eval (cons 'concat strings)))
		    (eval-current-buffer) ))

(defun emuds-interprete (line) "interprete a line"
  (if (= (length line) 0) ""
    (let ((tag (substring line 0 1)))
      (cond
       ((string= tag "(") (emuds-interprete-eval line) nil)
       ((string= tag "/") (emuds-interprete-eval "(" line ")") nil)
       ((string= tag emuds-command-dot) (/dopath line) nil)
       (t line) ))))

(defun emuds-interprete-send (line) "interprete a line to send"
  (let ((send (emuds-interprete line)))
    (when send (/send send))))

(defun emuds-interprete-queue (line) "interprete a line to queue"
  (let ((queue (emuds-interprete line))) (when queue (/queue queue))))

(defun emuds-send-input () "send input to the session.
                            this function is maped to the return key"
  (interactive)
  (let (beg end mk line)
    (emuds-select-buffer-window 'ibuf)
    (end-of-line) (setq end (point))
    (beginning-of-line) (setq beg (point))
    (setq mk (next-single-property-change (point) 'read-only))
    (unless mk (setq mk end))
    (setq line (buffer-substring mk end))
    (goto-char (point-max))
    (beginning-of-line) (setq beg (point))
    (setq mk (next-single-property-change (point) 'read-only))
    (when mk
      (let ((inhibit-read-only t))
	(end-of-line)
	(newline)))
    (emuds-replace-prompt)
    (emuds-interprete-send line) ))

;;; ---------------------------------------------------------------------------

(defun emuds-eval-trigger (chain) "evalute a chain of triggers."
  (dolist (hook chain)
    (goto-char (point-min))
    (while (re-search-forward (car hook) nil t) (eval (cdr hook))) ))

(defvar emuds-overflow nil "string to store overflow from process imput")

(defun emuds-filter-output (proc string)
  "filter output of the process. this is doing the main processing."
  (save-selected-window
    (let ((old-prompt (get 'emuds-world 'prompt))
	  (tpoint))
      (put 'emuds-world 'prompt nil)
      (put 'emuds-world 'processing t)
      (with-temp-buffer
	(when (stringp emuds-overflow)
	  (insert emuds-overflow)
	  (setq emuds-overflow nil))
	(setq tpoint (point))
	(insert string)
	(when emuds-color
	  (put-text-property tpoint (point-max) 'face emuds-color) )
	(emuds-eval-trigger emuds-sys-chain)
	(emuds-telnet-unblock)
	(emuds-eval-trigger emuds-once-chain)
	(emuds-eval-trigger emuds-user-chain)
	(goto-char (point-min))
	(when (re-search-forward "[^ \t\r\n]" nil t)
	  (emuds-display-output (buffer-string)) ))
      (put 'emuds-world 'processing nil)
      (when (and (or
		  (get 'emuds-world 'prompt-broken)
		  (get 'emuds-world 'first-prompt))
		 (not (get 'emuds-world 'prompt)))
	(unless old-prompt (setq old-prompt "~"))
	(emuds-set-prompt old-prompt)
	(put 'emuds-world 'first-prompt nil))
      (emuds-dequeue))))

(defun emuds-sentinel ( process msg )
  "sentinel for eMUDs process"
  (emuds-display-output "\nSentinel: Quit!\n")
  (emuds-quit))

;;; ---------------------------------------------------------------------------
;;; telnet IAC options for prompt handling

(defun emuds-iac-reply (string) "iac reply"
  ( replace-match "" )
  ( emuds-send-raw string ))

(defun emuds-telnet-echo (flag)
  "turns echo on/off for password entry"
  (put 'emuds-world 'echo flag)
  (replace-match ""))

(defun emuds-telnet-unblock ()
  "catch the telnet overflow"
  (let (beg end)
    (goto-char (point-max)) (setq end (point))
    (beginning-of-line) (setq beg (point))
    (unless (equal beg end)
      (setq emuds-overflow (buffer-substring beg end))
      (delete-region beg end)
      (when (get 'emuds-world 'prompt-broken)
	(emuds-set-prompt emuds-overflow) ))))

(defun emuds-telnet-prompt ()
  "catch the prompt"
  (save-current-buffer
    (let (prompt beg end ro)
      (replace-match "")
      (beginning-of-line)
      (setq beg (point))
      (setq end (match-beginning 0))
      (setq prompt (buffer-substring beg end))
      (put 'emuds-world 'prompt prompt)
      (delete-region beg end)
      (emuds-set-prompt prompt) )))

(defun emuds-set-prompt (prompt) "set the prompt"
  (put 'emuds-world 'prompt prompt)
  (emuds-replace-prompt))

(defun emuds-replace-prompt () "replace the prompt"
  (save-current-buffer
    (emuds-select-buffer-window 'ibuf)
    (save-excursion
      (let (l b p)
	(goto-char (point-max))
	(beginning-of-line)
	(setq l (next-single-property-change (point) 'read-only))
	(unless l (setq l (point-max)))
	(let ((inhibit-read-only t))
	  (remove-text-properties (point) l '(read-only))
	  (delete-region (point) l)
	  (beginning-of-line)
	  (setq b (point))
	  (setq p (get 'emuds-world 'prompt))
	  (unless p (setq p "~"))
	  (insert p)
	  (put-text-property b (point) 'rear-nonsticky t)
;	(put-text-property b (point) 'face 'emuds-white-black)
	  (put-text-property b (point) 'read-only t)
	  (put-text-property b (point) 'intangible t))))
    (goto-char (point-max)) ))

(defun emuds-iac-reply (reply)
  (let ((ms (match-string 1)))
    (replace-match "")
    (emuds-send-raw (concat reply ms))))

(defun emuds-terminal-type ()
  (replace-match "")
  (message "told naws")
  (emuds-send-raw "\377\372\030\000eMUDs\377\360"))

(defun emuds-terminal-naws ()
  (replace-match "")
  (message "told naws")
  (emuds-send-raw "\377\373\037")
  (emuds-send-raw "\377\372\037\000\120\375\350\377\360"))

(defface emuds-white-black
  '((t (:background "white" :foreground "black"))) "black" )
(defface emuds-white-red
  '((t (:background "white" :foreground "red"))) "red" )
(defface emuds-white-green
  '((t (:background "white" :foreground "green"))) "green" )
(defface emuds-white-yellow
  '((t (:background "white" :foreground "yellow"))) "yellow" )
(defface emuds-white-blue
  '((t (:background "white" :foreground "blue"))) "blue" )
(defface emuds-white-magenta
  '((t (:background "white" :foreground "magenta"))) "magenta" )
(defface emuds-white-cyan
  '((t (:background "white" :foreground "cyan"))) "cyan" )
(defface emuds-black-red
  '((t (:background "black" :foreground "red"))) "red" )
(defface emuds-black-green
  '((t (:background "black" :foreground "green"))) "green" )
(defface emuds-black-yellow
  '((t (:background "black" :foreground "yellow"))) "yellow" )
(defface emuds-black-blue
  '((t (:background "black" :foreground "blue"))) "blue" )
(defface emuds-black-magenta
  '((t (:background "black" :foreground "magenta"))) "magenta" )
(defface emuds-black-cyan
  '((t (:background "black" :foreground "cyan"))) "cyan" )
(defface emuds-black-white
  '((t (:background "black" :foreground "white"))) "white" )

(defvar emuds-color 'emuds-black-white "current color")

(defun emuds-ansi-color () "process color"
  (if emuds-color
      (let ((ms (match-string 1))
	    (p (match-beginning 0)) 
	    (q nil))
   	(replace-match "")
	(when (string= ms "") (setq ms "0"))
	(dolist (msi (split-string ms ";"))
	  (cond
	   ((string= msi "30") (setq emuds-color 'emuds-black-white))
	   ((string= msi "31") (setq emuds-color 'emuds-black-red))
	   ((string= msi "32") (setq emuds-color 'emuds-black-green))
	   ((string= msi "33") (setq emuds-color 'emuds-black-yellow))
	   ((string= msi "34") (setq emuds-color 'emuds-black-blue))
	   ((string= msi "35") (setq emuds-color 'emuds-black-magenta))
	   ((string= msi "36") (setq emuds-color 'emuds-black-cyan))
	   ((string= msi "37") (setq emuds-color 'emuds-black-white))
	   ((string= msi "0") (setq emuds-color 'emuds-black-white))
	   ;; (t (setq emuds-color 'emuds-black-white))
	   ))
	(goto-char p)
	(setq q (search-forward "\033" nil t))
	(if q (setq q (- q 1))
	  (setq q (point-max)) )
	(put-text-property p q 'face emuds-color)
	(goto-char q))
    (replace-match "") ))

(defun emuds-set-color () "set color"
  (if emuds-color
      (modify-frame-parameters
       (get 'emuds-world 'gfrm)
       (list (cons 'background-color "black")
	     (cons 'foreground-color "white")
	     (cons 'cursor-color "coral")
	     (cons 'mouse-color "coral")))
    (modify-frame-parameters
     (get 'emuds-world 'gfrm)
     (list (cons 'background-color "white")
	   (cons 'foreground-color "black")
	   (cons 'cursor-color "coral")
	   (cons 'mouse-color "coral")))))

;;; ---------------------------------------------------------------------------
;;; setup/quit for streams, buffers, windows and keymap

(defun emuds-setup-broken ()
  "setup dumb telnet"
  (interactive)
  (setq emuds-sys-chain ())

  (push '( "\377\361" replace-match ""  ) emuds-sys-chain )
  (push '( "\377\357" emuds-telnet-prompt ) emuds-sys-chain )
  (push '( "\377\371" emuds-telnet-prompt ) emuds-sys-chain )
  (push '( "\377\373." replace-match ""  ) emuds-sys-chain )
  (push '( "\377\374." replace-match ""  ) emuds-sys-chain )
  (push '( "\377\375." replace-match ""  ) emuds-sys-chain )
  (push '( "\377\376." replace-match ""  ) emuds-sys-chain )
  (push '( "\377\373\001" emuds-telnet-echo nil ) emuds-sys-chain )
  (push '( "\377\374\001" emuds-telnet-echo t ) emuds-sys-chain )
  (push '( "[\000\007\r]+" replace-match "" ) emuds-sys-chain )
  (push '( "\033\\[\\([0-9;]*\\)[JHm]" emuds-ansi-color ) emuds-sys-chain )

  (put 'emuds-world 'first-prompt nil)
  (put 'emuds-world 'prompt-broken t)
  (setq emuds-enter-string "\r\n") )


(defun emuds-setup-sys-chain ()
  "setup telnet system chain"

  ;; the last in the list - the top of stack - is processed first

  (push '( "\377\371" emuds-telnet-prompt ) emuds-sys-chain )
  (push '( "\377\357" emuds-telnet-prompt ) emuds-sys-chain )

  (push '( "[\000\007\r]+" replace-match "" ) emuds-sys-chain )
  (push '( "\033\\[\\([0-9;]*\\)[JHm]" emuds-ansi-color ) emuds-sys-chain )

  (push '( "\377\361" replace-match ""  ) emuds-sys-chain )
  (push '( "\377\373\\(.\\)" emuds-iac-reply "\377\376"  ) emuds-sys-chain )
  (push '( "\377\374." replace-match ""  ) emuds-sys-chain )
  (push '( "\377\375\\(.\\)" emuds-iac-reply "\377\374"  ) emuds-sys-chain )
  (push '( "\377\376." replace-match ""  ) emuds-sys-chain )

  (push '( "\377\375\\(\037\\)" emuds-terminal-naws ) emuds-sys-chain )
  (push '( "\377\375\\(\030\\)" emuds-iac-reply "\377\373" ) emuds-sys-chain )
  (push '( "\377\372\030\001\377\360" emuds-terminal-type ) emuds-sys-chain )

  (push '( "\377\373\031" replace-match ""  ) emuds-sys-chain )
  (push '( "\377\375\031" replace-match ""  ) emuds-sys-chain )
  (push '( "\377\373\001" emuds-telnet-echo nil ) emuds-sys-chain )
  (push '( "\377\374\001" emuds-telnet-echo t ) emuds-sys-chain ) )

(defun emuds-setup-request-ga ()
  "setup telnet to request GA"
  (interactive)
  (setq emuds-sys-chain ())
  (emuds-setup-sys-chain)
  (put 'emuds-world 'first-prompt t)
  (put 'emuds-world 'prompt-broken nil)
  (emuds-send-raw "\377\374\003")
  (emuds-send-raw "\377\376\003")
  (setq emuds-enter-string "\r\n") )

(defun emuds-setup-request-eor ()
  "setup telnet to request EOR"
  (interactive)
  (setq emuds-sys-chain ())
  (emuds-setup-sys-chain)
  (put 'emuds-world 'first-prompt t)
  (put 'emuds-world 'prompt-broken nil)
  (emuds-send-raw "\377\375\031")
  (setq emuds-enter-string "\r\n") )

(defun emuds-setup-support-ga ()
  "setup eMUDs (prefered) MUD telnet"
  (interactive)
  (setq emuds-sys-chain ())
  (emuds-setup-sys-chain)
  (put 'emuds-world 'first-prompt nil)
  (put 'emuds-world 'prompt-broken nil)
  (setq emuds-enter-string "\r\n") )

(defun emuds-setup-support-ga-first-prompt ()
  "setup eMUDs MUD telnet"
  (interactive)
  (setq emuds-sys-chain ())
  (emuds-setup-sys-chain)
  (put 'emuds-world 'first-prompt t)
  (put 'emuds-world 'prompt-broken nil)
  (setq emuds-enter-string "\r\n") )

(defun emuds-setup-debug ()
  "setup eMUDs session in debug mode"
  (interactive)
  (setq emuds-sys-chain ())
  (put 'emuds-world 'prompt-broken t)
  (push '( "\000" replace-match "<BINARY>" ) emuds-sys-chain )
  (push '( "\001" replace-match "<ECHO_OPTION>" ) emuds-sys-chain )
  (push '( "\003" replace-match "<SUPPRESS_GA>" ) emuds-sys-chain )
  (push '( "\006" replace-match "<TIMING_MARK>" ) emuds-sys-chain )
  (push '( "\007" replace-match "<BEEP>" ) emuds-sys-chain )
  (push '( "\r" replace-match "<CR>" ) emuds-sys-chain )
  (push '( "\030" replace-match "<TERMINAL_TYPE>" ) emuds-sys-chain )
  (push '( "\031" replace-match "<TELOPT_EOR>" ) emuds-sys-chain )
  (push '( "\201" replace-match "<201>" ) emuds-sys-chain )
  (push '( "\357" replace-match "<EOR_MARK>" ) emuds-sys-chain )
  (push '( "\360" replace-match "<SE>" ) emuds-sys-chain )
  (push '( "\361" replace-match "<NOP>" ) emuds-sys-chain )
  (push '( "\362" replace-match "<DATA_MARK>" ) emuds-sys-chain )
  (push '( "\363" replace-match "<BRK>" ) emuds-sys-chain )
  (push '( "\364" replace-match "<IP>" ) emuds-sys-chain )
  (push '( "\365" replace-match "<AO>" ) emuds-sys-chain )
  (push '( "\366" replace-match "<AYT>" ) emuds-sys-chain )
  (push '( "\367" replace-match "<EC>" ) emuds-sys-chain )
  (push '( "\370" replace-match "<EL>" ) emuds-sys-chain )
  (push '( "\371" replace-match "<GA>" ) emuds-sys-chain )
  (push '( "\372" replace-match "<SB>" ) emuds-sys-chain )
  (push '( "\373" replace-match "<WILL>" ) emuds-sys-chain )
  (push '( "\374" replace-match "<WONT>" ) emuds-sys-chain )
  (push '( "\375" replace-match "<DO>" ) emuds-sys-chain )
  (push '( "\376" replace-match "<DONT>" ) emuds-sys-chain )
  (push '( "\377" replace-match "<IAC>" ) emuds-sys-chain )  )

(defun emuds-setup ()
  "Setup the eMUDs streams and buffers"

  (emuds-quit)
  (emuds-ask-world)

  (message "Connect to %s on %s:%d" emuds-world
	   (get 'emuds-world 'host)
	   (get 'emuds-world 'port))

  (put 'emuds-world 'file
       (format "%s-%s-output-%d"
	       emuds-world
	       (format-time-string "%Y-%m-%d")
	       (emacs-pid) ))

  (unless (and (get 'emuds-world 'gfrm)
  	       (frame-live-p (get 'emuds-world 'gfrm)))
     (if emuds-frame-alist
	 (put 'emuds-world 'gfrm (make-frame emuds-frame-alist))
       (put 'emuds-world 'gfrm (make-frame))))
  (select-frame (get 'emuds-world 'gfrm))
  (delete-other-windows)

  (put 'emuds-world 'obuf (get-buffer-create (get 'emuds-world 'file)))
  (set-window-buffer (selected-window) (get 'emuds-world 'obuf))
  (set-buffer (get 'emuds-world 'obuf))
  (set-visited-file-name (concat emuds-logs (get 'emuds-world 'file)))

  (setq emuds-sys-chain ())
  (setq emuds-once-chain ())
  (setq emuds-user-chain ())
  (setq emuds-queue ())

  (if (put 'emuds-world 'proc
	   (open-network-stream
	    (concat emuds-world "-proc")
	    (get 'emuds-world 'obuf)
	    (get 'emuds-world 'host)
	    (get 'emuds-world 'port)))
      (progn
	(goto-char (point-min))
	(set-marker (process-mark (get 'emuds-world 'proc)) (point))
	(set-process-filter (get 'emuds-world 'proc) 'emuds-filter-output)
	(set-process-sentinel (get 'emuds-world 'proc) 'emuds-sentinel)

	(put 'emuds-world 'ibuf
	     (get-buffer-create (concat emuds-world "-input")))
	(set-window-buffer
	 (split-window
	  (selected-window) (- (window-height (selected-window)) 5) )
	 (concat emuds-world "-input"))
	(emuds-select-buffer-window 'ibuf)
	(goto-char (point-max)) (emuds-set-prompt "~")
	(put 'emuds-world 'echo t)))

  (/reload)

  (when (and emuds-pass (file-exists-p emuds-pass))
    (message "loading emuds-pass")
    (load emuds-pass t nil)
    (dolist (q (cdr (assoc emuds-world emuds-login)))
      (message q)
      (/queue q) )))

;;; ---------------------------------------------------------------------------

(defun emuds-quit ()
  "close streams, buffers, windows and frames"
  (message "emuds-quit")

  (when (get 'emuds-world 'obuf)
    (set-buffer (get 'emuds-world 'obuf))
    (setq buffer-read-only nil)
    (when emuds-logs
      (let ((bkup make-backup-files))
	(setq make-backup-files nil)
	(save-buffer)
	(setq make-backup-files bkup) ))
    (setq buffer-read-only t))

  (when (get 'emuds-world 'proc)
    (delete-process (get 'emuds-world 'proc))
    (put 'emuds-world 'proc nil)
    (kill-buffer (get 'emuds-world 'ibuf))
    (if (get 'emuds-world 'gfrm) (delete-frame (get 'emuds-world 'gfrm))))
  (setplist 'emuds-world ())
  (setq emuds-world nil))

(defun emuds-dequeue ()
  "dequeue next command at prompt"
  (when (and (car emuds-queue)
	     (get 'emuds-world 'prompt)
	     (not (get 'emuds-world 'processing)) )
    (emuds-display-output (get 'emuds-world 'prompt))
    (emuds-send (car emuds-queue))
    (setq emuds-queue (cdr emuds-queue))
    (put 'emuds-world 'prompt nil)))

;;; ---------------------------------------------------------------------------

(defun /addworld (name host port) "add or update world."
  (interactive "sName: \nsHost: \nnPort: ")
  (emuds-def 'emuds-worlds (list name host port)) )

(defun /load (mod) "load a world definition"
  (interactive "sModule:")
  (load mod t nil) )

(defun /reload () "reload your world definition"
  (interactive)
  (message "reload")
  (/mapkey)
  (/trigger)
  (/once)
  (unless (/load (concat "world-" emuds-world)) (emuds-setup-debug) )
  (emuds-set-color) )

(defun /send (line) "send a line with prompt"
  (interactive "sLine:")
  (if (get 'emuds-world 'prompt)
      (progn
	(emuds-display-output (get 'emuds-world 'prompt))
	(emuds-send line) )
    (emuds-display-output "~")
    (emuds-send line) ))

(defun /queue (&rest lines) "enqueue commands to be used at next prompt"
  (setq emuds-queue (append emuds-queue lines))
  (emuds-dequeue) )

(defun /quote () "quote a buffer" (interactive)
  (untabify (point-min) (point-max))
  (set-buffer (current-buffer))
  (dolist (quote (split-string (buffer-string) "[\r\n]"))
    (/queue quote) ))
(defun /paste (p m) "paste a region" (interactive "r")
  (when (< p m)
    (untabify p m)
    (dolist (quote (split-string (buffer-substring p m) "[\r\n]"))
      (/queue quote) )))

(defun /mapkey (&optional key func) "map a key for eMUDs input window"
  (interactive)
  (save-current-buffer
    (emuds-select-buffer-window 'ibuf)
    (if (or (stringp key) (vectorp key))
	(emuds-def 'emuds-keymap (list key func))
      (setq emuds-keymap nil) )
    (let (keymap)
      (setq keymap (make-keymap))
      (define-key keymap "\r" 'emuds-send-input)
      (dolist (map emuds-keymap)
	(define-key keymap (car map) (cadr map)) )
      (use-local-map (copy-keymap keymap)) )))

(defun /chain (chain &optional expr func &rest args) "add a trigger"
  (if (stringp expr)
      (emuds-def chain (cons expr (cons func args)))
    (set chain nil) ))
(defun /trigger (&optional expr func &rest args) "add a trigger"
  (if (stringp expr)
      (emuds-def 'emuds-user-chain (cons expr (cons func args)))
    (set 'emuds-user-chain nil) ))
(defun /once (&optional expr func &rest args) "define a trigger in once chain"
  (if (stringp expr)
      (emuds-def 'emuds-once-chain (cons expr (cons func args)))
    (set 'emuds-once-chain nil) ))
(defun /prompt (&optional expr func &rest args)
  (if (stringp expr)
      (emuds-def 'emuds-prompt-chain (cons expr (cons func args)))
    (set 'emuds-prompt-chain nil) ))

(defun /color () "toggle color" (interactive)
  (if emuds-color
      (progn
	(setq emuds-color nil)
	(emuds-set-color)
	(message "color off") )
    (setq emuds-color 'emuds-black-white)
    (emuds-set-color)
    (message "color on") ))

(defun /debug () "debug next error" (interactive)
  (setq debug-on-error t)  )

(defun /stop () "stop running wild" (interactive)
  (/once)
  (/trigger)
  (setq emuds-queue ()))

(defun /emuds () "Start up an eMUDs session" (interactive) (emuds-setup))
(defun /quit () "Kill an eMUDs session" (interactive) (emuds-quit))

;;; ---------------------------------------------------------------------------

(provide '/emuds)
(provide '/addworld)
