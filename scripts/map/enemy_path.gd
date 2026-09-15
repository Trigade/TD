@tool
extends Path2D

## Düşmanların izlediği sabit yol. Şimdilik geometrik olarak çiziliyor.

const WIDTH := 64.0
const EDGE_WIDTH := 5.0
const EDGE_COLOR := Color(0.95, 0.55, 0.25, 0.6)
const FILL_COLOR := Color(0.14, 0.09, 0.18, 0.95)


func _ready() -> void:
	if curve and not curve.changed.is_connected(queue_redraw):
		curve.changed.connect(queue_redraw)


func _draw() -> void:
	if curve == null or curve.point_count < 2:
		return
	var points := curve.get_baked_points()
	_draw_band(points, WIDTH + EDGE_WIDTH * 2.0, EDGE_COLOR)
	_draw_band(points, WIDTH, FILL_COLOR)


func _draw_band(points: PackedVector2Array, width: float, color: Color) -> void:
	draw_polyline(points, color, width, true)
	# Kalın çizgilerin köşelerinde oluşan boşlukları yuvarlak kapaklarla kapat.
	for i in curve.point_count:
		draw_circle(curve.get_point_position(i), width * 0.5, color)
