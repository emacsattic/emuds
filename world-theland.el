;;; setup The Land
;;;   an english speaking MUD in germany.
;;;   a development and research LP MUD connected to 3 networks.
;;;   its as silent as an irc room with a half a dozen chatters.
;;;
;;; settings:
;;;   

(emuds-setup-support-ga)  ; request EOR prompt marks
(/load "emuds-movement")  ; english movement
(/load "emuds-channel")

(/channel)
(/channel "[[][^ ]*:[^ ]*[]].*")
