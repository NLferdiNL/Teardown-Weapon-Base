blankProfile = {
	name = "Blank Profile",
	customProfile = true,
	additiveReload = false,
	magSize = 15,
	maxAmmo = 500,
	currAmmo = -1,
	currMag = -1,
	spread = 0,
	projectiles = 1,
	shotCooldownTime = 0.1,
	fullAuto = false,
	warmupTimeMax = 0,
	warmupWindDown = false,
	burstFireMax = 0,
	maxReloadTime = 1,
	minRndSpread = 1,
	maxRndSpread = 10,
	maxDistance = 100,
	hitForce = 3000,
	hitscanBullets = false,
	incendiaryBullets = false,
	explosiveBullets = false,
	explosiveBulletMinSize = 0.3,
	explosiveBulletMaxSize = 0.5,
	projectileBulletSpeed = 100,
	applyForceOnHit = true,
	softRadiusMin = 2,
	softRadiusMax = 3,
	mediumRadiusMin = 1.5,
	mediumRadiusMax = 2,
	hardRadiusMin = 1,
	hardRadiusMax = 1.5,
	sfx = {shot = "sfx/pistol_shot.ogg", reload = "sfx/pistol_reload.ogg"},
	sfxLength = {},
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