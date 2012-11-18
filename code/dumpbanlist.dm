//This could just as easily be deleted.  I originally wrote it to dump the ban lists from the pregoon system into a MySQL-friendly format -Sukasa

mob/verb/dumpbans()
	Banlist = new("data/banlist.bdb")
	log_admin("Loading Banlist")

	if (!length(Banlist.dir)) log_admin("Banlist is empty.")

	if (!Banlist.dir.Find("base"))
		log_admin("Banlist missing base dir.")
		Banlist.dir.Add("base")
		Banlist.cd = "/base"
	else if (Banlist.dir.Find("base"))
		Banlist.cd = "/base"
	var/file = file("bans.txt")
	var/dat = ""
	for (var/X in Banlist)
		Banlist.cd = "/base/[X]"

		var/reason = dbcon.Quote("[Banlist["reason"]]")
		dat += "INSERT INTO `bans` VALUES('[Banlist["key"]', '[Banlist["id"]]', [reason], '[Banlist["bannedby"]]', '[Banlist["temp"]]', '[Banlist["minutes"]]');\n"

	file << dat
	usr << "DONE"
