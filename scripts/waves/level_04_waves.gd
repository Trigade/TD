# Bölüm 4 (Toz Sütunları) — zırhlı ağırlıklı dalga tablosu. LevelData.waves_script üzerinden okunur.
extends RefCounted

## Bölüm 4 (Toz Sütunları) — zırhlı ağırlıklı dalgaları.
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
		{"enemy": SCOUT, "count": 8, "interval": 1.2, "delay": 0.0},
	],
	# 2
	[
		{"enemy": CRUISER, "count": 2, "interval": 4.0, "delay": 0.0},
		{"enemy": SCOUT, "count": 6, "interval": 1.0, "delay": 3.0},
	],
	# 3
	[
		{"enemy": SWARM, "count": 14, "interval": 0.4, "delay": 0.0},
		{"enemy": CRUISER, "count": 3, "interval": 3.5, "delay": 4.0},
	],
	# 4
	[
		{"enemy": CRUISER, "count": 4, "interval": 3.0, "delay": 0.0},
		{"enemy": SCOUT, "count": 10, "interval": 0.8, "delay": 5.0},
	],
	# 5
	[
		{"enemy": BROOD, "count": 3, "interval": 2.5, "delay": 0.0},
		{"enemy": CRUISER, "count": 4, "interval": 3.0, "delay": 4.0},
	],
	# 6
	[
		{"enemy": CRUISER, "count": 6, "interval": 2.5, "delay": 0.0},
		{"enemy": SWARM, "count": 20, "interval": 0.3, "delay": 6.0},
	],
	# 7
	[
		{"enemy": SCOUT, "count": 16, "interval": 0.6, "delay": 0.0},
		{"enemy": CRUISER, "count": 6, "interval": 2.2, "delay": 5.0},
	],
	# 8
	[
		{"enemy": CRUISER, "count": 8, "interval": 2.0, "delay": 0.0},
		{"enemy": BROOD, "count": 4, "interval": 2.2, "delay": 10.0},
	],
	# 9
	[
		{"enemy": SWARM, "count": 30, "interval": 0.22, "delay": 0.0},
		{"enemy": CRUISER, "count": 8, "interval": 2.0, "delay": 6.0},
	],
	# 10
	[
		{"enemy": CRUISER, "count": 10, "interval": 1.8, "delay": 0.0},
		{"enemy": SCOUT, "count": 18, "interval": 0.5, "delay": 8.0},
		{"enemy": BROOD, "count": 4, "interval": 2.2, "delay": 16.0},
	],
	# 11
	[
		{"enemy": CRUISER, "count": 12, "interval": 1.6, "delay": 0.0},
		{"enemy": SWARM, "count": 30, "interval": 0.2, "delay": 10.0},
	],
	# 12
	[
		{"enemy": SCOUT, "count": 20, "interval": 0.45, "delay": 0.0},
		{"enemy": CRUISER, "count": 12, "interval": 1.5, "delay": 6.0},
		{"enemy": BROOD, "count": 6, "interval": 2.0, "delay": 16.0},
	],
	# 13 - BOSS
	[
		{"enemy": SCOUT, "count": 10, "interval": 0.8, "delay": 0.0},
		{"enemy": BOSS, "count": 1, "interval": 0.0, "delay": 4.0},
		{"enemy": CRUISER, "count": 8, "interval": 2.0, "delay": 14.0},
		{"enemy": SWARM, "count": 25, "interval": 0.22, "delay": 24.0},
		{"enemy": BROOD, "count": 4, "interval": 2.5, "delay": 30.0},
	],
]
