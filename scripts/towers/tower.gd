class_name Tower
extends Node2D

## Kule noktasına inşa edilen kule: menzilindeki, istasyona en yakın düşmanı hedefler ve ateş eder.

const PROJECTILE_SCENE := preload("res://scenes/towers/projectile.tscn")
const BODY_RADIUS := 30.0
const BARREL_LENGTH := 38.0
const BODY_COLOR := Color(0.08, 0.12, 0.18)

var data: TowerData
var show_range := false:
	set(value):
		show_range = value
		queue_redraw()

var _cooldown := 0.0
var _aim_angle := -PI / 2.0


func _process(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)
	var target := _find_target()
	if target == null:
		return
	_aim_angle = (target.global_position - global_position).angle()
	queue_redraw()
	if _cooldown == 0.0:
		_fire(target)
		_cooldown = 1.0 / data.fire_rate


## Menzildeki düşmanlardan yolda en çok ilerlemiş olanı seçer.
func _find_target() -> Enemy:
	var best: Enemy = null
	for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.health <= 0.0:
			continue
		if global_position.distance_to(enemy.global_position) > data.attack_range:
			continue
		if best == null or enemy.progress > best.progress:
			best = enemy
	return best


func _fire(target: Enemy) -> void:
	var projectile: Projectile = PROJECTILE_SCENE.instantiate()
	projectile.target = target
	projectile.damage = data.damage
	projectile.speed = data.projectile_speed
	projectile.color = data.color
	add_child(projectile)
	projectile.global_position = global_position + Vector2.from_angle(_aim_angle) * BARREL_LENGTH


func _draw() -> void:
	if show_range:
		draw_circle(Vector2.ZERO, data.attack_range, Color(data.color, 0.06))
		draw_arc(Vector2.ZERO, data.attack_range, 0.0, TAU, 96, Color(data.color, 0.4), 2.0, true)

	var body := PackedVector2Array()
	for i in data.sides:
		body.append(Vector2.from_angle(PI / data.sides + TAU * i / data.sides) * BODY_RADIUS)
	draw_colored_polygon(body, BODY_COLOR)
	body.append(body[0])
	draw_polyline(body, data.color, 3.0, true)

	draw_line(Vector2.ZERO, Vector2.from_angle(_aim_angle) * BARREL_LENGTH, data.color, 8.0, true)
	draw_circle(Vector2.ZERO, 10.0, data.color)
