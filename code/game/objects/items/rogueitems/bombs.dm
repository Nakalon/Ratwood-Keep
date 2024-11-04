
/obj/item/bomb
	name = "bottle bomb"
	desc = "Dangerous explosion, in a bottle."
	icon_state = "clear_bomb"
	var/lit_state = "clear_bomb_lit"
	icon = 'icons/roguetown/items/cooking.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	var/fuze = 50
	var/lit = FALSE
	var/prob2fail = 23


/obj/item/bomb/spark_act()
	light()

/obj/item/bomb/fire_act()
	light()

/obj/item/bomb/ex_act()
	if(!QDELETED(src))
		lit = TRUE
		explode(TRUE)

/obj/item/bomb/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = lit_state
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/bomb/extinguish()
	snuff()

/obj/item/bomb/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = initial(icon_state)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/bomb/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				explosion(T, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
		else
			if(prob(prob2fail))
				snuff()
			else
				playsound(T, 'sound/items/firesnuff.ogg', 100)
				new /obj/item/shard (T)
	qdel(src)

/obj/item/bomb/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	explode()

/obj/item/bomb/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/bomb/dryad
	name = "bottle bomb"
	desc = "Dangerous explosion, in a bottle."
	icon_state = "clear_bomb"
	lit_state = "clear_bomb_lit"
	prob2fail = 0

/obj/item/bomb/dryad/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			new /mob/living/simple_animal/hostile/retaliate/rogue/bigrat(T)
			playsound(T, pick('sound/vo/mobs/skel/skeleton_scream (1).ogg', 'sound/vo/mobs/skel/skeleton_scream (1).ogg'), 100)
			explosion(T, light_impact_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
			//playsound(T, pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'), 100)
			qdel(src)
