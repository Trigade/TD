class_name EnemyData
extends Resource

## Bir düşman tipinin değerleri. Denge ayarları resources/enemies altındaki .tres dosyalarından yapılır.

@export var display_name := ""
@export var max_health := 50.0
## Piksel/saniye.
@export var speed := 100.0
## Her vuruştan düşülen sabit hasar.
@export var armor := 0.0
## Öldürülünce kazanılan para.
@export var reward := 5
## İstasyona ulaşınca giden can.
@export var lives_damage := 1

@export_group("Görünüm")
@export var radius := 16.0
@export_range(3, 12) var sides := 3
@export var color := Color.WHITE
