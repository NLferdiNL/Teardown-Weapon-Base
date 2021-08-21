minigun = {
	name = "Minigun",
	customProfile = false,
	additiveReload = false,
	magSize = 300,
	maxAmmo = 3000,
	currAmmo = -1,
	spread = 0.03,
	projectiles = 1,
	shotCooldownTime = 0.05,
	fullAuto = true,
	warmupTimeMax = 1,
	warmupWindDown = true,
	burstFireMax = 0,
	maxReloadTime = 4,
	minRndSpread = 1,
	maxRndSpread = 10,
	maxDistance = 75,
	hitForce = 6000,
	hitscanBullets = false,
	incendiaryBullets = false,
	explosiveBullets = false,
	explosiveBulletMinSize = 0.3,
	explosiveBulletMaxSize = 0.5,
	projectileBulletSpeed = 120,
	applyForceOnHit = true,
	softRadiusMin = 2,
	softRadiusMax = 3,
	mediumRadiusMin = 2,
	mediumRadiusMax = 2.5,
	hardRadiusMin = 0.5,
	hardRadiusMax = 1,
	sfx = {warmup_start = "sfx/minigun_warmup_start.ogg", 
		   warmup_loop = "sfx/minigun_warmup_loop.ogg", 
		   warmup_stop = "sfx/minigun_warmup_stop.ogg", 
		   shot_start = "sfx/minigun_shot_start.ogg", 
		   shot_loop = "sfx/minigun_shot_loop.ogg", 
		  },
	sfxLength = { warmup_start = 0.227, 
				  warmup_stop = 2.151, 
				  shot_start = 0.74 * 0.15, 
				  shot_stop = 2.151, 
				},
	infinitePenetration = false,
	particlesEnabled = true,
}