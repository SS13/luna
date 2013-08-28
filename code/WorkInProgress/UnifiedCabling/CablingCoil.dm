// =
// = The Unified(-Type-Tree) Cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new cable & network types
// =

// Unified Cable Network System - Generic Cable Coil Class

/obj/item/weapon/cable_coil
	icon_state = "redcoil3"
	icon           = 'Coils.dmi'
	flags          = TABLEPASS | USEDELAY | FPRINT | CONDUCT
	throwforce     = 10
	w_class        = 1.5
	throw_speed    = 2
	throw_range    = 5
	item_state     = ""

	var/CoilColour = "red"
	var/BaseName  = "Electrical"
	var/ShortDesc = "A piece of electrical cable"
	var/LongDesc  = "A long piece of electrical cable"
	var/CoilDesc  = "A spool of electrical cable"
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
	name = "[BaseName] Cable"
	..(Location)

/obj/item/weapon/cable_coil/proc/update_icon()
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
		usr << ShortDesc
	else if(amount == 2)
		usr << LongDesc
	else
		usr << CoilDesc
		usr << "There are [amount] usable lengths on the spool"

/obj/item/weapon/cable_coil/attackby(obj/item/weapon/W, mob/user)
	if( istype(W, /obj/item/weapon/wirecutters) && amount > 2)
		amount--
		new/obj/item/weapon/cable_coil(user.loc, 1)
		user << "You cut a length off the [name]."
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

		if( (C.amount + amount <= 30) )
			C.amount += amount
			user << "You join the [name]s together."
			C.update_icon()
			del src
			return

		else
			user << "You transfer [30 - amount] lengths of cable from one coil to the other."
			amount -= (30-C.amount)
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