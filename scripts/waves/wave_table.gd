class_name WaveTable
extends RefCounted

## Bölüm 1'in dalgaları. Her dalga bir grup listesidir; gruplar aynı dalga içinde üst üste binebilir.
##   enemy    : düşman tipi
##   count    : kaç adet
##   interval : iki düşman arası saniye
##   delay    : dalga başladıktan kaç saniye sonra bu grubun ilk düşmanı çıkar

const SCOUT := preload("res://resources/enemies/scout_drone.tres")
const SWARM := preload("res://resources/enemies/swarm.tres")
const CRUISER := preload("res://resources/enemies/armored_cruiser.tres")
const BROOD := preload("res://resources/enemies/brood.tres")
const BOSS := preload("res://resources/enemies/boss_eta.tres")

const WAVES := [
	# 1
	[
		{"enemy": SCOUT, "count": 6, "interval": 1.5, "delay": 0.0},
	],
	# 2
	[
		{"enemy": SCOUT, "count": 10, "interval": 1.2, "delay": 0.0},
	],
	# 3
	[
		{"enemy": SWARM, "count": 12, "interval": 0.5, "delay": 0.0},
	],
	# 4
	[
		{"enemy": SCOUT, "count": 8, "interval": 1.0, "delay": 0.0},
		{"enemy": SWARM, "count": 10, "interval": 0.5, "delay": 6.0},
	],
	# 5 - ilk zırhlılar
	[
		{"enemy": CRUISER, "count": 2, "interval": 4.0, "delay": 0.0},
		{"enemy": SCOUT, "count": 6, "interval": 1.0, "delay": 3.0},
	],
	# 6 - ilk kuluçkalar
	[
		{"enemy": SWARM, "count": 16, "interval": 0.35, "delay": 0.0},
		{"enemy": BROOD, "count": 2, "interval": 3.0, "delay": 6.0},
	],
	# 7
	[
		{"enemy": SCOUT, "count": 12, "interval": 0.8, "delay": 0.0},
		{"enemy": CRUISER, "count": 3, "interval": 3.5, "delay": 4.0},
	],
	# 8
	[
		{"enemy": SWARM, "count": 20, "interval": 0.3, "delay": 0.0},
		{"enemy": SCOUT, "count": 8, "interval": 1.0, "delay": 5.0},
		{"enemy": BROOD, "count": 3, "interval": 2.5, "delay": 8.0},
	],
	# 9
	[
		{"enemy": CRUISER, "count": 5, "interval": 3.0, "delay": 0.0},
		{"enemy": SWARM, "count": 15, "interval": 0.4, "delay": 6.0},
	],
	# 10
	[
		{"enemy": SCOUT, "count": 15, "interval": 0.6, "delay": 0.0},
		{"enemy": SWARM, "count": 20, "interval": 0.3, "delay": 4.0},
		{"enemy": CRUISER, "count": 4, "interval": 3.0, "delay": 10.0},
		{"enemy": BROOD, "count": 3, "interval": 3.0, "delay": 14.0},
	],
	# 11
	[
		{"enemy": CRUISER, "count": 8, "interval": 2.5, "delay": 0.0},
		{"enemy": SWARM, "count": 24, "interval": 0.25, "delay": 8.0},
		{"enemy": BROOD, "count": 4, "interval": 2.5, "delay": 12.0},
	],
	# 12
	[
		{"enemy": SCOUT, "count": 20, "interval": 0.5, "delay": 0.0},
		{"enemy": SWARM, "count": 32, "interval": 0.2, "delay": 5.0},
		{"enemy": CRUISER, "count": 8, "interval": 2.0, "delay": 12.0},
		{"enemy": BROOD, "count": 5, "interval": 2.5, "delay": 18.0},
	],
	# 13 - BOSS: Eta Canavarı ve eskortları
	[
		{"enemy": SCOUT, "count": 12, "interval": 0.8, "delay": 0.0},
		{"enemy": BOSS, "count": 1, "interval": 0.0, "delay": 4.0},
		{"enemy": SWARM, "count": 30, "interval": 0.25, "delay": 12.0},
		{"enemy": BROOD, "count": 4, "interval": 3.0, "delay": 25.0},
		{"enemy": CRUISER, "count": 4, "interval": 3.0, "delay": 35.0},
	],
]
