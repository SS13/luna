/obj/structure/closet/secure_closet/freezer

/obj/structure/closet/secure_closet/freezer/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "Kitchen Cabinet"
	req_access = list(access_kitchen)

	New()
		..()
		sleep(2)
		for(var/i = 0, i < 3, i++)
			new /obj/item/weapon/reagent_containers/food/drinks/flour(src)
		new /obj/item/weapon/reagent_containers/food/condiment/sugar(src)
		return


/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()



/obj/structure/closet/secure_closet/freezer/meat
	name = "Refrigirator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"


	New()
		..()
		sleep(2)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
		new /obj/item/weapon/reagent_containers/food/snacks/plump(src)
		new /obj/item/weapon/reagent_containers/food/snacks/plump(src)
		new /obj/item/weapon/reagent_containers/food/snacks/plump(src)
		new /obj/item/kitchen/egg_box(src)
		new /obj/item/kitchen/egg_box(src)
		new /obj/item/weapon/reagent_containers/food/snacks/meatball(src)
		new /obj/item/weapon/reagent_containers/food/snacks/meatball(src)
		new /obj/item/weapon/reagent_containers/food/snacks/meatball(src)
		new /obj/item/weapon/reagent_containers/food/snacks/meatball(src)



/obj/structure/closet/secure_closet/freezer/fridge
	name = "Refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"


	New()
		..()
		sleep(2)
		for(var/i = 0, i < 5, i++)
			new /obj/item/weapon/reagent_containers/food/drinks/milk(src)
		for(var/i = 0, i < 5, i++)
			new /obj/item/weapon/reagent_containers/food/drinks/soymilk(src)
		for(var/i = 0, i < 2, i++)
			new /obj/item/kitchen/egg_box(src)
		return



/*obj/structure/closet/secure_closet/freezer/money
	name = "Freezer"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"
	req_access = list(access_heads_vault)


	New()
		..()
		sleep(2)
		for(var/i = 0, i < 3, i++)
			new /obj/item/weapon/spacecash/c1000(src)
		for(var/i = 0, i < 5, i++)
			new /obj/item/weapon/spacecash/c500(src)
		for(var/i = 0, i < 6, i++)
			new /obj/item/weapon/spacecash/c200(src)
		return*/

/obj/structure/closet/secure_closet/kitchen
	name = "Kitchen Cabinet"
	req_access = list(access_kitchen)

/obj/structure/closet/secure_closet/kitchen/New()
	..()
	sleep(2)
	new /obj/item/clothing/head/chefhat(src)
	new /obj/item/clothing/head/chefhat(src)
	new /obj/item/clothing/head/chefhat(src)
	new /obj/item/clothing/under/rank/chef(src)
	new /obj/item/clothing/under/rank/chef(src)
	new /obj/item/clothing/under/rank/chef(src)
	new /obj/item/clothing/suit/storage/chef(src)
	new /obj/item/clothing/suit/storage/chef(src)
	new /obj/item/clothing/suit/storage/chef(src)
	new /obj/item/clothing/suit/storage/apron(src)
	new /obj/item/clothing/suit/storage/apron(src)
	new /obj/item/clothing/suit/storage/apron(src)
	new /obj/item/weapon/storage/box/lglo(src)
	new /obj/item/weapon/kitchen/utensil/knife(src)
	new /obj/item/weapon/kitchen/utensil/knife(src)
	new /obj/item/weapon/kitchen/utensil/knife(src)
	new /obj/item/weapon/kitchen/rollingpin(src)
	new /obj/item/weapon/kitchen/rollingpin(src)
	new /obj/item/weapon/kitchen/rollingpin(src)