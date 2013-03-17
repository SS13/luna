////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'drinks.dmi'
	icon_state = null
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/gulp_size = 5 //This is now officially broken ... need to think of a nice way to fix it.
	possible_transfer_amounts = list(5,10,15,25,30,50)
	volume = 50

	on_reagent_change()
		if (gulp_size < 5) gulp_size = 5
		else gulp_size = max(round(reagents.total_volume / 5), 5)

	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob, def_zone)
		var/datum/reagents/R = src.reagents
//		var/fillevel = gulp_size

		if(!R.total_volume || !R)
			user << "\red None of [src] left, oh no!"
			return 0

		if(M == user)
			M << "\blue You swallow a gulp of [src]."
			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, gulp_size)

			playsound(M.loc,'drink.ogg', rand(10,50), 1)
			return 1
		else if( istype(M, /mob/living/carbon/human) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

			message_admins("ATTACK: [user] ([user.ckey])(<A HREF='?src=%admin_ref%;adminplayerobservejump=\ref[user]'>JMP</A>) fed [M] ([M.ckey]) with [src].", 2)

			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, gulp_size)

/*			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				bro.cell.use(30)
				var/refill = R.get_master_reagent_id()
				spawn(600)
					R.add_reagent(refill, fillevel) */


			playsound(M.loc,'drink.ogg', rand(10,50), 1)
			return 1

		return 0


	afterattack(obj/target, mob/user , flag)

		if(istype(target, /obj/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

		else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution to [target]."

/*			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				bro.cell.use(30)
				var/refill = reagents.get_master_reagent_id()
				spawn(600)
					reagents.add_reagent(refill, trans) */

		return

	examine()
		set src in view()
		..()
		if (!(usr in range(0)) && usr!=src.loc) return
		if(!reagents || reagents.total_volume==0)
			usr << "\blue \The [src] is empty!"
		else if (reagents.total_volume<src.volume/4)
			usr << "\blue \The [src] is almost empty!"
		else if (reagents.total_volume<src.volume/2)
			usr << "\blue \The [src] is half full!"
		else if (reagents.total_volume<src.volume/0.90)
			usr << "\blue \The [src] is almost full!"
		else
			usr << "\blue \The [src] is full!"
////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks/shaker
	name = "Shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50)
	volume = 100

/obj/item/weapon/reagent_containers/food/drinks/flask
	name = "Captain's Flask"
	desc = "A metal flask belonging to the captain"
	icon_state = "flask"
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/dflask
	name = "Detective's Flask"
	desc = "A well used metal flask with the detective's name etched into it."
	icon_state = "dflask"
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	name = "glass"
	desc = "Your standard drinking glass."
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50)
	volume = 50
	g_amt = 100
	var/fired = 0
	var/list/drinkcanfire = list("b52")
	attackby(var/obj/item/I, var/mob/living/M)
		if(istype(I, /obj/item/weapon/zippo/lighter) && I:lit && (reagents.get_master_reagent_id() == drinkcanfire))
			fired = 1

	on_reagent_change()
		/*if(reagents.reagent_list.len > 1 )
			icon_state = "glass_brown"
			name = "Glass of Hooch"
			desc = "Two or more drinks, mixed together."*/
		/*else if(reagents.reagent_list.len == 1)
			for(var/datum/reagent/R in reagents.reagent_list)
				switch(R.id)*/
		if (reagents.reagent_list.len > 0)
			//mrid = R.get_master_reagent_id()
			switch(reagents.get_master_reagent_id())
				if("beer")
					icon_state = "beerglass"
					name = "Beer glass"
					desc = "A freezing pint of beer"
				if("beer2")
					icon_state = "beerglass"
					name = "Beer glass"
					desc = "A freezing pint of beer"
				if("ale")
					icon_state = "aleglass"
					name = "Ale glass"
					desc = "A freezing pint of delicious Ale"
				if("milk")
					icon_state = "glass_white"
					name = "Glass of milk"
					desc = "White and nutritious goodness!"
				if("cream")
					icon_state  = "glass_white"
					name = "Glass of cream"
					desc = "Ewwww..."
				if("chocolate")
					icon_state  = "chocolateglass"
					name = "Glass of chocolate"
					desc = "Tasty"
				if("lemon")
					icon_state  = "lemonglass"
					name = "Glass of lemon"
					desc = "Sour..."
				if("cola")
					icon_state  = "glass_brown"
					name = "Glass of Space Cola"
					desc = "A glass of refreshing Space Cola"
				if("nuka_cola")
					icon_state = "nuka_colaglass"
					name = "Nuka Cola"
					desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
				if("orangejuice")
					icon_state = "glass_orange"
					name = "Glass of Orange juice"
					desc = "Vitamins! Yay!"
				if("tomatojuice")
					icon_state = "glass_red"
					name = "Glass of Tomato juice"
					desc = "Are you sure this is tomato juice?"
				if("blood")
					icon_state = "glass_red"
					name = "Glass of Tomato juice"
					desc = "Are you sure this is tomato juice?"
				if("limejuice")
					icon_state = "glass_green"
					name = "Glass of Lime juice"
					desc = "A glass of sweet-sour lime juice."
				if("whiskey")
					icon_state = "whiskeyglass"
					name = "Glass of whiskey"
					desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
				if("gin")
					icon_state = "ginvodkaglass"
					name = "Glass of gin"
					desc = "A crystal clear glass of Griffeater gin."
				if("vodka")
					icon_state = "ginvodkaglass"
					name = "Glass of vodka"
					desc = "The glass contain wodka. Xynta."
				if("goldschlager")
					icon_state = "ginvodkaglass"
					name = "Glass of goldschlager"
					desc = "100 proof that teen girls will drink anything with gold in it."
				if("wine")
					icon_state = "wineglass"
					name = "Glass of wine"
					desc = "A very classy looking drink."
				if("cognac")
					icon_state = "cognacglass"
					name = "Glass of cognac"
					desc = "Damn, you feel like some kind of French aristocrat just by holding this."
				if ("kahlua")
					icon_state = "kahluaglass"
					name = "Glass of RR coffee Liquor"
					desc = "DAMN, THIS THING LOOKS ROBUST"
				if("vermouth")
					icon_state = "vermouthglass"
					name = "Glass of Vermouth"
					desc = "You wonder why you're even drinking this straight."
				if("tequilla")
					icon_state = "tequillaglass"
					name = "Glass of Tequilla"
					desc = "Now all that's missing is the weird colored shades!"
				if("patron")
					icon_state = "patronglass"
					name = "Glass of Patron"
					desc = "Drinking patron in the bar, with all the subpar ladies."
				if("rum")
					icon_state = "rumglass"
					name = "Glass of Rum"
					desc = "Now you want to Pray for a pirate suit, don't you?"
				if("gintonic")
					icon_state = "gintonicglass"
					name = "Gin and Tonic"
					desc = "A mild but still great cocktail. Drink up, like a true Englishman."
				if("whiskeycola")
					icon_state = "whiskeycolaglass"
					name = "Whiskey Cola"
					desc = "An innocent-looking mixture of cola and Whiskey. Delicious."
				if("whiterussian")
					icon_state = "whiterussianglass"
					name = "White Russian"
					desc = "A very nice looking drink. But that's just, like, your opinion, man."
				if("screwdrivercocktail")
					icon_state = "screwdriverglass"
					name = "Screwdriver"
					desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
				if("bloodymary")
					icon_state = "bloodymaryglass"
					name = "Bloody Mary"
					desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."
				if("martini")
					icon_state = "martiniglass"
					name = "Classic Martini"
					desc = "Damn, the bartender even stirred it, not shook it."
				if("vodkamartini")
					icon_state = "martiniglass"
					name = "Vodka martini"
					desc ="A bastardisation of the classic martini. Still great."
				if("gargleblaster")
					icon_state = "gargleblasterglass"
					name = "Pan-Galactic Gargle Blaster"
					desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."
				if("bravebull")
					icon_state = "bravebullglass"
					name = "Brave Bull"
					desc = "Tequilla and Coffee liquor, brought together in a mouthwatering mixture. Drink up."
				if("tequillasunrise")
					icon_state = "tequillasunriseglass"
					name = "Tequilla Sunrise"
					desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."
				if("toxinsspecial")
					icon_state = "toxinsspecialglass"
					name = "Toxins Special"
					desc = "Whoah, this thing is on FIRE"
				if("beepskysmash")
					icon_state = "beepskysmashglass"
					name = "Beepsky Smash"
					desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
				if("doctorsdelight")
					icon_state = "doctorsdelightglass"
					name = "Doctor's Delight"
					desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
				if("manlydorf")
					icon_state = "manlydorfglass"
					name = "The Manly Dorf"
					desc = "A manly concotion made from Ale and Beer. Intended for true men only."
				if("irishcream")
					icon_state = "irishcreamglass"
					name = "Irish Cream"
					desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
				if("cubalibre")
					icon_state = "cubalibreglass"
					name = "Cuba Libre"
					desc = "A classic mix of rum and cola."
				if("b52")
					icon_state = "b52glass"
					name = "B-52"
					desc = "Kahlua, Irish Cream, and congac. You will get bombed."
				if("atomicbomb")
					icon_state = "atomicbombglass"
					name = "Atomic Bomb"
					desc = "Nanotrasen cannot take legal responsibility for your actions after imbibing."
				if("longislandicedtea")
					icon_state = "longislandicedteaglass"
					name = "Long Island Iced Tea"
					desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
				if("threemileisland")
					icon_state = "threemileislandglass"
					name = "Three Mile Island Ice Tea"
					desc = "A glass of this is sure to prevent a meltdown."
				if("margarita")
					icon_state = "margaritaglass"
					name = "Margarita"
					desc = "On the rocks with salt on the rim. Arriba~!"
				if("blackrussian")
					icon_state = "blackrussianglass"
					name = "Black Russian"
					desc = "For the lactose-intolerant. Still as classy as a White Russian."
				if("vodkatonic")
					icon_state = "vodkatonicglass"
					name = "Vodka and Tonic"
					desc = "For when a gin and tonic isn't russian enough."
				if("manhattan")
					icon_state = "manhattanglass"
					name = "Manhattan"
					desc = "The Detective's undercover drink of choice. He never could stomach gin..."
				if("manhattan_proj")
					icon_state = "proj_manhattanglass"
					name = "Manhattan Project"
					desc = "A scienitst drink of choice, for thinking how to blow up the station."
				if("ginfizz")
					icon_state = "ginfizzglass"
					name = "Gin Fizz"
					desc = "Refreshingly lemony, deliciously dry."
				if("irishcoffee")
					icon_state = "irishcoffeeglass"
					name = "Irish Coffee"
					desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
				if("hooch")
					icon_state = "glass_brown2"
					name = "Hooch"
					desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
				if("whiskeysoda")
					icon_state = "whiskeysodaglass2"
					name = "Whiskey Soda"
					desc = "Ultimate refreshment."
				if("tonic")
					icon_state = "glass_clear"
					name = "Glass of Tonic Water"
					desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
				if("sodawater")
					icon_state = "glass_clear"
					name = "Glass of Soda Water"
					desc = "Soda water. Why not make a scotch and soda?"
				if("water")
					icon_state = "glass_clear"
					name = "Glass of Water"
					desc = "The father of all refreshments."
				if("spacemountainwind")
					icon_state = "Space_mountain_wind_glass"
					name = "Glass of Space Mountain Wind"
					desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."
				if("thirteenloko")
					icon_state = "thirteen_loko_glass"
					name = "Glass of Thirteen Loko"
					desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass"
				if("dr_gibb")
					icon_state = "dr_gibb_glass"
					name = "Glass of Dr. Gibb"
					desc = "Dr. Gibb. Not as dangerous as the name might imply."
				if("space_up")
					icon_state = "space-up_glass"
					name = "Glass of Space-up"
					desc = "Space-up. It helps keep your cool."
				if("moonshine")
					icon_state = "glass_clear"
					name = "Moonshine"
					desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
				if("soymilk")
					icon_state = "glass_white"
					name = "Glass of soy milk"
					desc = "White and nutritious soy goodness!"
				if("berryjuice")
					icon_state = "berryjuice"
					name = "Glass of berry juice"
					desc = "Berry juice. Or maybe its jam. Who cares?"
				if("poisonberryjuice")
					icon_state = "poisonberryjuice"
					name = "Glass of poison berry juice"
					desc = "A glass of deadly juice."
				if("carrotjuice")
					icon_state = "carrotjuice"
					name = "Glass of  carrot juice"
					desc = "It is just like a carrot but without crunching."
				if("banana")
					icon_state = "banana"
					name = "Glass of banana juice"
					desc = "The raw essence of a banana. HONK"
				if("bahama_mama")
					icon_state = "bahama_mama"
					name = "Bahama Mama"
					desc = "Tropic cocktail"
				if("singulo")
					icon_state = "singulo"
					name = "Singulo"
					desc = "A blue-space beverage."
				if("alliescocktail")
					icon_state = "alliescocktail"
					name = "Allies cocktail"
					desc = "A drink made from your allies."
				if("antifreeze")
					icon_state = "antifreeze"
					name = "Anti-freeze"
					desc = "The ultimate refreshment."
				if("barefoot")
					icon_state = "b&p"
					name = "Barefoot"
					desc = "Barefoot and pregnant"
				if("demonsblood")
					icon_state = "demonsblood"
					name = "Demons Blood"
					desc = "Just looking at this thing makes the hair at the back of your neck stand up."
				if("booger")
					icon_state = "booger"
					name = "Booger"
					desc = "Ewww..."
				if("snowwhite")
					icon_state = "snowwhite"
					name = "Snow White"
					desc = "A cold refreshment."
				if("aloe")
					icon_state = "aloe"
					name = "Aloe"
					desc = "Very, very, very good."
				if("andalusia")
					icon_state = "andalusia"
					name = "Andalusia"
					desc = "A nice, strange named drink."
				if("sbiten")
					icon_state = "sbitenglass"
					name = "Sbiten"
					desc = "A spicy mix of Vodka and Spice. Very hot."
				if("red_mead")
					icon_state = "red_meadglass"
					name = "Red Mead"
					desc = "A True Vikings Beverage, though its color is strange."
				if("mead")
					icon_state = "meadglass"
					name = "Mead"
					desc = "A Vikings Beverage, though a cheap one."
				if("iced_beer")
					icon_state = "iced_beerglass"
					name = "Iced Beer"
					desc = "A beer so frosty, the air around it freezes."
				if("grog")
					icon_state = "grogglass"
					name = "Grog"
					desc = "A fine and cepa drink for Space."
				if("soy_latte")
					icon_state = "soy_latte"
					name = "Soy Latte"
					desc = "A nice and refrshing beverage while you are reading."
				if("cafe_latte")
					icon_state = "cafe_latte"
					name = "Cafe Latte"
					desc = "A nice, strong and refreshing beverage while you are reading."
				if("acidspit")
					icon_state = "acidspitglass"
					name = "Acid Spit"
					desc = "A drink from Nanotrasen. Made from live aliens."
				if("amasec")
					icon_state = "amasecglass"
					name = "Amasec"
					desc = "Always handy before COMBAT!!!"
				if("neurotoxin")
					icon_state = "neurotoxinglass"
					name = "Neurotoxin"
					desc = "A drink that is guaranteed to knock you silly."
				if("hippiesdelight")
					icon_state = "hippiesdelightglass"
					name = "Hippie's Delight"
					desc = "A drink enjoyed by people during the 1960's."
				if("bananahonk")
					icon_state = "bananahonkglass"
					name = "Banana Honk"
					desc = "A drink from Clown Heaven."
				if("silencer")
					icon_state = "silencerglass"
					name = "Silencer"
					desc = "A drink from mime Heaven."
				if("nothing")
					icon_state = "nothing"
					name = "Nothing"
					desc = "Absolutely nothing."
				if("devilskiss")
					icon_state = "devilskiss"
					name = "Devils Kiss"
					desc = "Creepy time!"
				if("changelingsting")
					icon_state = "changelingsting"
					name = "Changeling Sting"
					desc = "A stingy drink."
				if("irishcarbomb")
					icon_state = "irishcarbomb"
					name = "Irish Car Bomb"
					desc = "An irish car bomb."
				if("syndicatebomb")
					icon_state = "syndicatebomb"
					name = "Syndicate Bomb"
					desc = "A syndicate bomb."
				if("erikasurprise")
					icon_state = "erikasurprise"
					name = "Erika Surprise"
					desc = "The surprise is, it's green!"
				if("driestmartini")
					icon_state = "driestmartiniglass"
					name = "Driest Martini"
					desc = "Only for the experienced. You think you see sand floating in the glass."
				if("ice")
					icon_state = "iceglass"
					name = "Glass of ice"
					desc = "Generally, you're supposed to put something else in there too..."
				if("icecoffee")
					icon_state = "icedcoffeeglass"
					name = "Iced Coffee"
					desc = "A drink to perk you up and refresh you!"
				if("coffee")
					icon_state = "glass_brown"
					name = "Glass of coffee"
					desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."
				if("bilk")
					icon_state = "glass_brown"
					name = "Glass of bilk"
					desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."
				if("absinthe")
					icon_state = "glass_green"
					name = "Glass of absinthe"
					desc = "A glass of the Green Fairy."
				if("deadrum")
					icon_state = "glass_brown"
					name = "Glass of Dead Rum"
					desc = "Dangerously sweet rum. You won't be getting scurvy any time soon!"
				else
					fired = 0
					icon_state ="glass_brown"
					name = "Glass of ..what?"
					desc = "You can't really tell what this is."
			if(fired)
				icon_state = "[icon_state]_f"
				desc = "\red [desc] It's fired!"
		else
			fired = 0
			icon_state = "glass_empty"
			name = "drinking glass"
			desc = "Your standard drinking glass"
			return


////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks/waterbottle
	name = "water bottle"
	desc = "Straight from the ice lakes of Mars!"
	icon_state = "waterbottle"
	New()
		..()
		reagents.add_reagent("water", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/coffee
	name = "Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	New()
		..()
		reagents.add_reagent("coffee", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "Duke Purple Tea"
	desc = "A refreshingly quaint drink, served piping hot."
	icon_state = "tea"
	New()
		..()
		reagents.add_reagent("tea", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/ice
	name = "Ice Cup"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	New()
		..()
		reagents.add_reagent("ice", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	name = "Dutch Hot Coco"
	desc = "Made in Space South America."
	icon_state = "hotchocolate"
	New()
		..()
		reagents.add_reagent("hot_coco", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	New()
		..()
		reagents.add_reagent("dry_ramen", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cola
	name = "Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"
	New()
		..()
		reagents.add_reagent("cola", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/beer
	name = "Space Beer"
	desc = "Beer. In space."
	icon_state = "beer"
	New()
		..()
		reagents.add_reagent("beer", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/ale
	name = "Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	New()
		..()
		reagents.add_reagent("ale", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/thirteenloko
	name = "Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsably."
	icon_state = "thirteen_loko"
	New()
		..()
		reagents.add_reagent("thirteenloko", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/milk
	name = "Space Milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	New()
		..()
		reagents.add_reagent("milk", 50)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)


/obj/item/weapon/reagent_containers/food/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100

/obj/item/weapon/reagent_containers/food/drinks/bottle/gin
	name = "Griffeater Gin"
	desc = "A bottle of high quality gin, produced in the New London Space Station."
	icon_state = "ginbottle"
	New()
		..()
		reagents.add_reagent("gin", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka
	name = "Tunguska Triple Distilled"
	desc = "Aah, vodka. Prime choice of drink AND fuel by Russians worldwide."
	icon_state = "vodkabottle"
	New()
		..()
		reagents.add_reagent("vodka", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla
	name = "Caccavo Guaranteed Quality Tequilla"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequillabottle"
	New()
		..()
		reagents.add_reagent("tequilla", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequilla, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	New()
		..()
		reagents.add_reagent("patron", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "This isn't just rum, oh no. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	New()
		..()
		reagents.add_reagent("rum", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater
	name = "Flask of Holy Water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	New()
		..()
		reagents.add_reagent("holywater", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	New()
		..()
		reagents.add_reagent("vermouth", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK"
	icon_state = "kahluabottle"
	New()
		..()
		reagents.add_reagent("kahlua", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager
	name = "College Girl Goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	New()
		..()
		reagents.add_reagent("goldschlager", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	New()
		..()
		reagents.add_reagent("cognac", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	New()
		..()
		reagents.add_reagent("wine", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "Twenty-fourth century Green Fairy, one sip of this and you just know you're gonna have a good time."
	icon_state = "absinthebottle"
	New()
		..()
		reagents.add_reagent("absinthe", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	New()
		..()
		reagents.add_reagent("orangejuice", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/cream
	name = "Milk Cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	New()
		..()
		reagents.add_reagent("cream", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	New()
		..()
		reagents.add_reagent("tomatojuice", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	New()
		..()
		reagents.add_reagent("limejuice", 100)

/obj/item/weapon/reagent_containers/food/drinks/tonic
	name = "T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	New()
		..()
		reagents.add_reagent("tonic", 50)

/obj/item/weapon/reagent_containers/food/drinks/sodawater
	name = "Soda Water"
	desc = "A can of soda water. Why not make a scotch and soda?"
	icon_state = "sodawater"
	New()
		..()
		reagents.add_reagent("sodawater", 50)

/obj/item/weapon/reagent_containers/food/drinks/dwine
	name = "Dwarven Wine"
	desc = "Warning: highly toxic."
	icon_state = "dwine"
	heal_amt = 1
	New()
		..()
		reagents.add_reagent("dwine", 50)

/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	New()
		..()
		reagents.add_reagent("whiskey", 100)





