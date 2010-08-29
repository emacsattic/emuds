;;; DiscWorld - eMUDs configuration
;;;
;;; Based on the well know Discworld Theme
;;;
;;; technix:
;;;    the mud needs an IAC DONT SGA to support IAC GA prompts
;;;    prompts are not available during character generation
;;;    the MUD is buggy as hell and crashing regulary
;;;    creators ignore bug reports
;;; 
;;; settings:
;;;    options terminal rows=999999
;;;    options terminal rows=999
;;;    options terminal type=ansi 
;;;
;;; comments:
;;;    + newbie friendly mud
;;;    + exploring gives experience

(emuds-setup-request-ga) ; setup to request IAC GA prompts

(/load "emuds-movement") ; load basic movement
(/load "emuds-channel")  ; load the channel splitscreen for OOC chats

(/channel "[(A-Z][A-Za-z )]* wisps: .*\\(\n     .*\\)*")
(/channel "[(A-Z][A-Za-z )]* wisps that he .*\\(\n     .*\\)*")
(/channel "[(A-Z][A-Za-z )]* wisps that she .*\\(\n     .*\\)*")
(/channel "(newbie) .*: .*\\(\n     .*\\)*")
(/channel "(rtfm).*\\(\n     .*\\)*")
(/channel "(kcc).*\\(\n     .*\\)*")
(/channel "(Tshop Spotters).*\\(\n     .*\\)*")
(/channel "(Quaternion).*\\(\n     .*\\)*")

(message "loaded DiscWorld MUD")
