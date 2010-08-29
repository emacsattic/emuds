;;; use staff and wands

(defvar rom-staff nil "staff item")
(defvar rom-wand  nil "wand item")

(defun staff-key () "attack with staff" (interactive)
  (/send (concat "get " rom-staff " " /bag))
  (when /hold (/queue (concat "remove " /hold )))
  (/queue (concat "hold " rom-staff )
        (concat "use " rom-staff )
        (concat "remove " rom-staff )
        (concat "put " rom-staff " " /bag)
	)
  (when /hold (/queue (concat "hold " /hold )))
  )
(defun /staff (item) "define attack staff"
  (interactive "sItem:")
  (/mapkey [f8] 'staff-key)
  (setq rom-staff item)
  )

(defun wand-key () "attack with wand" (interactive)
  (/send (concat "get " rom-wand " " /bag))
  (when /hold (/queue (concat "remove " /hold )))
  (/queue (concat "hold " rom-wand )
        (concat "use " rom-wand " " /victim)
        (concat "remove " rom-wand )
        (concat "put " rom-wand " " /bag) )
  (when /hold (/queue (concat "hold " /hold ))) )

(defun /wand (item) "define wand"
  (interactive "sItem:")
  (/mapkey [f8] 'wand-key)
  (setq rom-wand item)
  )

(defun wand3-key () "attack with wand" (interactive)
  (/send (concat "get " rom-wand " " /bag))
  (when /hold (/queue (concat "remove " /hold )))
  (/queue (concat "hold " rom-wand )
        (concat "use " rom-wand " " /victim)
        (concat "use " rom-wand " " /victim)
        (concat "use " rom-wand " " /victim)
        (concat "remove " rom-wand )
        (concat "junk " rom-wand )
	)
  (when /hold (/queue (concat "hold " /hold )))
  )

(defun /wand3 (item) "define tripple attack wand"
  (interactive "sItem:")
  (/mapkey [f8] 'wand3-key)
  (setq rom-wand item)
  )

(defun /recharge (item) "recharge an item" (interactive "sItem:")
  (/queue (concat "get " item " " /bag )
	  (concat "cast 'recharge' " item )
	  (concat "put " item " " /bag )
	  )
  )

(defun /peels () "peels staff" (interactive) (/staff "peels"))
(defun /flute () "flute staff" (interactive) (/staff "flute"))
(defun /golden () "golden wand" (interactive) (/staff "golden"))
(defun /celtic () "celtic wand" (interactive) (/wand "celtic"))
(defun /glove () "celtic wand" (interactive) (/wand "glove"))

(defun /spray3 () "can of spray paint" (interactive) (/wand3 "spray"))
(defun /aura3 () "digging aura" (interactive) (/wand3 "aura"))

(defun /spray () "can of spray paint" (interactive) (/wand "spray"))
(defun /aura () "digging aura" (interactive) (/wand "aura"))
