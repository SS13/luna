/var/create_turf_html = null
/var/create_object_html = null
/var/create_mob_html = null
/var/create_item_html = null



/obj/admins/proc/create_turf(var/mob/user)
	if (!create_turf_html)
		var/turfjs = null
		turfjs = dd_list2text(typesof(/turf), ";")
		create_turf_html = file2text('create_object.html')
		create_turf_html = dd_replacetext(create_turf_html, "null /* object types */", "\"[turfjs]\"")
	user << browse(dd_replacetext(create_turf_html, "/* ref src */", "\ref[src]"), "window=create_turf;size=425x475")


/obj/admins/proc/create_object(var/mob/user)
	if (!create_object_html)
		var/objectjs = null
		objectjs = dd_list2text(typesof(/obj), ";")
		create_object_html = file2text('create_object.html')
		create_object_html = dd_replacetext(create_object_html, "null /* object types */", "\"[objectjs]\"")
	user << browse(dd_replacetext(create_object_html, "/* ref src */", "\ref[src]"), "window=create_object;size=425x475")


/obj/admins/proc/create_mob(var/mob/user)
	if (!create_mob_html)
		var/mobjs = null
		mobjs = dd_list2text(typesof(/mob), ";")
		create_mob_html = file2text('create_object.html')
		create_mob_html = dd_replacetext(create_mob_html, "null /* object types */", "\"[mobjs]\"")
	user << browse(dd_replacetext(create_mob_html, "/* ref src */", "\ref[src]"), "window=create_mob;size=425x475")


/obj/admins/proc/create_item(var/mob/user)
	if (!create_item_html)
		var/itemjs = null
		itemjs = dd_list2text(typesof(/obj/item), ";")
		create_item_html = file2text('create_object.html')
		create_item_html = dd_replacetext(create_item_html, "null /* object types */", "\"[itemjs]\"")
	user << browse(dd_replacetext(create_item_html, "/* ref src */", "\ref[src]"), "window=create_item;size=425x475")