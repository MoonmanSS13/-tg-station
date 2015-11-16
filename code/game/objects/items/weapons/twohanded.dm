/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 *		Spears
 *		CHAINSAW
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.




/*
 * Twohanded
 */
/obj/item/weapon/twohanded
	var/wielded = 0
	var/force_unwielded = 0
	var/force_wielded = 0
	var/wieldsound = null
	var/unwieldsound = null
	var/wielded_dismember_class = new /datum/dismember_class/cant_dismember

/obj/item/weapon/twohanded/proc/unwield(mob/living/carbon/user)
	if(!wielded || !user) return
	wielded = 0
	force = force_unwielded
	var/sf = findtext(name," (Wielded)")
	if(sf)
		name = copytext(name,1,sf)
	else //something wrong
		name = "[initial(name)]"
	update_icon()
	user << "<span class='notice'>You are now carrying the [name] with one hand.</span>"
	if(unwieldsound)
		playsound(loc, unwieldsound, 50, 1)
	var/obj/item/weapon/twohanded/offhand/O = user.get_inactive_hand()
	if(O && istype(O))
		O.unwield()
	dismember_class = new /datum/dismember_class/cant_dismember
	return

/obj/item/weapon/twohanded/proc/wield(mob/living/carbon/user)
	if(wielded) return
	if(istype(user,/mob/living/carbon/monkey) )
		user << "<span class='warning'>It's too heavy for you to wield fully.</span>"
		return
	if(!user.active_hand_exists(1))	//Checks for inactive hand, 1 means inverted
		user << "<span class='warning'>You need don't have an other hand!</span>"
		return
	if(user.get_inactive_hand())
		user << "<span class='warning'>You need your other hand to be empty</span>"
		return
	wielded = 1
	force = force_wielded
	name = "[name] (Wielded)"
	update_icon()
	user << "<span class='notice'>You grab the [name] with both hands.</span>"
	if (wieldsound)
		playsound(loc, wieldsound, 50, 1)
	var/obj/item/weapon/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name] - offhand"
	O.desc = "Your second grip on the [name]"
	user.put_in_inactive_hand(O)
	dismember_class = wielded_dismember_class
	return

/obj/item/weapon/twohanded/mob_can_equip(M as mob, slot)
	//Cannot equip wielded items.
	if(wielded)
		M << "<span class='warning'>Unwield the [name] first!</span>"
		return 0
	return ..()

/obj/item/weapon/twohanded/dropped(mob/user as mob)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield(user)
	return	unwield(user)

/obj/item/weapon/twohanded/update_icon()
	return

/obj/item/weapon/twohanded/attack_self(mob/user as mob)
	..()
	if(wielded) //Trying to unwield it
		unwield(user)
	else //Trying to wield it
		wield(user)

///////////OFFHAND///////////////
/obj/item/weapon/twohanded/offhand
	name = "offhand"
	icon_state = "offhand"
	w_class = 5.0
	flags = ABSTRACT

/obj/item/weapon/twohanded/offhand/unwield()
	qdel(src)

/obj/item/weapon/twohanded/offhand/wield()
	qdel(src)

/obj/item/weapon/twohanded/offhand/IsShield()//if the actual twohanded weapon is a shield, we count as a shield too!
	var/mob/user = loc
	if(!istype(user)) return 0
	var/obj/item/I = user.get_active_hand()
	if(I == src) I = user.get_inactive_hand()
	if(!I) return 0
	return I.IsShield()

///////////Two hand required objects///////////////
//This is for objects that require two hands to even pick up
/obj/item/weapon/twohanded/required/
	w_class = 5.0

/obj/item/weapon/twohanded/required/attack_self()
	return

/obj/item/weapon/twohanded/required/mob_can_equip(M as mob, slot)
	if(wielded)
		M << "<span class='warning'>[src.name] is too cumbersome to carry with anything but your hands!</span>"
		return 0
	return ..()

/obj/item/weapon/twohanded/required/attack_hand(mob/user)//Can't even pick it up without both hands empty
	var/obj/item/weapon/twohanded/required/H = user.get_inactive_hand()
	if(H != null)
		user.visible_message("<span class='notice'>[src.name] is too cumbersome to carry in one hand!</span>")
		return
	var/obj/item/weapon/twohanded/offhand/O = new(user)
	user.put_in_inactive_hand(O)
	..()
	wielded = 1


/obj/item/weapon/twohanded/

/*
 * Fireaxe
 */
/obj/item/weapon/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	force = 5
	throwforce = 15
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_unwielded = 10
	force_wielded = 25 // Was 18, Buffed - RobRichards/RR
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'

	wielded_dismember_class = new /datum/dismember_class/medium

/obj/item/weapon/twohanded/fireaxe/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "fireaxe[wielded]"
	return

/obj/item/weapon/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	if(A && wielded && (istype(A,/obj/structure/window) || istype(A,/obj/structure/grille))) //destroys windows and grilles in one hit
		if(istype(A,/obj/structure/window)) //should just make a window.Break() proc but couldn't bother with it
			var/obj/structure/window/W = A

			new /obj/item/weapon/shard( W.loc )
			if(W.reinf) new /obj/item/stack/rods( W.loc)

			if (W.dir == SOUTHWEST)
				new /obj/item/weapon/shard( W.loc )
				if(W.reinf) new /obj/item/stack/rods( W.loc)
		qdel(A)


/*
 * Double-Bladed Energy Swords - Cheridan
 */
/obj/item/weapon/twohanded/dualsaber
	icon_state = "dualsaber0"
	name = "double-bladed energy sword"
	desc = "Handle with care."
	force = 3
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = 2.0
	force_unwielded = 3
	force_wielded = 34
	wieldsound = 'sound/weapons/saberon.ogg'
	unwieldsound = 'sound/weapons/saberoff.ogg'
	hitsound = "swing_hit"
	flags = NOSHIELD
	origin_tech = "magnets=3;syndicate=4"
	block_chance = 50
	item_color = "green"
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/hacked = 0

	wielded_dismember_class = new /datum/dismember_class/high/nobleed

/obj/item/weapon/twohanded/dualsaber/New()
	item_color = pick("red", "blue", "green", "purple")

/obj/item/weapon/twohanded/dualsaber/update_icon()
	if(wielded)
		icon_state = "dualsaber[item_color][wielded]"
	else
		icon_state = "dualsaber0"
	clean_blood()//blood overlays get weird otherwise, because the sprite changes.
	return

/obj/item/weapon/twohanded/dualsaber/attack(target as mob, mob/living/carbon/human/user as mob)
	..()
	if(user.disabilities & CLUMSY && (wielded) && prob(40))
		impale(user)
		return
	if((wielded) && prob(50))
		spawn(0)
			for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
				user.dir = i
				sleep(1)

/obj/item/weapon/twohanded/dualsaber/proc/impale(mob/living/user as mob)
	user << "<span class='warning'>You twirl around a bit before losing your balance and impaling yourself on \the [src].</span>"
	if (force_wielded)
		user.take_organ_damage(20,25)
	else
		user.adjustStaminaLoss(25)

/obj/item/weapon/twohanded/dualsaber/IsShield()
	if(wielded)
		return 1
	else
		return 0

/obj/item/weapon/twohanded/dualsaber/attack_hulk(mob/living/carbon/human/user)  //In case thats just so happens that it is still activated on the groud, prevents hulk from picking it up
	if(wielded)
		user << "<span class='warning'>You cant pick up such dangerous item with your meaty hands without losing fingers, better not to.</span>"
		return 1

/obj/item/weapon/twohanded/dualsaber/wield(mob/living/carbon/M) //Specific wield () hulk checks due to reflection chance for balance issues and switches hitsounds.
	if(istype(M))
		if(ismonkey(M) || (M.dna && M.dna.check_mutation(HULK)))
			M << "<span class='warning'>You lack the grace to wield this.</span>"
			return
	..()
	hitsound = 'sound/weapons/blade1.ogg'

/obj/item/weapon/twohanded/dualsaber/unwield() //Specific unwield () to switch hitsounds.
	..()
	hitsound = "swing_hit"

/obj/item/weapon/twohanded/dualsaber/IsReflect()
	if(wielded)
		return 1

/obj/item/weapon/twohanded/dualsaber/green
	New()
		item_color = "green"

/obj/item/weapon/twohanded/dualsaber/red
	New()
		item_color = "red"

/obj/item/weapon/twohanded/dualsaber/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	..()
	if(istype(W, /obj/item/device/multitool))
		if(hacked == 0)
			hacked = 1
			user << "<span class='warning'>2XRNBW_ENGAGE</span>"
			item_color = "rainbow"
			update_icon()
		else
			user << "<span class='warning'>It's starting to look like a triple rainbow - no, nevermind.</span>"


//spears

/obj/item/weapon/twohanded/spear
	icon_state = "spearglass0"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 10
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_unwielded = 10
	force_wielded = 18
	throwforce = 20
	throw_speed = 4
	embedded_impact_pain_multiplier = 3
	flags = NOSHIELD
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")

/obj/item/weapon/twohanded/spear/update_icon()
	icon_state = "spearglass[wielded]"
	return

///CHAINSAW///

/obj/item/weapon/twohanded/chainsaw
	icon_state = "chainsaw0"
	name = "Chainsaw"
	desc = "Perfect for felling trees or fellow spaceman."
	force = 13
	throwforce = 13
	throw_speed = 1
	throw_range = 5
	w_class = 4.0 // can't fit in backpacks
	force_unwielded = 13
	force_wielded = 22
	wieldsound = 'sound/weapons/chainsawStart.ogg'
	hitsound = "swing_hit"
	flags = NOSHIELD
	origin_tech = "materials=2;combat=2;engineering=2"
	attack_verb = list("bashed", "smacked")
	var/wield_cooldown = 0
	var/max_fuel = 40
//	bleedcap = 0 //You can bleed anytime bby

	wielded_dismember_class = new/datum/dismember_class/high/

/obj/item/weapon/twohanded/chainsaw/New()
	..()
	create_reagents(max_fuel)
	reagents.add_reagent("fuel", max_fuel)
	update_icon()
	return

/obj/item/weapon/twohanded/chainsaw/unwield()
	..()
	hitsound = initial(hitsound)
//	bleedchance = 0
	attack_verb = list("bashed", "smacked")

/obj/item/weapon/twohanded/chainsaw/wield(user)
	if(get_fuel())
		..(user)
		hitsound = "chainsaw_attack"
		//bleedchance = 50
		attack_verb = list("sawed", "cut", "hacked", "carved", "cleaved", "butchered", "felled", "timbered")
		remove_fuel(1, user)
	else
		user << "<span class='notice'>The [src] is out of fuel.</span>"

/obj/item/weapon/twohanded/chainsaw/update_icon()
	if(wielded)
		icon_state = "chainsaw[wielded]"
	else
		icon_state = "chainsaw0"
	return

/obj/item/weapon/twohanded/chainsaw/IsShield() //Disarming someone with a chainsaw should be difficult.
	if(wielded)
		return 1
	else
		return 0

/obj/item/weapon/twohanded/chainsaw/process()
	if(wielded)
		if(prob(5))
			remove_fuel(1)

/obj/item/weapon/twohanded/chainsaw/proc/remove_fuel(amount = 1, mob/user = null)
	if(!wielded || !check_fuel(user))
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		check_fuel(user)
		return 1
	return 0

/obj/item/weapon/twohanded/chainsaw/afterattack(atom/O, mob/user, proximity)
	if(!proximity) return
	if(istype(O, /obj/structure/reagent_dispensers/fueltank) && in_range(src, O))
		if(!wielded)
			O.reagents.trans_to(src, max_fuel)
			user << "<span class='notice'>[src] refueled.</span>"
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
		else
			user << "<span class='notice'>You can't refuel the [src] while it's running.</span>"
	if(wielded)
		remove_fuel(1, user)

//Turns off the chainsaw if there is no more fuel
/obj/item/weapon/twohanded/chainsaw/proc/check_fuel(mob/user)
	if(get_fuel() <= 0 && wielded)
		user << "<span class='notice'>The [src] has run out of fuel.</span>"
		unwield(user)
		return 0
	return 1

//Returns the amount of fuel in the chainsaw
/obj/item/weapon/twohanded/chainsaw/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/weapon/twohanded/chainsaw/examine(mob/user)
	..()
	user << "It contains [get_fuel()] unit\s of fuel out of [max_fuel]."

/obj/item/weapon/twohanded/chainsaw/attack_self(mob/user as mob) //Override to create a cooldown
	if(wielded)
		if(world.time <= wield_cooldown + 10)
			return
		wield_cooldown = world.time
	..(user)