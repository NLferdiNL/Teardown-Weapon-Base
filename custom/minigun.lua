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
	bulletHealth = 0,
	projectileGravity = 0,
	drawProjectileLine = true,
	
	hitParticleSettings = {
		enabled = true,
		ParticleType = "smoke",
		ParticleTile = 0,
		lifetime = 5,
		ParticleColor = {1, 1, 1, 1, 1, 1},
		ParticleRadius = 	{ true, 0.5, 1, "linear", 0, 1},
		ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
		ParticleGravity = 	{ false, 0, 0, "linear", 0, 1},
		ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
		ParticleEmissive = 	{ false, 0, 0, "linear", 0, 1},
		ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
		ParticleStretch = 	{ false, 0, 0, "linear", 0, 1},
		ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
		ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
	},

	shotSmokeParticleSettings = {
		enabled = true,
		ParticleType = "smoke",
		ParticleTile = 0,
		lifetime = 3,
		ParticleColor = {1, 1, 1, 0, 0, 0},
		ParticleRadius = 	{ true, 0.1, 0.3, "linear", 0, 1},
		ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
		ParticleGravity = 	{ true, 0.4, 0.4, "linear", 0, 1},
		ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
		ParticleEmissive = 	{ false, 0, 0, "linear", 0, 1},
		ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
		ParticleStretch = 	{ false, 0, 0, "linear", 0, 1},
		ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
		ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
	},

	shotFireParticleSettings = {
		enabled = true,
		ParticleType = "plain",
		ParticleTile = 3,
		lifetime = 0.3,
		ParticleColor = {1, 0.75, 0.4, 0, 0, 0},
		ParticleRadius = 	{ true, 0.4, 0.2, "smooth", 0, 1},
		ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
		ParticleGravity = 	{ false, 0, 0, "linear", 0, 1},
		ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
		ParticleEmissive = 	{ true, 1, 0, "smooth", 0, 1},
		ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
		ParticleStretch = 	{ true, 1, 0.3, "linear", 0, 1},
		ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
		ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
	},

	projectileParticleSettings = {
		enabled = false,
		ParticleType = "smoke",
		ParticleTile = 0,
		lifetime = 3,
		ParticleColor = {0.25, 0.25, 0.25, 1, 1, 1},
		ParticleRadius = 	{ true, 0.5, 1, "linear", 0, 1},
		ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
		ParticleGravity = 	{ true, 1, 1, "linear", 0, 1},
		ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
		ParticleEmissive = 	{ false, 0, 0, "linear", 0, 1},
		ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
		ParticleStretch = 	{ false, 0, 0, "linear", 0, 1},
		ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
		ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
	},
}