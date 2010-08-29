;;; setup Tubmud MUD
;;;
;;; Tubmud is a english speaking MUD hosted in Germany
;;;
;;; settings:
;;;   have not figured out how to disable the pager/more in this MUD

(emuds-setup-request-eor)  ; request EOR prompt marks
(/load "emuds-movement")   ; movement
(/load "emuds-channel")

;;; it looked to me, as if this MUD does not provide OOC - so I dont
;;; need to channel it into a different window.

; (/channel)
; (/channel "[[][^ ]*:[^ ]*[]].*")
