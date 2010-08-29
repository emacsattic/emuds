;;; Abandoned Reality
;;;
;;; A uniq MUD that distincts strictly between OOC and IC
;;;
;;; Players can have one out of game character and several in game
;;; characters per account. A Diku/Envy based MUD far from stock.
;;;
;;; settings:
;;;   its not possible to disable the more prompt in this mud

(emuds-setup-request-eor)               ; request EOR prompt marks
(/trigger)                              ; reset all triggers
(/mapkey)                               ; reset all keys

(/load "emuds-movement")