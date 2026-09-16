@tool
class_name StarRow
extends Control

## Kazanılan yıldızları gösterir (0–3).

const STAR_COUNT := 3
const FILLED_COLOR := Color(1.0, 0.85, 0.45)
const EMPTY_COLOR := Color(0.42, 0.47, 0.58)

@export_range(0, 3) var stars := 0:
	set(value):
		stars = value
		queue_redraw()


func _draw() -> void:
	var step := size.x / STAR_COUNT
	var radius := minf(step * 0.42, size.y * 0.5 - 2.0)
	for i in STAR_COUNT:
		var center := Vector2(step * (i + 0.5), size.y * 0.5)
		_draw_star(center, radius, i < stars)


func _draw_star(center: Vector2, radius: float, filled: bool) -> void:
	var color := FILLED_COLOR if filled else EMPTY_COLOR
	var points := PackedVector2Array()
	for i in 10:
		var point_radius := radius if i % 2 == 0 else radius * 0.45
		points.append(center + Vector2.from_angle(-PI / 2.0 + TAU * i / 10.0) * point_radius)
	if filled:
		draw_colored_polygon(points, Color(color, 0.85))
	points.append(points[0])
	draw_polyline(points, color, 2.0, true)
