/**********************Mineral ores**************************/

/obj/item/weapon/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore"

/obj/item/weapon/ore/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/satchel/ore))
		var/obj/item/weapon/satchel/ore/S = O
		for (var/obj/item/weapon/ore/G in src.loc)
			if (S.contents.len < S.capacity)
				S.contents += G;
			else
				user << "\blue The mining satchel is full."
				return
		return
	..()

/obj/item/weapon/ore/uranium
	name = "uranium ore"
	icon_state = "Uranium ore"
	origin_tech = "materials=5"

/obj/item/weapon/ore/iron
	name = "iron ore"
	icon_state = "Iron ore"
	origin_tech = "materials=1"

/obj/item/weapon/ore/glass
	name = "sand"
	icon_state = "Glass ore"
	origin_tech = "materials=1"

	attack_self(mob/living/user as mob) //It's magic I ain't gonna explain how instant conversion with no tool works. -- Urist
		var/location = get_turf(user)
		for(var/obj/item/weapon/ore/glass/sandToConvert in location)
			new /obj/item/stack/sheet/mineral/sandstone(location)
			del(sandToConvert)
		new /obj/item/stack/sheet/mineral/sandstone(location)
		del(src)

/obj/item/weapon/ore/plasma
	name = "plasma ore"
	icon_state = "Plasma ore"
	origin_tech = "materials=2;plasma=2"

/obj/item/weapon/ore/silver
	name = "silver ore"
	icon_state = "Silver ore"
	origin_tech = "materials=3"

/obj/item/weapon/ore/gold
	name = "gold ore"
	icon_state = "Gold ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/diamond
	name = "diamond ore"
	icon_state = "Diamond ore"
	origin_tech = "materials=6"

/obj/item/weapon/ore/clown
	name = "bananium ore"
	icon_state = "Clown ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/slag
	name = "slag"
	desc = "Completely useless"
	icon_state = "slag"

/obj/item/weapon/ore/New()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8


/*****************************Coin********************************/

/obj/item/weapon/coin
	icon = 'icons/obj/economy.dmi'
	name = "coin"
	icon_state = "coin_mythril_heads"
	flags = FPRINT | CONDUCT
	force = 1
	throwforce = 3
	w_class = 1.0
	var/string_attached
	var/list/sideslist = list("heads","tails")
	var/cmineral = null
	var/cooldown = 0

/obj/item/weapon/coin/New()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

	icon_state = "coin_[cmineral]_heads"
	if(cmineral)
		name = "[cmineral] coin"

/obj/item/weapon/coin/gold
	cmineral = "gold"
	origin_tech = "materials=4"

/obj/item/weapon/coin/silver
	cmineral = "silver"
	origin_tech = "materials=3"

/obj/item/weapon/coin/diamond
	cmineral = "diamond"
	origin_tech = "materials=6"

/obj/item/weapon/coin/iron
	cmineral = "iron"
	origin_tech = "materials=1"

/obj/item/weapon/coin/plasma
	cmineral = "plasma"
	origin_tech = "materials=2;plasma=2"

/obj/item/weapon/coin/uranium
	cmineral = "uranium"
	origin_tech = "materials=5"

/obj/item/weapon/coin/clown
	cmineral = "bananium"
	origin_tech = "materials=4"

/obj/item/weapon/coin/adamantine
	cmineral = "adamantine"

/obj/item/weapon/coin/mythril
	cmineral = "mythril"

/obj/item/weapon/coin/twoheaded
	cmineral = "iron"
	desc = "Hey, this coin's the same on both sides!"
	sideslist = list("heads")
	origin_tech = "materials=1"

/obj/item/weapon/coin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/cable_coil) )
		var/obj/item/weapon/cable_coil/CC = W
		if(string_attached)
			user << "\blue There already is a string attached to this coin."
			return

		overlays += image('icons/obj/economy.dmi',"coin_string_overlay")
		string_attached = 1
		user << "\blue You attach a string to the coin."
		CC.use(1)
	else if(istype(W,/obj/item/weapon/wirecutters))
		if(!string_attached)
			..()
			return

		new/obj/item/weapon/cable_coil(user.loc, 1)
		overlays = list()
		string_attached = null
		user << "\blue You detach the string from the coin."
	else ..()

/obj/item/weapon/coin/attack_self(mob/user as mob)
	if(cooldown < world.time - 15)
		var/coinflip = pick(sideslist)
		cooldown = world.time
		flick("coin_[cmineral]_flip", src)
		icon_state = "coin_[cmineral]_[coinflip]"
		playsound(user.loc, 'sound/items/coinflip.ogg', 50, 1)
		if(do_after(user, 10))
			user.visible_message("<span class='notice'>[user] has flipped [src]. It lands on [coinflip].</span>", \
								 "<span class='notice'>You flip [src]. It lands on [coinflip].</span>", \
								 "<span class='notice'>You hear the clattering of loose change.</span>")