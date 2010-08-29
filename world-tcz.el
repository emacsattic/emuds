;;; TCZ is an unusual MUD
;;;
;;; New players start in their own room. They start as newbie
;;; builders with a quota of 10 points to define themself and
;;; their home as they like.
;;;
;;; The first raise in quota only needs a chat with apprentice
;;; Wizard, Druid or higher level. But further raises in quota
;;; require to build something nice for the chatting zone.
;;;
;;; Quota is limited, so people hang around to chat or to
;;; explore what others created or improve their work.
;;;
;;; TCZ needs the following configuration :

(emuds-setup-request-eor)        ;;; request EOR prompt marks
(setq emuds-command-dot ",")     ;;; TCZ needs the .

