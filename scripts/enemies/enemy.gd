class_name Enemy
extends PathFollow2D

## Yolu takip eden düşman. Özellikleri bir EnemyData kaynağından gelir.

signal reached_end(enemy: Enemy)
signal died(enemy: Enemy)

const HEALTH_BAR_SIZE := Vector2(34, 5)
const HEALTH_BAR_BACK := Color(0, 0, 0, 0.6)
const HEALTH_BAR_FILL := Color(0.4, 1.0, 0.5)
const SLOW_RING_COLOR := Color(0.6, 0.5, 1.0, 0.8)

var data: EnemyData
## Dalga ilerledikçe düşmanları güçlendirmek için temel canı çarpar; sahneye eklenmeden önce ayarlanır.
var health_multiplier := 1.0
var max_health: float
var health: float

var _heading := 0.0
var _slow_factor := 0.0
var _slow_time_left := 0.0


func _ready() -> void:
	max_health = data.max_health * health_multiplier
	health = max_health
	add_to_group("enemies")


func _process(delta: float) -> void:
	if _slow_time_left > 0.0:
		_slow_time_left -= delta
		if _slow_time_left <= 0.0:
			_slow_factor = 0.0

	var previous := position
	progress += data.speed * (1.0 - _slow_factor) * delta
	var movement := position - previous
	if not movement.is_zero_approx():
		_heading = movement.angle()

	if progress_ratio >= 1.0:
		reached_end.emit(self)
		queue_free()
		return
	queue_redraw()


## Zırh her vuruştan sabit miktar düşer, ama her vuruş en az 1 hasar verir.
## armor_piercing zırhın ne kadarının yok sayılacağını belirler (0–1).
func take_damage(amount: float, armor_piercing := 0.0) -> void:
	if health <= 0.0:
		return
	var armor := data.armor * (1.0 - armor_piercing)
	health -= maxf(amount - armor, 1.0)
	if health <= 0.0:
		died.emit(self)
		queue_free()


## Yavaşlatmalar üst üste binmez; o an en güçlü olanı geçerlidir.
func apply_slow(factor: float, duration: float) -> void:
	if factor < _slow_factor:
		return
	_slow_factor = factor
	_slow_time_left = maxf(_slow_time_left, duration)


func _draw() -> void:
	# İlk köşe hareket yönüne bakar; üçgen düşmanlar böylece gittiği yönü gösterir.
	var shape := PackedVector2Array()
	for i in data.sides:
		shape.append(Vector2.from_angle(_heading + TAU * i / data.sides) * data.radius)
	draw_colored_polygon(shape, Color(data.color, 0.35))
	shape.append(shape[0])
	draw_polyline(shape, data.color, 3.0, true)

	if _slow_factor > 0.0:
		draw_arc(Vector2.ZERO, data.radius + 7.0, 0.0, TAU, 32, SLOW_RING_COLOR, 2.0, true)

	if health < max_health:
		var origin := Vector2(-HEALTH_BAR_SIZE.x * 0.5, -data.radius - 14.0)
		var fill := Vector2(HEALTH_BAR_SIZE.x * health / max_health, HEALTH_BAR_SIZE.y)
		draw_rect(Rect2(origin, HEALTH_BAR_SIZE), HEALTH_BAR_BACK)
		draw_rect(Rect2(origin, fill), HEALTH_BAR_FILL)
