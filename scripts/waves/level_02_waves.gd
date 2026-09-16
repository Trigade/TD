# Bölüm 2 dalga tablosu. LevelData.waves_script üzerinden okunur.
extends RefCounted

## Bölüm 2'nin dalgaları: zırhlılar ve kuluçkalar 1. bölüme göre daha erken gelir.
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
		{"enemy": SWARM, "count": 14, "interval": 0.45, "delay": 0.0},
	],
	# 3
	[
		{"enemy": SCOUT, "count": 10, "interval": 0.9, "delay": 0.0},
		{"enemy": SWARM, "count": 8, "interval": 0.4, "delay": 5.0},
	],
	# 4 - zırhlılar erken geliyor
	[
		{"enemy": CRUISER, "count": 2, "interval": 4.0, "delay": 0.0},
		{"enemy": SCOUT, "count": 8, "interval": 1.0, "delay": 2.0},
	],
	# 5
	[
		{"enemy": SWARM, "count": 18, "interval": 0.3, "delay": 0.0},
		{"enemy": BROOD, "count": 2, "interval": 3.0, "delay": 5.0},
	],
	# 6
	[
		{"enemy": SCOUT, "count": 12, "interval": 0.7, "delay": 0.0},
		{"enemy": CRUISER, "count": 3, "interval": 3.0, "delay": 4.0},
	],
	# 7
	[
		{"enemy": BROOD, "count": 3, "interval": 2.5, "delay": 0.0},
		{"enemy": SWARM, "count": 20, "interval": 0.3, "delay": 5.0},
	],
	# 8
	[
		{"enemy": CRUISER, "count": 5, "interval": 2.5, "delay": 0.0},
		{"enemy": SCOUT, "count": 12, "interval": 0.7, "delay": 6.0},
	],
	# 9
	[
		{"enemy": SWARM, "count": 25, "interval": 0.25, "delay": 0.0},
		{"enemy": BROOD, "count": 4, "interval": 2.5, "delay": 6.0},
	],
	# 10
	[
		{"enemy": SCOUT, "count": 16, "interval": 0.5, "delay": 0.0},
		{"enemy": CRUISER, "count": 6, "interval": 2.5, "delay": 6.0},
		{"enemy": BROOD, "count": 3, "interval": 3.0, "delay": 14.0},
	],
	# 11
	[
		{"enemy": CRUISER, "count": 7, "interval": 2.0, "delay": 0.0},
		{"enemy": SWARM, "count": 30, "interval": 0.22, "delay": 8.0},
		{"enemy": BROOD, "count": 4, "interval": 2.5, "delay": 12.0},
	],
	# 12
	[
		{"enemy": SCOUT, "count": 20, "interval": 0.45, "delay": 0.0},
		{"enemy": SWARM, "count": 35, "interval": 0.2, "delay": 4.0},
		{"enemy": CRUISER, "count": 7, "interval": 1.8, "delay": 10.0},
		{"enemy": BROOD, "count": 5, "interval": 2.2, "delay": 16.0},
	],
	# 13 - BOSS
	[
		{"enemy": SCOUT, "count": 12, "interval": 0.7, "delay": 0.0},
		{"enemy": BOSS, "count": 1, "interval": 0.0, "delay": 4.0},
		{"enemy": SWARM, "count": 30, "interval": 0.22, "delay": 12.0},
		{"enemy": BROOD, "count": 4, "interval": 2.5, "delay": 24.0},
		{"enemy": CRUISER, "count": 3, "interval": 2.5, "delay": 34.0},
	],
]
