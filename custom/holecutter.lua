holecutter = {
	name = "Hole Cutter",
	customProfile = false,
	additiveReload = false,
	magSize = 100,
	maxAmmo = 300,
	currAmmo = -1,
	spread = 0.05,
	projectiles = 10,
	shotCooldownTime = 0.05,
	fullAuto = true,
	warmupTimeMax = 0,
	warmupWindDown = false,
	burstFireMax = 0,
	maxReloadTime = 2.5,
	minXSpread = 1,
	maxXSpread = 1,
	minYSpread = 1,
	maxYSpread = 1,
	maxDistance = 100,
	hitForce = 1000,
	hitscanBullets = true,
	incendiaryBullets = false,
	explosiveBullets = false,
	explosiveBulletMinSize = 0.3,
	explosiveBulletMaxSize = 0.5,
	projectileBulletSpeed = 80,
	applyForceOnHit = false,
	softRadiusMin = 3,
	softRadiusMax = 3,
	mediumRadiusMin = 3,
	mediumRadiusMax = 3,
	hardRadiusMin = 3,
	hardRadiusMax = 3,
	sfx = { shot_loop = "sfx/lasercutter_shot_loop.ogg", },
	sfxLength = { shot_start = 0},
	infinitePenetration = false,
	bulletHealth = 0,
	projectileGravity = 0,
	projectileBouncyness = 0,
	drawProjectileLine = true,
	
	hitParticleSettings = {
		enabled = false,
		ParticleType = 1,
		ParticleTile = 0,
		lifetime = 5,
		ParticleColor = {1, 1, 1, 1, 1, 1},
		ParticleRadius = 	{ true, 0.5, 1, 1, 0, 1},
		ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
		ParticleGravity = 	{ false, 0, 0, 1, 0, 1},
		ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
		ParticleEmissive = 	{ false, 0, 0, 1, 0, 1},
		ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
		ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
		ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
		ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
	},

	shotSmokeParticleSettings = {
		enabled = false,
		ParticleType = 1,
		ParticleTile = 0,
		lifetime = 3,
		ParticleColor = {1, 1, 1, 0, 0, 0},
		ParticleRadius = 	{ true, 0.1, 0.3, 1, 0, 1},
		ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
		ParticleGravity = 	{ true, 0.4, 0.4, 1, 0, 1},
		ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
		ParticleEmissive = 	{ false, 0, 0, 1, 0, 1},
		ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
		ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
		ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
		ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
	},

	shotFireParticleSettings = {
		enabled = false,
		ParticleType = 2,
		ParticleTile = 3,
		lifetime = 0.3,
		ParticleColor = {1, 0.75, 0.4, 0, 0, 0},
		ParticleRadius = 	{ true, 0.4, 0.2, 2, 0, 1},
		ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
		ParticleGravity = 	{ false, 0, 0, 1, 0, 1},
		ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
		ParticleEmissive = 	{ true, 1, 0, 2, 0, 1},
		ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
		ParticleStretch = 	{ true, 1, 0.3, 1, 0, 1},
		ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
		ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
	},

	projectileParticleSettings = {
		enabled = false,
		ParticleType = 1,
		ParticleTile = 0,
		lifetime = 3,
		ParticleColor = {0.25, 0.25, 0.25, 1, 1, 1},
		ParticleRadius = 	{ true, 0.5, 1, 1, 0, 1},
		ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
		ParticleGravity = 	{ true, 1, 1, 1, 0, 1},
		ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
		ParticleEmissive = 	{ false, 0, 0, 1, 0, 1},
		ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
		ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
		ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
		ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
	},
}