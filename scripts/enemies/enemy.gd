class_name Enemy
extends PathFollow2D

## Yolu takip eden düşman. Özellikleri bir EnemyData kaynağından gelir.

signal reached_end(enemy: Enemy)
signal died(enemy: Enemy)

const HEALTH_BAR_SIZE := Vector2(34, 5)
const HEALTH_BAR_BACK := Color(0, 0, 0, 0.6)
const HEALTH_BAR_FILL := Color(0.4, 1.0, 0.5)

var data: EnemyData
var health: float

var _heading := 0.0


func _ready() -> void:
	health = data.max_health
	add_to_group("enemies")


func _process(delta: float) -> void:
	var previous := position
	progress += data.speed * delta
	var movement := position - previous
	if not movement.is_zero_approx():
		_heading = movement.angle()

	if progress_ratio >= 1.0:
		reached_end.emit(self)
		queue_free()
		return
	queue_redraw()


## Zırh her vuruştan sabit miktar düşer, ama her vuruş en az 1 hasar verir.
func take_damage(amount: float) -> void:
	if health <= 0.0:
		return
	health -= maxf(amount - data.armor, 1.0)
	if health <= 0.0:
		died.emit(self)
		queue_free()


func _draw() -> void:
	# İlk köşe hareket yönüne bakar; üçgen düşmanlar böylece gittiği yönü gösterir.
	var shape := PackedVector2Array()
	for i in data.sides:
		shape.append(Vector2.from_angle(_heading + TAU * i / data.sides) * data.radius)
	draw_colored_polygon(shape, Color(data.color, 0.35))
	shape.append(shape[0])
	draw_polyline(shape, data.color, 3.0, true)

	if health < data.max_health:
		var origin := Vector2(-HEALTH_BAR_SIZE.x * 0.5, -data.radius - 12.0)
		var fill := Vector2(HEALTH_BAR_SIZE.x * health / data.max_health, HEALTH_BAR_SIZE.y)
		draw_rect(Rect2(origin, HEALTH_BAR_SIZE), HEALTH_BAR_BACK)
		draw_rect(Rect2(origin, fill), HEALTH_BAR_FILL)
