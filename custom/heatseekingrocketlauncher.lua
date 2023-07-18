heatseekingrocketlauncher = {
	name = "Heat Seeking Rocket Launcher",
	customProfile = false,
	additiveReload = false,
	magSize = 1,
	maxAmmo = 30,
	currAmmo = -1,
	spread = 0.01,
	projectiles = 1,
	shotCooldownTime = 0.01,
	fullAuto = false,
	warmupTimeMax = 0,
	warmupWindDown = false,
	burstFireMax = 0,
	maxReloadTime = 1.196,
	minXSpread = 0,
	maxXSpread = 10,
	minYSpread = 0,
	maxYSpread = 10,
	maxDistance = 200,
	hitForce = 6000,
	hitscanBullets = false,
	incendiaryBullets = false,
	explosiveBullets = true,
	explosiveBulletMinSize = 2.8,
	explosiveBulletMaxSize = 3,
	projectileBulletSpeed = 5,
	applyForceOnHit = false,
	softRadiusMin = 3,
	softRadiusMax = 4,
	mediumRadiusMin = 2,
	mediumRadiusMax = 3,
	hardRadiusMin = 1,
	hardRadiusMax = 2,
	sfx = {shot = "sfx/rpg_shot.ogg", reload = "sfx/rpg_reload.ogg" },
	sfxLength = {},
	infinitePenetration = false,
	bulletHealth = 0,
	projectileGravity = -0.1,
	projectileBouncyness = 0,
	drawProjectileLine = false,
	finalHitDmgMultiplier = 1,
	lineColorRed = 1,
	lineColorGreen = 1,
	lineColorBlue = 1,
	lineColorAlpha = 1,
	finalHitExplosion = false,
	laserSeeker = true,
	laserSeekerTurnSpeed = 3.5,
	
	hitParticleSettings = {
		enabled = false,
		ParticleType = 1,
		ParticleTile = 0,
		lifetime = 5,
		flags = 0,
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
		enabled = true,
		ParticleType = 1,
		ParticleTile = 0,
		lifetime = 3,
		flags = 0,
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
		enabled = true,
		ParticleType = 2,
		ParticleTile = 3,
		lifetime = 0.3,
		flags = 0,
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
		enabled = true,
		ParticleType = 1,
		ParticleTile = 0,
		lifetime = 0.4,
		flags = 0,
		ParticleColor = {1, 0.25, 0, 0, 0, 0},
		ParticleRadius = 	{ true, 0.1, 1, 1, 0, 1},
		ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
		ParticleGravity = 	{ false, 1, 1, 1, 0, 1},
		ParticleDrag = 		{ true, 0, 0, 1, 0, 1},
		ParticleEmissive = 	{ true, 10, 0, 1, 0, 1},
		ParticleRotation = 	{ true, 0, 5, 1, 0, 1},
		ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
		ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
		ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
	},
}