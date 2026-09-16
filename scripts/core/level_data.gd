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


func waves() -> Array:
	return waves_script.get_script_constant_map().get("WAVES", [])
