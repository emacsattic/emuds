;;; Ishar
;;;
;;; setting :
;;;    display paged          ; to turn off more prompts

(emuds-setup-request-eor)
(/load "emuds-movement")

;;; Ishar is using Windoof character set

(/trigger "[������]" 'replace-match "+" )
(/trigger "�" 'replace-match "-" )
(/trigger "�" 'replace-match "|" )