/var/create_item_html = null
/obj/admins/proc/create_item(var/mob/user)
	if (!create_item_html)
		var/itemjs = null
		itemjs = dd_list2text(typesof(/obj/item), ";")
		create_item_html = file2text('create_object.html')
		create_item_html = dd_replacetext(create_item_html, "null /* object types */", "\"[itemjs]\"")

	user << browse(dd_replacetext(create_item_html, "/* ref src */", "\ref[src]"), "window=create_mob;size=425x475")
