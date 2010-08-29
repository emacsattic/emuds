;;; This is an example file to setup Realm of Magic

;;; RoM is my home MUD - so there are lots of examples, you might use
;;; to setup triggers and hotkeys for your home MUD.

(emuds-setup-support-ga)	        ; setup for Realm of Magic
(/trigger)	                        ; reset all triggers
(/mapkey)                               ; reset all keys

(/load "rom-basics")   ; load basics
(/load "rom-channel")  ; load the channel splitscreen for OOC chats

;; F1 unused 
(/mapkey [f2]  '/group-key)
(/mapkey [f3]  '/loot-key)
(/mapkey [f4]  '/sacr-key)
(/mapkey [f5]  '/kill-key)
(/mapkey [f6]  '/assist-key)
;; F7 unused
;; F8 used by /cast and /throw commands
(/mapkey [f9]  '/healing-key)
(/mapkey [f10] '/healass-key)
;; F11 unused 
;; F12 unused
