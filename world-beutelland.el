;;; setup Beutelland
;;;
;;; A german MUD with a furry theme, in a bug ridden experimental state.
;;;
;;; setting:
;;;    zeilen 0 - does not work *oups* first bug on login
;;;    zeilen 100 - will throw you out of the MUD if typing help
;;;

(emuds-setup-request-eor)  ; request EOR prompt marks
(/load "emuds-bewegung")   ; german movement
(/load "emuds-channel")

(/channel)
(/channel "[[][^ ]*:[^ ]*[]].*")
