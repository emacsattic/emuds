;;; setup Wunderland
;;;
;;; Wunderland is a german Morgengrauen MUD
;;;
;;; settings:
;;;   zeilen 0

(emuds-setup-request-eor)  ; request EOR prompt marks
(/load "emuds-bewegung")   ; german movement
(/load "emuds-channel")

(/channel)
(/channel "[[][^ ]*:[^ ]*[]].*")
