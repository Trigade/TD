class_name TowerData
extends Resource

## Bir kule tipinin değerleri. Denge ayarları resources/towers altındaki .tres dosyalarından yapılır.

@export var display_name := ""
@export_multiline var description := ""
@export var cost := 50
@export var damage := 10.0
## Saniyedeki atış sayısı.
@export var fire_rate := 1.0
## Piksel.
@export var attack_range := 200.0
## Piksel/saniye.
@export var projectile_speed := 900.0

@export_group("Görünüm")
@export_range(3, 12) var sides := 4
@export var color := Color.WHITE
