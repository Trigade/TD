class_name Projectile
extends Node2D

## Hedefine doğru uçan mermi. Hedef yolda ölürse son bilinen konumuna varır:
## alan hasarlı mermi yine de patlar, tek hedefli mermi boşa gider.

var target: Enemy
var damage := 0.0
var speed := 900.0
var armor_piercing := 0.0
var splash_radius := 0.0
var color := Color.WHITE
var thickness := 4.0

var _destination: Vector2


func _ready() -> void:
	_destination = target.global_position


func _process(delta: float) -> void:
	if _target_alive():
		_destination = target.global_position

	var to_destination := _destination - global_position
	var step := speed * delta
	if to_destination.length() <= step:
		_impact()
		return

	global_position += to_destination.normalized() * step
	rotation = to_destination.angle()


func _impact() -> void:
	if splash_radius > 0.0:
		for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
			if enemy.global_position.distance_to(_destination) <= splash_radius + enemy.data.radius:
				enemy.take_damage(damage, armor_piercing)
		RingEffect.spawn(get_parent(), _destination, splash_radius, color)
	elif _target_alive():
		target.take_damage(damage, armor_piercing)
	queue_free()


func _target_alive() -> bool:
	return is_instance_valid(target) and target.health > 0.0


func _draw() -> void:
	if splash_radius > 0.0:
		draw_circle(Vector2.ZERO, thickness, color)
		draw_circle(Vector2.ZERO, thickness * 0.45, Color.WHITE)
	else:
		draw_line(Vector2(-12, 0), Vector2(4, 0), color, thickness, true)
		draw_circle(Vector2(4, 0), thickness * 0.75, Color.WHITE)
