# Bölüm 3 (Kıvrım Kuşağı) — sürü ve kuluçka ağırlıklı dalga tablosu. LevelData.waves_script üzerinden okunur.
extends RefCounted

## Bölüm 3 (Kıvrım Kuşağı) — sürü ve kuluçka ağırlıklı dalgaları.
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
		{"enemy": SWARM, "count": 20, "interval": 0.4, "delay": 0.0},
	],
	# 2
	[
		{"enemy": SCOUT, "count": 10, "interval": 0.9, "delay": 0.0},
		{"enemy": SWARM, "count": 12, "interval": 0.35, "delay": 4.0},
	],
	# 3
	[
		{"enemy": BROOD, "count": 3, "interval": 2.5, "delay": 0.0},
		{"enemy": SWARM, "count": 10, "interval": 0.35, "delay": 4.0},
	],
	# 4
	[
		{"enemy": CRUISER, "count": 2, "interval": 3.5, "delay": 0.0},
		{"enemy": SWARM, "count": 16, "interval": 0.3, "delay": 3.0},
	],
	# 5
	[
		{"enemy": BROOD, "count": 5, "interval": 2.0, "delay": 0.0},
		{"enemy": SCOUT, "count": 12, "interval": 0.8, "delay": 4.0},
	],
	# 6
	[
		{"enemy": SWARM, "count": 30, "interval": 0.22, "delay": 0.0},
		{"enemy": CRUISER, "count": 3, "interval": 3.0, "delay": 6.0},
	],
	# 7
	[
		{"enemy": BROOD, "count": 6, "interval": 1.8, "delay": 0.0},
		{"enemy": SWARM, "count": 20, "interval": 0.25, "delay": 5.0},
	],
	# 8
	[
		{"enemy": SCOUT, "count": 14, "interval": 0.6, "delay": 0.0},
		{"enemy": CRUISER, "count": 5, "interval": 2.5, "delay": 4.0},
		{"enemy": BROOD, "count": 4, "interval": 2.0, "delay": 12.0},
	],
	# 9
	[
		{"enemy": SWARM, "count": 40, "interval": 0.18, "delay": 0.0},
		{"enemy": BROOD, "count": 6, "interval": 1.8, "delay": 6.0},
	],
	# 10
	[
		{"enemy": CRUISER, "count": 6, "interval": 2.0, "delay": 0.0},
		{"enemy": BROOD, "count": 8, "interval": 1.6, "delay": 8.0},
		{"enemy": SWARM, "count": 20, "interval": 0.25, "delay": 14.0},
	],
	# 11
	[
		{"enemy": SCOUT, "count": 20, "interval": 0.45, "delay": 0.0},
		{"enemy": CRUISER, "count": 8, "interval": 1.8, "delay": 6.0},
		{"enemy": SWARM, "count": 30, "interval": 0.2, "delay": 12.0},
	],
	# 12
	[
		{"enemy": BROOD, "count": 10, "interval": 1.5, "delay": 0.0},
		{"enemy": SWARM, "count": 45, "interval": 0.16, "delay": 6.0},
		{"enemy": CRUISER, "count": 8, "interval": 1.8, "delay": 14.0},
	],
	# 13 - BOSS
	[
		{"enemy": SCOUT, "count": 14, "interval": 0.7, "delay": 0.0},
		{"enemy": BOSS, "count": 1, "interval": 0.0, "delay": 4.0},
		{"enemy": SWARM, "count": 36, "interval": 0.2, "delay": 12.0},
		{"enemy": BROOD, "count": 6, "interval": 2.2, "delay": 22.0},
		{"enemy": CRUISER, "count": 4, "interval": 2.5, "delay": 32.0},
	],
]
