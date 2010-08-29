(/load "emuds-channel")

(/channel "[A-Z][A-Za-z ]* gossips, '.*'")
(/channel "You gossip, '.*'")
(/channel "[A-Z][A-Za-z ]* quest-says, '.*'")
(/channel "You quest-say, '.*'")
(/channel "[A-Z][A-Za-z ]*([A-Z]+) says, '.*'")
(/channel "You ([A-Z]+) say, '.*'")

(message "split chat window")
