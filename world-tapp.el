;;; setup Tapp MUD
;;;
;;; Tapp is a english speaking MUD hosted in Germany
;;;
;;; settings:
;;;   have not figured out how to disable the pager/more in this MUD

(emuds-setup-request-eor)  ; request EOR prompt marks
(/load "emuds-movement")   ; movement
(/load "emuds-channel")

(/channel)
(/channel "[[][^ ]*:[^ ]*[]].*")
