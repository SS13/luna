// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power or into cyborgs

/obj/item/weapon/cell
	name = "power cell"
	desc = "A rechargeable electrochemical power cell."
	icon = 'power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = "powerstorage=1"
	flags = FPRINT | CONDUCT
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = 3.0
	pressure_resistance = 80
	var/charge = 100	// note %age conveted to actual charge in New
	var/maxcharge = 2500
	m_amt = 700
	var/rigged = 0		// true if rigged to explode
	construction_cost = list("metal"=750,"glass"=75)
	construction_time=100

/obj/item/weapon/cell/update_icon()
	overlays.Cut()

	if(charge < 0.01)
		return
	else if(charge/maxcharge >=0.995)
		overlays += image('icons/obj/power.dmi', "cell-o2")
	else
		overlays += image('icons/obj/power.dmi', "cell-o1")

/obj/item/weapon/cell/proc/percent()		// return % charge of cell
	return 100.0*charge/maxcharge

// use power from a cell
/obj/item/weapon/cell/proc/use(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(charge < amount)	return 0
	charge = (charge - amount)
	return 1

// recharge the cell
/obj/item/weapon/cell/proc/give(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(maxcharge < amount)	return 0
	var/power_used = min(maxcharge-charge,amount)
	charge += power_used
	return power_used


/obj/item/weapon/cell/examine()
	set src in view(1)
	if(usr)
		if(maxcharge <= 2500)
			usr << "[desc]\nThe manufacturer's label states this cell has a power rating of [maxcharge], and that you should not swallow it.\nThe charge meter reads [round(src.percent() )]%."
		else
			usr << "This power cell has an exciting chrome finish, as it is an uber-capacity cell type! It has a power rating of [maxcharge].\nThe charge meter reads [round(src.percent() )]%."


/obj/item/weapon/cell/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W

		user << "You inject the solution into the power cell."

		if(S.reagents.has_reagent("plasma", 5))

			rigged = 1

		S.reagents.clear_reagents()


/obj/item/weapon/cell/proc/explode()
	var/turf/T = get_turf(src.loc)

	explosion(T, 0, 1, 2, 2, 1)

	spawn(1)
		del(src)


/*************
* CELL TYPES *
*************/

/obj/item/weapon/cell/New()
	..()
	charge = charge * maxcharge/100.0		// map obj has charge as percentage, convert to real value here

	spawn(5)
		update_icon()

/obj/item/weapon/cell/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/crap
	name = "\improper Nanotrasen brand rechargable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	icon_state = "crapcell"
	origin_tech = "powerstorage=0"
	maxcharge = 500
	g_amt = 40

/obj/item/weapon/cell/crap/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/secborg
	name = "\improper Nanotrasen brand rechargable D battery"
	icon_state = "crapcell"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	g_amt = 40

/obj/item/weapon/cell/secborg/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/gun
	name = "\improper Nanotrasen brand rechargable D battery"
	icon_state = "crapcell"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	maxcharge = 1000
	g_amt = 40

/obj/item/weapon/cell/high
	name = "high-capacity power cell"
	origin_tech = "powerstorage=2"
	icon_state = "hcell"
	maxcharge = 10000
	g_amt = 60

/obj/item/weapon/cell/high/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/super
	name = "super-capacity power cell"
	origin_tech = "powerstorage=5"
	icon_state = "scell"
	maxcharge = 20000
	g_amt = 70
	construction_cost = list("metal"=750,"glass"=100)

/obj/item/weapon/cell/super/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = "powerstorage=6"
	icon_state = "hpcell"
	maxcharge = 30000
	g_amt = 80
	construction_cost = list("metal"=500,"glass"=150,"gold"=200,"silver"=200)

/obj/item/weapon/cell/hyper/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 30000
	g_amt = 80
	use() return 1

/obj/item/weapon/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = "powerstorage=1"
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	charge = 100
	maxcharge = 300
	m_amt = 0
	g_amt = 0

/obj/item/weapon/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with plasma, it crackles with power."
	origin_tech = "powerstorage=2;biotech=4"
	icon = 'icons/mob/slimes.dmi' //'icons/obj/harvest.dmi'
	icon_state = "yellow slime extract" //"potato_battery"
	maxcharge = 10000
	maxcharge = 10000
	m_amt = 0
	g_amt = 0

	update_icon() return