plasmapistol = {
	name = "Plasma Pistol",
	customProfile = false,
	additiveReload = false,
	magSize = 15,
	maxAmmo = 300,
	currAmmo = -1,
	spread = 0.025,
	projectiles = 1,
	shotCooldownTime = 0.2,
	fullAuto = false,
	warmupTimeMax = 0,
	warmupWindDown = false,
	burstFireMax = 0,
	maxReloadTime = 2,
	minRndSpread = 1,
	maxRndSpread = 10,
	maxDistance = 100,
	hitForce = 250,
	hitscanBullets = false,
	incendiaryBullets = false,
	explosiveBullets = false,
	explosiveBulletMinSize = 0.3,
	explosiveBulletMaxSize = 0.5,
	projectileBulletSpeed = 5,
	applyForceOnHit = false,
	softRadiusMin = 5,
	softRadiusMax = 5,
	mediumRadiusMin = 5,
	mediumRadiusMax = 5,
	hardRadiusMin = 5,
	hardRadiusMax = 5,
	sfx = {shot = "sfx/pistol_shot.ogg", reload = "sfx/pistol_reload.ogg"},
	sfxLength = {},
	infinitePenetration = false,
	bulletHealth = 5,
	projectileGravity = -1,
	drawProjectileLine = false,
	
	hitParticleSettings = {
		enabled = true,
		ParticleType = "smoke",
		ParticleTile = 0,
		lifetime = 5,
		ParticleColor = {1, 1, 1, 1, 1, 1},
		ParticleRadius = 	{ true, 0.25, 0.5, 1, 0, 1},
		ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
		ParticleGravity = 	{ false, 0, 0, 1, 0, 1},
		ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
		ParticleEmissive = 	{ true, 0, 1, 1, 0, 1},
		ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
		ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
		ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
		ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
	},

	shotSmokeParticleSettings = {
		enabled = true,
		ParticleType = "smoke",
		ParticleTile = 0,
		lifetime = 3,
		ParticleColor = {0, 0.25, 1, 0, 0, 0},
		ParticleRadius = 	{ true, 0.1, 0.3, 1, 0, 1},
		ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
		ParticleGravity = 	{ false, 0.4, 0.4, 1, 0, 1},
		ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
		ParticleEmissive = 	{ true, 1, 0, 1, 0, 1},
		ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
		ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
		ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
		ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
	},

	shotFireParticleSettings = {
		enabled = true,
		ParticleType = "plain",
		ParticleTile = 3,
		lifetime = 0.5,
		ParticleColor = {0, 1, 1, 1, 1, 1},
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
		ParticleType = "smoke",
		ParticleTile = 0,
		lifetime = 0.5,
		ParticleColor = {0, 1, 1, 1, 1, 1},
		ParticleRadius = 	{ true, 0.1, 0.1, 1, 0, 1},
		ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
		ParticleGravity = 	{ false, 1, 1, 1, 0, 1},
		ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
		ParticleEmissive = 	{ true, 1, 0, 1, 0, 1},
		ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
		ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
		ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
		ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
	},
}