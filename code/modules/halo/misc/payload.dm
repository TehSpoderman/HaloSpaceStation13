
/obj/payload
	name = "Nuclear Warhead Payload"
	desc = "The word 'UNSC' is scratched out, replaced with a spraypainted image of a skull"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MFDD"
	anchored = 0
	density = 1
	var/explodetype = /datum/nuclearexplosion
	var/exploding
	var/explode_at
	var/seconds_to_explode = 240
	var/arm_time = 3 //Time in seconds to arm the bomb.
	var/disarm_at
	var/seconds_to_disarm = 60
	var/mob/living/u = null
	var/disarming
	var/explodedesc = "A spraypainted image of a skull adorns this slowly ticking bomb."
	var/activeoverlay = "MFDD Armed Screen"

/obj/payload/attack_hand(var/mob/living/user)
	if(!exploding)
		if(!checkturf())
			src.visible_message("<span class='danger'>The [src] beeps a warning:'OPTIMAL LOCATION NOT REACHED'</span>")
		else
			if(do_after(user,arm_time SECONDS,src,1,1,,1))
				u = user
				u.visible_message("<span class = 'userdanger'>[user.name] primes the [src] for detonation</span>","<span class ='notice'>You prime the [src] for detonation</span>")
				explode_at = world.time + seconds_to_explode*10
				exploding = 1
				GLOB.processing_objects += src
				set_anchor(1)
				checkoverlay(1)
	else
		if(!disarming)
			u = user
			u.visible_message("<span class = 'danger'>[user.name] starts disarming the [src]</span>","<span class ='notice'>You start disarming the [src]. You estimate it'll take [seconds_to_disarm] seconds</span>")
			disarm_at = world.time + seconds_to_disarm*10
			disarming = 1
		else
			to_chat(user,"<span class ='notice'>Someone else is already disarming the [src]</span>")

/obj/payload/proc/checkoverlay(var/on)
	if(!activeoverlay)
		return
	if(on)
		overlays += activeoverlay
	else
		overlays -= activeoverlay

/obj/payload/proc/checkturf()
  for(var/obj/effect/bomblocation/b in range(0,src))
    return 1
  return 0

/obj/payload/proc/checknextto()
	if(u)
		if(u in range(1,loc))
			return 1
		else
			u = null
			return 0

/obj/payload/proc/checkalive()
	if(u.health > -u.maxHealth)
		return 1
	else
		return 0

/obj/payload/proc/checkexplode()
	if(exploding)
		desc = explodedesc + " [(explode_at - world.time)/10] seconds remain."
	if(exploding && world.time >= explode_at)
		GLOB.processing_objects -= src
		new explodetype(src)
		qdel(src)
		return

/obj/payload/proc/set_anchor(var/onoff)
	anchored = onoff

/obj/payload/proc/checkdisarm()
	if(!checknextto() || !checkalive() || !disarming)
		disarming = 0
		return
	if(world.time >= disarm_at)
		u.visible_message("<span class = 'danger'>[u] disarms the [src]</span>","<span class = 'notice'>You disarm the [src]</span>")
		exploding = 0
		disarming = 0
		set_anchor(0)
		desc = initial(desc)
		checkoverlay(0)
		GLOB.processing_objects -= src

/obj/payload/process()
	checkexplode()
	checkdisarm()

/obj/effect/bomblocation
	name = "Bomb Delivery Point"
	desc = "Marks the location for the delivery of a bomb."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	anchored = 1
	invisibility = 100 //Don't want this to be seen at all.

/obj/payload/covenant
	name = "Antimatter Bomb"
	desc = "Menacing spikes jut out from this device's frame."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state ="Antimatter"
	activeoverlay = null
	explodedesc = "Spikes conceal a countdown timer."
	seconds_to_explode = 300
	seconds_to_disarm = 60

/obj/item/weapon/pinpointer/advpinpointer/bombplantlocator
	name = "Optimal Ordinance Yield Locator"
	desc = "A locator device that points towards an optimal location that maximises the yield of a bomb."
	mode = 2
	var/list/bomblocations = list()

/obj/item/weapon/pinpointer/advpinpointer/bombplantlocator/New()
	for(var/obj/effect/bomblocation/b in world)
		bomblocations += b.loc
	if(bomblocations.len == 0)
		return log_admin("ERROR: Bombplantlocator cannot find any bomblocations")
	target = pick(bomblocations)

/obj/item/weapon/pinpointer/advpinpointer/bombplantlocator/toggle_mode()
	visible_message("<span class = 'notice'>The locator announces 'TARGET LOCKED: MODE CHANGE UNAVAILABLE'</span>")
	return

/datum/nuclearexplosion/New(var/obj/b)
	explosion(b.loc,20,30,40,50)
	for(var/mob/living/m in range(50,b.loc))
		to_chat(m,"<span class = 'userdanger'>A shockwave slams into you! You feel yourself falling apart...</span>")
		m.gib() // Game over.
	qdel(src)