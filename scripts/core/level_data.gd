class_name LevelData
extends Resource

## Bir bölümün haritası ve dalgaları.

@export var id := ""
@export var display_name := ""
@export_multiline var description := ""
## Harita sahnesi: içinde EnemyPath, TowerSlots, arka plan ve istasyon bulunur.
@export var map_scene: PackedScene
## İçinde `const WAVES` bulunan dalga tablosu betiği.
@export var waves_script: GDScript
## Zorluğun verdiği paraya eklenir.
@export var starting_money_bonus := 0
## Bölümün kendi zorluğu: düşman canı zorluk çarpanıyla birlikte bununla da çarpılır.
@export var enemy_health_multiplier := 1.0
## Boss'ların canı için ayrı çarpan (enemy_health_multiplier yerine kullanılır).
@export var boss_health_multiplier := 1.0


func waves() -> Array:
	return waves_script.get_script_constant_map().get("WAVES", [])
