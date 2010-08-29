;;; setup Anderland
;;;
;;; Anderland is a german MUD - take care, even the commands are german,
;;; like "schau", "nimm", "sag", ... but "quit" is accepted in english ;)
;;; The mud is connected to intermud

(emuds-setup-request-eor)  ; request EOR prompt marks
(/load "emuds-bewegung")   ; german movement
(/load "emuds-channel")

(/channel)
(/channel "[[][^ ]*:[^ ]*[]].*")
