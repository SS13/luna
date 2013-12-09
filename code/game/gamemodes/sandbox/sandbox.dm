/datum/game_mode/sandbox
	name = "Sandbox"
	config_tag = "sandbox"
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_items = {"
/obj/item/weapon/storage/box/syndie_kit/imp_freedom:3:Freedom Implant, with injector;
/obj/item/weapon/storage/box/syndie_kit/imp_compress:5:Compressed matter implant, with injector;
/obj/item/weapon/storage/box/syndie_kit/imp_explosive:6:Explosive implant, with injector;
/obj/item/device/hacktool:4:Hacktool;
/obj/item/weapon/storage/toolbox/syndicate:1:Fully Loaded Toolbox;
/obj/item/weapon/soap/syndie:1:Syndicate Soap;
/obj/item/clothing/shoes/syndigaloshes:2:No-Slip Syndicate Shoes;
/obj/item/device/encryptionkey/syndicate:1:Binary Encryption Key;
/obj/item/clothing/under/chameleon:2:Chameleon Jumpsuit;
/obj/item/weapon/gun/projectile/revolver:7:Revolver;
/obj/item/ammo_magazine/box/a357:3:Revolver Ammo;
/obj/item/weapon/card/emag:3:Cryptographic Sequencer;
/obj/item/weapon/card/id/syndicate:4:Fake ID;
/obj/item/clothing/glasses/thermal:4:Thermal Glasses;
/obj/item/weapon/storage/box/grenades/emp:4:Box of EMP grenades;
/obj/item/device/powersink:5:Power sink;
/obj/item/weapon/cartridge/syndicate:3:Detomatix PDA cart;
/obj/item/device/chameleon:4:Chameleon projector;
/obj/item/weapon/melee/energy/sword:5:Energy sword;
/obj/item/weapon/pen/sleepypen:4:Sleepy pen;
/obj/item/weapon/gun/energy/crossbow:5:Energy crossbow;
/obj/item/clothing/mask/gas/voice:3:Voice changer;
/obj/item/weapon/aiModule/freeform:3:Freeform AI module;
/obj/item/weapon/syndie/c4explosive:4:Low power explosive charge;
/obj/item/weapon/syndie/c4explosive/heavy:7:High (!) power explosive charge;
/obj/item/weapon/reagent_containers/pill/cyanide:4:Cyanide Pill
	"}
	uplink_uses = 10

/datum/game_mode/sandbox/announce()
	..()
	world << "<B>Build your own ship with the sandbox-panel command!</B>"

/datum/game_mode/sandbox/post_setup()
	for(var/client/C)
		C.mob.CanBuild()

	return 1

/datum/game_mode/sandbox/check_finished()
	return 0