/obj/item/projectile/bullet/tranq
	name = "bullet"
	damage = 2
	sharp = 1
	embed = 1
	var/reagent_amount = 3
	kill_count = 15 //shorter range
	unacidable = 1

	muzzle_type = null

/obj/item/projectile/bullet/tranq/New()
	reagents = ("stoxin",  3)
	reagents.my_atom = src

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

/obj/item/ammo_magazine/tranq
	name = "tranq cartridge"
	desc = "A rack of hollow darts."
	icon_state = "9x19p"
	mag_type = MAGAZINE
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/tranq
	max_ammo = 8
	multiple_sprites = 1
