// soda machine and its charge

/obj/item/weapon/vending_charge/soda
	name = "Soda Machine Charge"
	charge_type = "soda"
	icon_state = "soda-charge"

/obj/machinery/vending/soda
	name = "Soda Machine"
	desc = "A vending machine packed full of tooth-rotting goodness."
	icon_state = "soda"
	points = 10
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/soda/cola;/obj/item/weapon/reagent_containers/food/drinks/soda/cola_diet;/obj/item/weapon/reagent_containers/food/drinks/soda/cola_apple;/obj/item/weapon/reagent_containers/food/drinks/soda/cola_grape;/obj/item/weapon/reagent_containers/food/drinks/soda/cola_strawberry;/obj/item/weapon/reagent_containers/food/drinks/soda/cola_lemonlime;/obj/item/weapon/reagent_containers/food/drinks/soda/cola_orange;/obj/item/weapon/reagent_containers/food/drinks/soda/rootbeer"
	//product_amounts = "25"
	product_prices = "1;1;1;1;1;1;1;1"
	vend_delay = 5
	product_hidden = ""
	hidden_prices = ""
	charge_type = "soda"