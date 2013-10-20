//Blocks an attempt to connect before even creating our client datum thing.

world/IsBanned(key,address,computer_id)
	//Guest Checking
	if(IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("Failed Login: [key] - Guests not allowed")
		return list("reason"="guest", "desc"="\nReason: White is so great, BYOND account is not required, right?")

	//whitelist
//	if(!check_bwhitelist(ckey(key)))
//		return list("reason"="not in whitelist", "desc"="\nYou are not in whitelist.\nGo to forum: http://forum.ss13.ru/index.php?showforum=48")

	//Ban Checking
	var/ban = NewCheckBan(key, computer_id, address)
	if(istype(ban, /list))
		log_access("Failed Login: [key] [computer_id] [address] - Banned [ban["reason"]]")
		message_admins("Failed Login: [key] id:[computer_id] ip:[address] - Banned [ban["reason"]]")
		return ban

	return ..()	//default pager ban stuff

/proc/NewCheckBan(var/key, var/id = 0, var/address = 0)
	var/DBQuery/q1 = dbcon.NewQuery("SELECT * FROM `bans` WHERE computerid='[id]'")
	var/DBQuery/q2 = dbcon.NewQuery("SELECT * FROM `bans` WHERE ckey='[key]'")
	var/DBQuery/q3 = dbcon.NewQuery("SELECT * FROM `bans` WHERE ips='[address]'")
	var/list/ban = list()
	var/list/returnban = list()

	if(!q2.Execute())
		log_admin("[q2.ErrorMsg()]")
		return 0
	else
		while(q2.NextRow()) // i made a hell of mess here pendling rewriteing because its overly complex for a thing like this.
			if(!isnull(q2.GetRowData()))
				ban = q2.GetRowData()
	if(!q1.Execute())
		log_admin("[q1.ErrorMsg()]")
		return 0
	if(!q3.Execute())
		log_admin("[q3.ErrorMsg()]")
		return 0
	else
		while(q3.NextRow()) // i made a hell of mess here pendling rewriteing because its overly complex for a thing like this.
			if(!isnull(q3.GetRowData()))
				ban = q3.GetRowData()
	if(!q1.Execute())
		log_admin("[q3.ErrorMsg()]")
		return 0
	else
		while(q1.NextRow())
			if(!isnull(q1.GetRowData()))
				ban = q1.GetRowData()
	if(ban.len < 1)
		return 0
	if(text2num(ban["temp"]))
		var/asd = text2num(ban["minute"])
		if (!GetExp(asd))
			ClearTempbans()
			return 0
		else
			returnban = list("reason" = "ckey/id", "desc" = "\nReason: [ban["reason"]]\nExpires: [GetExp(ban["minutes"])]\nBy: [ban["bannedby"]]")
	else
		returnban = list("reason" = "ckey/id", "desc" = "\nReason: [ban["reason"]]\nExpires: <B>PERMANENT</B>\nBy: [ban["bannedby"]]")
	return returnban