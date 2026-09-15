@tool
extends Node2D

## Eta Carinae yörüngesindeki araştırma istasyonu: düşmanların ulaşmaya çalıştığı hedef.

const RADIUS := 70.0
const HULL_COLOR := Color(0.10, 0.18, 0.26)
const TRIM_COLOR := Color(0.5, 0.95, 1.0)
const CORE_COLOR := Color(1.0, 0.85, 0.5)


func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS + 28.0, Color(TRIM_COLOR, 0.07))
	draw_arc(Vector2.ZERO, RADIUS + 18.0, 0.0, TAU, 64, Color(TRIM_COLOR, 0.5), 2.0, true)

	var hull := PackedVector2Array()
	for i in 6:
		hull.append(Vector2.from_angle(TAU * i / 6.0) * RADIUS)
	draw_colored_polygon(hull, HULL_COLOR)
	hull.append(hull[0])
	draw_polyline(hull, TRIM_COLOR, 4.0, true)

	draw_circle(Vector2.ZERO, 26.0, Color(CORE_COLOR, 0.3))
	draw_circle(Vector2.ZERO, 16.0, CORE_COLOR)
