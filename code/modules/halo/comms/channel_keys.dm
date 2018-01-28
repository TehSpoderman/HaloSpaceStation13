
var/global/datum/halo_frequencies/halo_frequencies = new()

//These defines are undef'd in commsitems.dm
#define SHIPCOM_NAME "SHIPCOM"
#define TEAMCOM_NAME "TEAMCOM"
#define SQUADCOM_NAME "SQUADCOM"
#define FLEETCOM_NAME "FLEETCOM"
#define EBAND_NAME "EBAND"
#define COV_COMMON_NAME "Battlenet"
#define CIV_NAME "Common"

/datum/halo_frequencies
	var/innie_channel = "INNIECOM"
	var/innie_freq = -1
	var/shipcom_freq = -1
	var/teamcom_freq = -1
	var/squadcom_freq = -1
	var/fleetcom_freq = -1
	var/const/eband_freq = 1160
	var/const/civ_freq = 1459
	var/covenant_battlenet_freq = -1
	var/list/used_freqs = list()
	var/list/frequencies = list("INNIECOM",SHIPCOM_NAME,TEAMCOM_NAME,SQUADCOM_NAME,FLEETCOM_NAME,EBAND_NAME,CIV_NAME,COV_COMMON_NAME)

/datum/halo_frequencies/New()
	if(GLOB.using_map.use_global_covenant_comms)
		new /obj/item/device/mobilecomms/commsbackpack/covenant (locate(1,1,1))
	setup_com_channels()

/datum/halo_frequencies/proc/setup_com_channel_list()
	frequencies.Insert(frequencies.Find("INNIECOM"),innie_channel) //Find the inniecom placeholder, and place the new name at it's index.
	frequencies[innie_channel] = innie_freq
	frequencies[SHIPCOM_NAME] = shipcom_freq
	frequencies[TEAMCOM_NAME] = teamcom_freq
	frequencies[SQUADCOM_NAME] = squadcom_freq
	frequencies[FLEETCOM_NAME] = fleetcom_freq
	frequencies[EBAND_NAME] = eband_freq
	frequencies[CIV_NAME] = civ_freq
	frequencies[COV_COMMON_NAME] = covenant_battlenet_freq
	radiochannels = frequencies

/datum/halo_frequencies/proc/setup_com_channels()
	innie_channel = pick(\
	"ZULUCOM","OMEGACOM","RANGERCOM","BAGDERCOM",\
	"DELCOM","KILLCOM","PANTHERCOM","HOGCOM",\
	"LIBRACOM","LIBERTYCOM","FREECOM","MILCOM",\
	"COBRACOM","MONSTERCOM","HARDCOM","GOCOM",\
	"AGGCOM","MIDCOM","PITCOM","TOPCOM","VAULTCOM",\
	"WOLFCOM","OTTERCOM","BRONZECOM","GOLDCOM",\
	"RATCOM","TUNNELCOM","READYCOM","GROKCOM",\
	"DRACOCOM","RAPTORCOM","PREDCOM","REDCOM",\
	"OPCOM","OWLCOM","RAWCOM","BLUECOM","DOPECOM",\
	"BULLCOM","SILVERCOM","DOGCOM","SNAKECOM",\
	"EXCOM"\
	)

	//randomised the freqs but avoid collisions
	used_freqs += "[eband_freq]"
	used_freqs += "[civ_freq]"
	//
	innie_freq = rand(1001, 9998)
	while(used_freqs.Find("[innie_freq]"))
		innie_freq = rand(1001, 9998)
	used_freqs += "[innie_freq]"
	//
	shipcom_freq = rand(1001, 9998)
	while(used_freqs.Find("[shipcom_freq]"))
		shipcom_freq = rand(1001, 9998)
	used_freqs += "[shipcom_freq]"
	//
	teamcom_freq = rand(1001, 9998)
	while(used_freqs.Find("[teamcom_freq]"))
		teamcom_freq = rand(1001, 9998)
	used_freqs += "[teamcom_freq]"
	//
	squadcom_freq = rand(1001, 9998)
	while(used_freqs.Find("[squadcom_freq]"))
		squadcom_freq = rand(1001, 9998)
	used_freqs += "[squadcom_freq]"
	//
	fleetcom_freq = rand(1001, 9998)
	while(used_freqs.Find("[fleetcom_freq]"))
		fleetcom_freq = rand(1001, 9998)
	used_freqs += "[fleetcom_freq]"

	while(used_freqs.Find("[covenant_battlenet_freq]"))
		covenant_battlenet_freq = rand(1460, 9998)
	used_freqs += "[covenant_battlenet_freq]"

	setup_com_channel_list()

	return 1

/obj/item/device/encryptionkey/inniecom
	channels = list("INNIECOM" = 1)

/obj/item/device/encryptionkey/inniecom/New()
	channels = list(halo_frequencies.innie_channel = 1,EBAND_NAME = 1)
	..()

/obj/item/device/encryptionkey/shipcom
	channels = list(SHIPCOM_NAME = 1,EBAND_NAME = 1)

/obj/item/device/encryptionkey/fleetcom
	channels = list(SHIPCOM_NAME = 1,TEAMCOM_NAME = 1,SQUADCOM_NAME = 1,FLEETCOM_NAME = 1,EBAND_NAME = 1)

/obj/item/device/encryptionkey/officercom
	channels = list(SHIPCOM_NAME = 1,FLEETCOM_NAME = 1, EBAND_NAME = 1)

/obj/item/device/encryptionkey/squadcom
	channels = list(SHIPCOM_NAME = 1,SQUADCOM_NAME = 1,EBAND_NAME = 1)

/obj/item/device/encryptionkey/teamcom
	channels = list(SHIPCOM_NAME = 1,TEAMCOM_NAME = 1,SQUADCOM_NAME = 1,EBAND_NAME = 1)

/obj/item/device/encryptionkey/eband
		channels = list(EBAND_NAME = 1)

/obj/item/device/encryptionkey/public
	channels = list(CIV_NAME = 1)
