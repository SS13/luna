/obj/item/clothing/shoes/red
	name = "red shoes"
	icon_state = "red"

/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	icon_state = "santahat"

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 0

/obj/item/clothing/suit/space/soviet
	name = "soviet suit"
	desc = "For the Motherland!"
	icon_state = "redarmycoat"
	item_state = "redarmycoat"
	item_color = "soviet"
	slowdown = 0

/obj/item/clothing/mask/gas/owl
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"

/obj/item/clothing/under/owl
	name = "owl uniform"
	desc = "Twoooo!"
	icon_state = "owl"
	item_color = "owl"

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1

/obj/item/clothing/mask/gas/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags = FPRINT|BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2

/obj/item/clothing/mask/gas/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags = FPRINT|BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2
	var/voicechange = 0

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	icon_state = "boots"

/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	icon_state = "death"
	item_state = "death"
	flags = FPRINT | CONDUCT
	fire_resist = T0C+5200


/obj/item/clothing/under/nazi1
	name = "Nazi uniform"
	desc = "SIEG HEIL!"
	icon_state = "nazi1"
	item_color = "nazi"

/obj/item/clothing/under/johnny
	name = "Johnny~~"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_color = "johnny"

/obj/item/clothing/under/color/rainbow
	name = "rainbow"
	desc = "rainbow"
	icon_state = "rainbow"
	item_color = "rainbow"

/*obj/item/clothing/under/cloud
	name = "cloud"
	desc = "cloud"
	icon_state = "cloud"
	color = "aqua"

/obj/item/clothing/under/yay
	name = "yay"
	desc = "Yay!"
	icon_state = "yay"
	color = "yellow"*/


// STEAMPUNK STATION

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/obj/item/clothing/under/rank/captain/suit
	name = "Captain's Suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	item_color = "green_suit"

/obj/item/clothing/under/rank/head_of_personnel/suit
	name = "Head of Personnel's Suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state = "g_suit"
	item_color = "teal_suit"

/obj/item/clothing/under/rank/police
	name = "Police Uniform"
	desc = "Move along, nothing to see here."
	icon_state = "police"
	item_state = "b_suit"
	item_color = "police"

/obj/item/clothing/head/helmet/bobby
	name = "Custodian Helmet"
	desc = "Heh. Lookit dat fukken helmet."
	icon_state = "policehelm"
	item_state = "helmet"

/obj/item/clothing/under/overalls
	name = "Laborer's Overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	item_color = "overalls"

/obj/item/weapon/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10
