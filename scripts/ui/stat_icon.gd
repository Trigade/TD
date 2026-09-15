@tool
class_name StatIcon
extends Control

## Üst bardaki değerlerin yanında duran küçük geometrik ikon.

@export_range(3, 32) var sides := 6:
	set(value):
		sides = value
		queue_redraw()
@export var color := Color.WHITE:
	set(value):
		color = value
		queue_redraw()
## Derece.
@export var angle_offset := 0.0:
	set(value):
		angle_offset = value
		queue_redraw()


func _draw() -> void:
	var center := size * 0.5
	var radius := minf(size.x, size.y) * 0.5 - 2.0
	var shape := PackedVector2Array()
	for i in sides:
		shape.append(center + Vector2.from_angle(deg_to_rad(angle_offset) + TAU * i / sides) * radius)
	draw_colored_polygon(shape, Color(color, 0.3))
	shape.append(shape[0])
	draw_polyline(shape, color, 2.5, true)
