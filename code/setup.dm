
//atmos
#define R_IDEAL_GAS_EQUATION	8.31 * 2 //kPa*L/(K*mol)
#define ONE_ATMOSPHERE			101.325	//kPa
#define T0C						273.15	// 0degC
#define T20C					293.15	// 20degC
#define TCMB					2.7		// -270.3degC
#define CELL_VOLUME 			2500	//liters in a cell


#define O2STANDARD 0.21
#define N2STANDARD 0.79

#define SEE_INVISIBLE_LEVEL_ONE 35	//Used by some stuff in code. It's really poorly organized.
#define INVISIBILITY_LEVEL_ONE 35	//Used by some stuff in code. It's really poorly organized.

#define SEE_INVISIBLE_LEVEL_TWO 45	//Used by some other stuff in code. It's really poorly organized.
#define INVISIBILITY_LEVEL_TWO 45	//Used by some other stuff in code. It's really poorly organized.

#define MOLES_PLASMA_VISIBLE	0.5 //Moles in a standard cell after which plasma is visible

#define BREATH_VOLUME 0.5	//liters in a normal breath



#define MINIMUM_AIR_RATIO_TO_SUSPEND 0.048
	//Minimum ratio of air that must move to/from a tile to suspend group processing

#define MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND 0.048
#define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND 4
	//Minimum temperature difference before group processing is suspended
#define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER 0.5
	//Minimum temperature difference before the gas temperatures are just set to be equal



#define FLOOR_HEAT_TRANSFER_COEFFICIENT 0.08
#define WALL_HEAT_TRANSFER_COEFFICIENT 0.0
#define SPACE_HEAT_TRANSFER_COEFFICIENT 0.20 //a hack to partly simulate radiative heat
#define OPEN_HEAT_TRANSFER_COEFFICIENT 0.40
#define WINDOW_HEAT_TRANSFER_COEFFICIENT 0.10 //a hack for now
	//Must be between 0 and 1. Values closer to 1 equalize temperature faster
	//Should not exceed 0.4 else strange heat flow occur


#define FIRE_SPREAD_RADIOSITY_SCALE		0.85
#define FIRE_CARBON_ENERGY_RELEASED	 500000 //amount of heat released per mole of burnt carbon into the tile
vs_control/var/FIRE_PLASMA_ENERGY_RELEASED = 3000000 //amount of heat released per mole of burnt plasma into the tile
vs_control/var/FIRE_PLASMA_ENERGY_RELEASED_DESC = "Determines the temp increase from fires."
#define FIRE_GROWTH_RATE			50000 //For small fires

//Plasma fire properties
#define PLASMA_MINIMUM_OXYGEN_NEEDED		2
#define PLASMA_MINIMUM_OXYGEN_PLASMA_RATIO	30
#define PLASMA_OXYGEN_FULLBURN				10

#define SPARK_TEMP 3500 //The temperature of welders, lighters, etc. for fire purposes.

#define TSPC 253.15					// -20degC
#define TESPC 243.15				// -30degC
/var/const/MOLES_CELLSTANDARD = (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))	//moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC
/var/const/MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION = T20C+10
/var/const/MINIMUM_TEMPERATURE_START_SUPERCONDUCTION = T20C+200

/var/const/TANK_LEAK_PRESSURE = (30.*ONE_ATMOSPHERE)	// Tank starts leaking
/var/const/TANK_RUPTURE_PRESSURE = (40.*ONE_ATMOSPHERE) // Tank spills all contents into atmosphere

/var/const/TANK_FRAGMENT_PRESSURE = (50.*ONE_ATMOSPHERE) // Boom 3x3 base explosion
/var/const/TANK_FRAGMENT_SCALE = (10.*ONE_ATMOSPHERE) // +1 for each SCALE kPa aboe threshold

/var/const/MOLES_O2STANDARD = MOLES_CELLSTANDARD*O2STANDARD	// O2 standard value (21%)
/var/const/MOLES_N2STANDARD = MOLES_CELLSTANDARD*N2STANDARD	// N2 standard value (79%)
/var/const/BREATH_PERCENTAGE = BREATH_VOLUME/CELL_VOLUME
	//amount of air to take a from a tile
/var/const/HUMAN_NEEDED_OXYGEN = MOLES_CELLSTANDARD*BREATH_PERCENTAGE*0.16
	//amount of air needed before pass out/suffocation commences
								// was 2 atm
/var/const/MINIMUM_AIR_TO_SUSPEND = MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND
	//Minimum amount of air that has to move before a group processing can be suspended

/var/const/MINIMUM_MOLES_DELTA_TO_MOVE = MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND //Either this must be active
/var/const/MINIMUM_TEMPERATURE_TO_MOVE = T20C+100 		  //or this (or both, obviously)

/var/const/FIRE_MINIMUM_TEMPERATURE_TO_SPREAD = 150+T0C
/var/const/FIRE_MINIMUM_TEMPERATURE_TO_EXIST = 100+T0C

/var/const/PLASMA_MINIMUM_BURN_TEMPERATURE = 250+T0C
/var/const/PLASMA_UPPER_TEMPERATURE	= 1370+T0C



#define NORMPIPERATE 30					//pipe-insulation rate divisor
#define HEATPIPERATE 8					//heat-exch pipe insulation

#define FLOWFRAC 0.99				// fraction of gas transfered per process

#define BRUTE		"brute"
#define BURN		"fire"
#define TOX			"tox"
#define OXY			"oxy"
#define CLONE		"clone"
#define HALLOSS		"halloss"

#define STUN		"stun"
#define WEAKEN		"weaken"
#define PARALYZE	"paralize"
#define IRRADIATE	"irradiate"
#define STUTTER		"stutter"
#define EYE_BLUR	"eye_blur"
#define DROWSY		"drowsy"

//ITEM INVENTORY SLOT BITMASKS
#define SLOT_OCLOTHING	1
#define SLOT_ICLOTHING	2
#define SLOT_GLOVES		4
#define SLOT_EYES		8
#define SLOT_EARS		16
#define SLOT_MASK		32
#define SLOT_HEAD		64
#define SLOT_FEET		128
#define SLOT_ID			256
#define SLOT_BELT		512
#define SLOT_BACK		1024
#define SLOT_POCKET		2048	//this is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_DENYPOCKET	4096	//this is to deny items with a w_class of 2 or 1 to fit in pockets.

#define NOSLIP		1024 		//prevents from slipping on wet floors, in space etc

//FLAGS BITMASK

//#define ONBACK 			1		// can be put in back slot - outdated flag
//#define TABLEPASS 		2		// can pass by a table or rack - outdated flag
#define HALFMASK 		4		// mask only gets 1/2 of air supply from internals

#define HEADSPACE 		4		// head wear protects against space

#define MASKINTERNALS 	8		// mask allows internals
#define SUITSPACE 		8		// suit protects against space

#define USEDELAY		16		// 1 second extra delay on use
#define NOSHIELD		32		// weapon not affected by shield
#define CONDUCT			64		// conducts electricity (metal etc.)
#define NOHIT			128		// no displaying ""
#define FPRINT			256		// takes a fingerprint
#define ON_BORDER		512		// item has priority to check when entering or leaving

#define GLASSESCOVERSEYES	1024
#define MASKCOVERSEYES		1024	// get rid of some of the other retardation in these flags
#define HEADCOVERSEYES		1024	// feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH		2048	// on other items, these are just for mask/head
#define HEADCOVERSMOUTH		2048

#define PLASMAGUARD 	4096
#define OPENCONTAINER	4096	// is an open container for chemistry purposes

#define BLOCK_GAS_SMOKE_EFFECT 	8192	// blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define ONESIZEFITSALL			8192	// can be worn by fatties (or children? ugh)

#define	NOREACT					16384 	//Reagents dont' react inside this container.

#define BLOCKHAIR				32768	// temporarily removes the user's hair icon

//flags for pass_flags
#define PASSTABLE	1
#define PASSGLASS	2
#define PASSGRILLE	4
#define PASSBLOB	8

//turf-only flags
#define NOJAUNT		1


#define BLIND			1
#define MUTE			2
#define DEAF			4


//Bit flags for the flags_inv variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.
#define HIDEGLOVES		1	//APPLIES ONLY TO THE EXTERIOR SUIT!!
#define HIDESUITSTORAGE	2	//APPLIES ONLY TO THE EXTERIOR SUIT!!
#define HIDEJUMPSUIT	4	//APPLIES ONLY TO THE EXTERIOR SUIT!!
#define HIDESHOES		8	//APPLIES ONLY TO THE EXTERIOR SUIT!!

#define HIDEMASK		1	//APPLIES ONLY TO HELMETS/MASKS!!
#define HIDEEARS		2	//APPLIES ONLY TO HELMETS/MASKS!! (ears means headsets and such)
#define HIDEEYES		4	//APPLIES ONLY TO HELMETS/MASKS!! (eyes means glasses)
#define HIDEFACE		8	//APPLIES ONLY TO HELMETS/MASKS!! Dictates whether we appear as unknown.

//organs var/status
#define ORGAN_DESTROYED 	0
#define ORGAN_INTACT 		1
#define ORGAN_ROBOTIC 		2

//slots
/*#define slot_back			1
#define slot_wear_mask		2
#define slot_handcuffed		3
#define slot_l_hand			4
#define slot_r_hand			5
#define slot_belt			6
#define slot_wear_id		7
#define slot_ears			8
#define slot_glasses		9
#define slot_gloves			10
#define slot_head			11
#define slot_shoes			12
#define slot_wear_suit		13
#define slot_w_uniform		14
#define slot_l_store		15
#define slot_r_store		16
#define slot_s_store		17
#define slot_in_backpack	18
#define slot_legcuffed		19*/

// mob/var/stat things
#define CONSCIOUS	0
#define UNCONSCIOUS	1
#define DEAD		2

// channel numbers for power
#define EQUIP 	1
#define LIGHT 	2
#define ENVIRON 3
#define TOTAL 	4	//for total power used only

// bitflags for machine stat variable
#define BROKEN 		1
#define NOPOWER 	2
#define POWEROFF	4	// tbd
#define MAINT		8	// under maintaince
#define EMPED		16	// temporary broken by EMP pulse

#define ENGINE_EJECT_Z 3

var/const
	GAS_O2 = 1 << 0
	GAS_N2 = 1 << 1
	GAS_PL = 1 << 2
	GAS_CO2 = 1 << 3
	GAS_N2O = 1 << 4

//Symbolic defines for getZLevel (copied from old code)
//These are not actual Z levels, but arguments to a function that returns a Z level.
#define Z_STATION	1
#define Z_SPACE		2


// Generic mutations:
#define	TK				1
#define COLD_RESISTANCE	2
#define XRAY			4
#define HULK			8
#define CLUMSY			16

#define mNobreath 		32
#define mRemote 		64
#define mRegen 			128
#define mRun 			256

#define mRemotetalk 	512
#define mMorph 			1024
#define mBlend 			2048
#define mHallucination 	4096
#define mFingerprints 	8192
#define mShock 			16384
#define mSmallsize 		32768

#define HUSK	 		65536
#define NOCLONE	 		131072

#define TABBED_PM	1

//For ze mini pods (take from old code).
/var/list/podspawns = list( )
/var/list/poddocks = list( )


//Bitflags defining which status effects could be or are inflicted on a mob
#define CANSTUN		1
#define CANWEAKEN	2
#define CANPARALYSE	4
#define CANPUSH		8
#define GODMODE		4096
#define FAKEDEATH	8192	//Replaces stuff like changeling.changeling_fakedeath
#define DISFIGURED	16384	//I'll probably move this elsewhere if I ever get wround to writing a bitflag mob-damage system
#define XENO_HOST	32768	//Tracks whether we're gonna be a baby alien's mummy.

#define TEMPERATURE_DAMAGE_COEFFICIENT		1.5		//This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define BODYTEMP_AUTORECOVERY_DIVISOR		12		//This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_MINIMUM		10		//Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_COLD_DIVISOR				6		//Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR				6		//Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_COOLING_MAX				30		//The maximum number of degrees that your body can cool in 1 tick, when in a cold area.
#define BODYTEMP_HEATING_MAX				30		//The maximum number of degrees that your body can heat up in 1 tick, when in a hot area.

#define BODYTEMP_HEAT_DAMAGE_LIMIT			360.15 // The limit the human body can take before it starts taking damage from heat.
#define BODYTEMP_COLD_DAMAGE_LIMIT			260.15 // The limit the human body can take before it starts taking damage from coldness.

#define SPACE_HELM_MIN_TEMP_PROTECT			2.0		//what min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define SPACE_HELM_MAX_TEMP_PROTECT			1500	//Thermal insulation works both ways /Malkevin
#define SPACE_SUIT_MIN_TEMP_PROTECT			2.0		//what min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define SPACE_SUIT_MAX_TEMP_PROTECT			1500

#define FIRE_SUIT_MIN_TEMP_PROTECT			60		//Cold protection for firesuits
#define FIRE_SUIT_MAX_TEMP_PROTECT			30000	//what max_heat_protection_temperature is set to for firesuit quality suits. MUST NOT BE 0.
#define FIRE_HELM_MIN_TEMP_PROTECT			60		//Cold protection for fire helmets
#define FIRE_HELM_MAX_TEMP_PROTECT			30000	//for fire helmet quality items (red and white hardhats)

#define HELMET_MIN_TEMP_PROTECT				160		//For normal helmets
#define HELMET_MAX_TEMP_PROTECT				600		//For normal helmets
#define ARMOR_MIN_TEMP_PROTECT				160		//For armor
#define ARMOR_MAX_TEMP_PROTECT				600		//For armor

#define GLOVES_MIN_TEMP_PROTECT				2.0		//For some gloves (black and)
#define GLOVES_MAX_TEMP_PROTECT				1500	//For some gloves
#define SHOES_MIN_TEMP_PROTECT				2.0		//For gloves
#define SHOES_MAX_TEMP_PROTECT				1500	//For gloves

#define TOUCH 1
#define INGEST 2

#define NEARSIGHTED		1
#define EPILEPSY		2
#define COUGHING		4
#define TOURETTES		8
#define NERVOUS			16

// bitflags for clothing parts
#define HEAD		1
#define CHEST		2
#define GROIN		4
#define LEG_LEFT	8
#define LEG_RIGHT	16
#define LEGS		24
#define FOOT_LEFT	32
#define FOOT_RIGHT	64
#define FEET		96
#define ARM_LEFT	128
#define ARM_RIGHT	256
#define ARMS		384
#define HAND_LEFT	512
#define HAND_RIGHT	1024
#define HANDS		1536
#define FULL_BODY	2047

// for secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list of humans.
#define HEALTH_HUD		1 // dead, alive, sick, health status
#define STATUS_HUD		2 // a simple line rounding the mob's number health
#define ID_HUD			3 // the job asigned to your ID
#define WANTED_HUD		4 // wanted, released, parroled, security status
#define IMPLOYAL_HUD	5 // loyality implant
#define IMPCHEM_HUD		6 // chemical implant
#define IMPTRACK_HUD	7 // tracking implant