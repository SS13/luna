// =
// = The Unified(-Type-Tree) Cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new cable & network types
// =

// Unified Cable Network System - Generic Cable Coil Class

/obj/item/weapon/cable_coil
	name = "cable coil"
	icon_state = "redcoil3"
	icon           = 'Coils.dmi'
	flags          = USEDELAY | FPRINT | CONDUCT
	throwforce     = 10
	w_class        = 1.5
	throw_speed    = 2
	throw_range    = 5
	item_state     = ""

	var/CoilColour = "red"
	var/BaseName  = "electrical"
	var/Maxamount  = 30
	var/amount     = 30
	var/CableType  = /obj/cabling/power
	var/CanLayDiagonally = 1

/obj/item/weapon/cable_coil/New(var/Location, var/Length)
	if(!Length)
		Length = Maxamount
	amount = Length
	item_state     = "[CoilColour]coil"
	icon_state     = "[CoilColour]coil"
	pixel_x = rand(-4,4)
	pixel_y = rand(-4,4)
	update_icon()
	..(Location)

/obj/item/weapon/cable_coil/update_icon()
	if(amount == 1)
		icon_state = "[CoilColour]coil1"
		item_state = "[CoilColour]coil1"
	else if(amount == 2)
		icon_state = "[CoilColour]coil2"
		item_state = "[CoilColour]coil2"
	else
		icon_state = "[CoilColour]coil3"
		item_state = "[CoilColour]coil3"

/obj/item/weapon/cable_coil/examine()
	if (amount == 1)
		usr << "A short piece of power cable."
	else if(amount == 2)
		usr << "A piece of power cable."
	else
		usr << "A coil of power cable. There are [amount] lengths of cable in the coil."

/obj/item/weapon/cable_coil/verb/make_restraint()
	set name = "Make Cable Restraints"
	set category = "Object"
	var/mob/M = usr

	if(ishuman(M) && !M.restrained() && !M.stat && !M.paralysis && ! M.stunned)
		if(!istype(usr.loc,/turf)) return
		if(src.amount <= 14)
			usr << "\red You need at least 15 lengths to make restraints!"
			return
		new /obj/item/weapon/handcuffs/cable(usr.loc)
		usr << "\blue You wind some cable together to make some restraints."
		src.use(15)
	else
		usr << "\blue You cannot do that."
	..()

/obj/item/weapon/cable_coil/attackby(obj/item/weapon/W, mob/user)
	if( istype(W, /obj/item/weapon/wirecutters) && amount > 2)
		amount--
		new/obj/item/weapon/cable_coil(user.loc, 1)
		user << "You cut a piece off the [name]."
		update_icon()
		return

	else if( istype(W, /obj/item/weapon/cable_coil) )
		var/obj/item/weapon/cable_coil/C = W
		if (C.CableType != CableType)
			user << "You can't combine different kinds of cabling!"
			return

		if(C.amount == 30)
			user << "The coil is too long, you cannot add any more cable to it."
			return

		if(C.amount + amount <= 30)
			C.amount += amount
			user << "You join the [name]s together."
			C.update_icon()
			del src
			return

		else
			user << "You transfer [30 - C.amount] lengths of cable from one coil to the other."
			amount -= 30-C.amount
			update_icon()
			C.amount = 30
			C.update_icon()
			return

/obj/item/weapon/cable_coil/proc/use(var/used)
	if(src.amount < used)
		return 0
	else if (src.amount == used)
		//handle mob icon update
		if(ismob(loc))
			var/mob/M = loc
			M.drop_item(src)
		del(src)
		return 1
	else
		amount -= used
		update_icon()
		return 1

/obj/item/weapon/cable_coil/proc/LayOnTurf(turf/simulated/floor/Target, mob/user)

	if(!isturf(user.loc))
		return

	if(get_dist(Target,user) > 1)
		user << "You can't lay cable at a place that far away."
		return

	if(Target.intact)
		user << "You can't lay cable there unless the floor tiles are removed."
		return

	else
		var/NewDirection

		if(user.loc == Target)
			NewDirection = user.dir
		else
			NewDirection = get_dir(Target, user)

		if(!CanLayDiagonally && (NewDirection & NewDirection - 1))
			user << "This type of cable cannot be laid diagonally."
			return

		var/obj/cabling/Cable = new CableType(null)

		for(var/obj/cabling/ExistingCable in Target)
			if((ExistingCable.Direction1 == NewDirection || ExistingCable.Direction2 == NewDirection) && ExistingCable.EquivalentCableType == Cable.EquivalentCableType)
				user << "There's already a cable at that position."
				del Cable
				return

		del Cable

		var/obj/cabling/NewCable = new CableType(Target)
		NewCable.Direction1 = 0
		NewCable.Direction2 = NewDirection
		NewCable.add_fingerprint(user)
		NewCable.update_icon()
		use(1)

/obj/item/weapon/cable_coil/proc/JoinCable(obj/cabling/Cable, mob/user)


	var/turf/UserLocation = user.loc

	if(!isturf(UserLocation))
		return
	var/turf/CableLocation = Cable.loc

	if(!isturf(CableLocation) || CableLocation.intact)
		return
	if(get_dist(Cable, user) > 1)
		user << "You can't lay cable at a place that far away."
		return

	if(UserLocation == CableLocation)
		return

	var/DirectionToUser = get_dir(Cable, user)

	if(!CanLayDiagonally && (DirectionToUser & DirectionToUser - 1))
		user << "This type of cable cannot be laid diagonally."
		return

	if(Cable.Direction1 == DirectionToUser || Cable.Direction2 == DirectionToUser)
		if(UserLocation.intact)
			user << "You can't lay cable there unless the floor tiles are removed."
			return

		var/DirectionToCable = reverse_dir_3d(DirectionToUser)

		for(var/obj/cabling/UnifiedCable in UserLocation)
			if((UnifiedCable.Direction1 == DirectionToCable || UnifiedCable.Direction2 == DirectionToCable) && UnifiedCable.EquivalentCableType == Cable.EquivalentCableType)
				user << "There's already a [Cable.name] at that position."
				return

		var/obj/cabling/NewCable = new CableType(CableLocation, 0, DirectionToCable)
		NewCable.add_fingerprint(user)
		NewCable.UserTouched(user)
		NewCable.update_icon()
		use(1)

	else if(Cable.Direction1 == 0)
		var/NewDirection1 = Cable.Direction2
		var/NewDirection2 = DirectionToUser

		if(NewDirection1 > NewDirection2)
			NewDirection1 = DirectionToUser
			NewDirection2 = Cable.Direction2

		for(var/obj/cabling/ExistingCable in CableLocation)
			if(ExistingCable == Cable || ExistingCable.EquivalentCableType != Cable.EquivalentCableType)
				continue
			if((ExistingCable.Direction1 == NewDirection1 && ExistingCable.Direction2 == NewDirection2) || (ExistingCable.Direction1 == NewDirection2 && ExistingCable.Direction2 == NewDirection1) )	// make sure no cable matches either direction
				user << "There's already a [Cable.name] at that position."
				return

		var/obj/cabling/NewCable = new CableType(CableLocation, NewDirection1, NewDirection2)
		NewCable.add_fingerprint(user)
		NewCable.UserTouched(user)
		NewCable.update_icon()

		del Cable

		use(1)

	return

/obj/item/weapon/cable_coil/afterattack(var/atom/Target, var/mob/User, var/Flag)
	var/obj/cabling/Cable = new CableType(null)

	if (!Cable.CanConnect(Target))
		del Cable
		return


	var/turf/CableLocation = get_turf(Target)

	if(CableLocation.intact || !istype(CableLocation, /turf/simulated/floor))
		return

	if(get_dist(Target, User) > 1)
		return

	var/DirectionToUser = get_dir(Target, User)

	for(var/obj/cabling/ExistingCable in CableLocation)
		if((ExistingCable.Direction1 == DirectionToUser || ExistingCable.Direction2 == DirectionToUser) && ExistingCable.EquivalentCableType == Cable.EquivalentCableType)
			User << "There's already a cable at that position."
			return

	var/obj/cabling/NewCable = new CableType(CableLocation, 0, DirectionToUser)
	NewCable.add_fingerprint(User)
	NewCable.UserTouched(User)
	NewCable.update_icon()
	use(1)
	del Cable

	..()
	return

/obj/item/weapon/cable_coil/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(!ishuman(M) || !ishuman(user) || user.a_intent != "help")
		return ..()

	var/mob/living/carbon/human/H = M
	var/mob/living/carbon/human/user2 = user

	var/t = user2.zone_sel.selecting
	var/datum/organ/external/affecting = H.organs[t]

	if(t in list("eyes", "mouth", "groin", "chest") || !affecting)
		return ..()

	if(affecting.status != ORGAN_ROBOTIC)
		return ..()

	if(use(2))
		if(M != user)
			for (var/mob/O in viewers(M, null))
				O.show_message("\red [M]'s robotic [affecting.display_name] wires has been replaced by [user].", 1)
		else
			var/t_himself = "it's"
			if (user.gender == MALE)
				t_himself = "his"
			else if (user.gender == FEMALE)
				t_himself = "her's"

			for (var/mob/O in viewers(M, null))
				O.show_message("\red [M] replaced some wires on [t_himself] robotic [affecting.display_name].", 1)


		if (affecting.heal_damage(0, 10))
			H.UpdateDamageIcon()
		else
			H.UpdateDamage()

		M.updatehealth()