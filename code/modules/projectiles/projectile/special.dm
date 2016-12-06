/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		return 1


/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	check_armour = "bullet"
	sharp = 1
	edge = 1

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	fire_sound = 'sound/weapons/pulse3.ogg'
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	var/temperature = 300


	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = temperature
		return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	check_armour = "bullet"

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.ex_act(2)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))\
						shake_camera(M, 3, 1)
				qdel(src)
				return 1
		else
			return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/living/M = target
		if(ishuman(target))
			var/mob/living/carbon/human/H = M
			if((H.species.flags & IS_PLANT) && (H.nutrition < 500))
				if(prob(15))
					H.apply_effect((rand(30,80)),IRRADIATE,blocked = H.getarmor(null, "rad"))
					H.Weaken(5)
					for (var/mob/V in viewers(src))
						V.show_message("<span class='warning'>[M] writhes in pain as \his vacuoles boil.</span>", 3, "<span class='warning'>You hear the crunching of leaves.</span>", 2)
				if(prob(35))
					if(prob(80))
						randmutb(M)
						domutcheck(M,null)
					else
						randmutg(M)
						domutcheck(M,null)
				else
					M.adjustFireLoss(rand(5,15))
					M.show_message("<span class='danger'>The radiation beam singes you!</span>")
		else if(istype(target, /mob/living/carbon/))
			M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		else
			return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
		if(ishuman(target)) //These rays make plantmen fat.
			var/mob/living/carbon/human/H = M
			if((H.species.flags & IS_PLANT) && (H.nutrition < 500))
				H.nutrition += 30
		else if (istype(target, /mob/living/carbon/))
			M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		else
			return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.confused += rand(5,8)
/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope
	nodamage = 1
	damage_type = HALLOSS
	muzzle_type = /obj/effect/projectile/bullet/muzzle


/obj/item/projectile/bullet/tranq
	name = "bullet"
	damage = 2
	sharp = 1
	embed = 1
	volume = 3
	kill_count = 15 //shorter range
	unacidable = 1
	muzzle_type = null

/obj/item/projectile/bullet/tranq/New()
	reagents.add_reagent("stoxin", 3)

/obj/item/projectile/bullet/tranq/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked < 100 && isliving(target))
		var/mob/living/L = target
		if(L.can_inject(null, def_zone))
			reagents.trans_to_mob(L, reagent_amount, CHEM_BLOOD)

/obj/item/ammo_casing/tranq
	name = "9mm tranq"
	desc = "A special green-tipped 9mm parabellum round, designed to put a target to sleep for a short amount of time."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/tranq

/obj/item/ammo_magazine/mc9mm/tranq
	name = "magazine (9mm tranq)"
	ammo_type = /obj/item/ammo_casing/tranq
