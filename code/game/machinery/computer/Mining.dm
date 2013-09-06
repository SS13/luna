/obj/machinery/computer/mining/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/mining/attack_hand(mob/user as mob)
	var/dat
	user.machine = src
	dat+="<B>Current Mining Shuttle Location</B>:"
	if(Minign_Shuttle_Controls.location==1)
		dat+="<font color=red> Ship</font><br><hr>"
	if(Minign_Shuttle_Controls.location==2)
		dat+="<font color=red> Mining Base</font><br><hr>"
	if(Minign_Shuttle_Controls.online==0)
		dat += "<center><a href='byond://?src=\ref[src];send=1'>Send</a></center>"
	else
		dat += "<center><a href='byond://?src=\ref[src];cancel=1'>Cancel</a></center>"
	user << browse(dat, "window=Mining Shuttle Computer")
	onclose(user, "window=Mining Shuttle Computer;size=413x133")
	return

/obj/machinery/computer/mining/Topic(href, href_list)
	if(..())
		return
	if(href_list["send"])
		Minign_Shuttle_Controls.start()
		updateUsrDialog()
	if(href_list["cancel"])
		Minign_Shuttle_Controls.cancel()
		updateUsrDialog()





