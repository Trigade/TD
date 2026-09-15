class_name Projectile
extends Node2D

## Hedefine doğru uçan mermi. Hedef yolda ölürse son bilinen konumuna varıp kaybolur.

var target: Enemy
var damage := 0.0
var speed := 900.0
var color := Color.WHITE

var _destination: Vector2


func _ready() -> void:
	_destination = target.global_position


func _process(delta: float) -> void:
	if _target_alive():
		_destination = target.global_position

	var to_destination := _destination - global_position
	var step := speed * delta
	if to_destination.length() <= step:
		if _target_alive():
			target.take_damage(damage)
		queue_free()
		return

	global_position += to_destination.normalized() * step
	rotation = to_destination.angle()


func _target_alive() -> bool:
	return is_instance_valid(target) and target.health > 0.0


func _draw() -> void:
	draw_line(Vector2(-12, 0), Vector2(4, 0), color, 4.0, true)
	draw_circle(Vector2(4, 0), 3.0, Color.WHITE)
