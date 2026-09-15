class_name TowerData
extends Resource

## Bir kule tipinin değerleri. Denge ayarları resources/towers altındaki .tres dosyalarından yapılır.

enum AttackMode {
	## Menzildeki en öndeki düşmana mermi atar.
	PROJECTILE,
	## Menzildeki tüm düşmanlara aynı anda etki eden dalga yayar.
	PULSE,
}

@export var display_name := ""
@export_multiline var description := ""
@export var cost := 50
@export var attack_mode := AttackMode.PROJECTILE
@export var damage := 10.0
## Saniyedeki atış (veya dalga) sayısı.
@export var fire_rate := 1.0
## Piksel.
@export var attack_range := 200.0
## Piksel/saniye.
@export var projectile_speed := 900.0
## Hedefin zırhının yok sayılan oranı: 0 = hiç, 1 = tamamı.
@export_range(0.0, 1.0) var armor_piercing := 0.0
## 0'dan büyükse mermi çarptığı yerde bu yarıçapta patlar.
@export var splash_radius := 0.0

@export_group("Yavaşlatma")
## Hızdan düşülen oran: 0.4 = düşman %40 yavaşlar.
@export_range(0.0, 1.0) var slow_factor := 0.0
## Saniye.
@export var slow_duration := 0.0

@export_group("Görünüm")
@export_range(3, 12) var sides := 4
@export var color := Color.WHITE
@export var barrel_width := 8.0
