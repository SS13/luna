/mob/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	if (usr.muted)
		return

	for (var/client/C)
		if (C.holder)
			C.ctab_message("Admin", "\blue <b><font color=red>HELP: </font>[key_name(src, C.mob)](<A HREF='?src=\ref[C.holder];adminplayeropts=\ref[src]'>X</A>):</b> [msg]")
			C << 'adminhelp_recieve.ogg'
	usr << "<font color='blue'>PM to-<b>Admins</b>: [msg]</font>"
	log_admin("HELP: [key_name(src)]: [msg]")

/*/client/proc/cmd_admin_pm(mob/M as mob in world)
	set category = "Special Verbs"
	set name = "Admin PM"
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	if(M)
		if(src.mob.muted)
			src << "You are muted have a nice day"
			return
		if (!( ismob(M) ))
			return
		var/t = input("Message:", text("Private message to [M.key]"))  as text
		//if(src.holder.rank != "Coder" && src.holder.rank != "Host")
			//t = strip_html(t,500)
		t = sanitize_spec(t)
		if (!( t ))
			return
		if (usr.client && usr.client.holder)
			M << "\red Admin PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
			M << 'adminpm.ogg'
			usr << "\blue Admin PM to-<b>[key_name(M, usr, 1)]</b>: [t]"
		else
			if (M.client && M.client.holder)
				M << "\blue Reply PM from-<b>[key_name(usr, M, 1)]</b>: [t]"
				M << 'adminpm.ogg'
			else
				M << "\red Reply PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
			usr << "\blue Reply PM to-<b>[key_name(M, usr, 0)]</b>: [t]"

		log_admin("PM: [key_name(usr)]->[key_name(M)] : [t]")

		for(var/client/C)	//we don't use message_admins here because the sender/receiver might get it too
			if(C.holder && C.mob.key != usr.key && C.mob.key != M.key)
				C.mob << "<B><font color='blue'>PM: [key_name(usr, C.mob)]-&gt;[key_name(M, C.mob)]:</B> \blue [t]</font>"*/

/client/proc/cmd_admin_pm(mob/M as mob in world)
	set category = "Admin"
	set name = "Admin PM"

	if(!src.holder)
		src << "Only administrators may use this command."
		return
	if(M)
		if(mob.muted)
			src << "You are muted have a nice day"
			return
		if (!( ismob(M) ))
			return
		var/t = input("Message:", text("Private message to [M.key]"))  as text|null
		//if(src.holder.rank != "Coder" && src.holder.rank != "Host")
		//	t = strip_html(t,500)
		t = sanitize_spec(t)
		//world << "RIGHT LEFT" // debug wtf
		if (!( t ))
			return
		if (usr.client && usr.client.holder)
			M << "\red Admin PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
			usr << "\blue Admin PM to-<b>[key_name(M, usr, 1)]</b>: [t]"
		else
			if (M.client && M.client.holder)
				M << "\blue Reply PM from-<b>[key_name(usr, M, 1)]</b>: [t]"
			else
				M << "\red Reply PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
			usr << "\blue Reply PM to-<b>[key_name(M, usr, 0)]</b>: [t]"
		if (M)
			M << sound('adminpm.ogg')

		log_admin("PM: [key_name(usr)]->[key_name(M)] : [t]")

		for(var/mob/K in world)	//we don't use message_admins here because the sender/receiver might get it too
			if(K && K.client && K.client.holder && K.key != usr.key && K.key != M.key)
				K << "<B><font color='blue'>PM: [key_name(usr, K)]-&gt;[key_name(M, K)]:</B> \blue [t]</font>"
//