/**********************Mine areas**************************/

/area/mine
	icon_state = "mining"
	has_gravity = 1


/area/space/mine
	has_gravity = 1

/area/space/mine/explored
	name = "Mine"
	icon_state = "explored"
	music = null
	has_gravity = 1
	ambientsounds = list('sound/ambience/ambimine.ogg')



/area/space/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"
	music = null
	has_gravity = 1
	ambientsounds = list('sound/ambience/ambimine.ogg')


/area/mine/lobby
	name = "Mining station"

/area/mine/storage
	name = "Mining station Storage"

/area/mine/production
	name = "Mining Station Starboard Wing"
	icon_state = "mining_production"

/area/mine/abandoned
	name = "Abandoned Mining Station"

/area/mine/living_quarters
	name = "Mining Station Port Wing"
	icon_state = "mining_living"

/area/mine/eva
	name = "Mining Station EVA"
	icon_state = "mining_eva"

/area/mine/maintenance
	name = "Mining Station Communications"

/area/mine/cafeteria
	name = "Mining station Cafeteria"

/area/mine/hydroponics
	name = "Mining station Hydroponics"

/area/mine/sleeper
	name = "Mining station Emergency Sleeper"

/area/mine/north_outpost
	name = "North Mining Outpost"

/area/mine/west_outpost
	name = "Research Outpost"

/area/mine/laborcamp
	name = "Labor Camp"

/area/mine/laborcamp/security
	name = "Labor Camp Security"
	icon_state = "security"