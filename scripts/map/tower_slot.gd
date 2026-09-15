@tool
class_name TowerSlot
extends Area2D

## Oyuncunun kule inşa edebildiği sabit nokta.

signal clicked(slot: TowerSlot)

const RADIUS := 42.0
const COLOR := Color(0.55, 0.85, 1.0)

var _hovered := false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	mouse_entered.connect(_set_hovered.bind(true))
	mouse_exited.connect(_set_hovered.bind(false))


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)


func _set_hovered(value: bool) -> void:
	_hovered = value
	queue_redraw()


func _draw() -> void:
	var alpha := 0.95 if _hovered else 0.5
	draw_circle(Vector2.ZERO, RADIUS, Color(COLOR, 0.18 if _hovered else 0.08))
	draw_arc(Vector2.ZERO, RADIUS, 0.0, TAU, 48, Color(COLOR, alpha), 3.0, true)
	draw_line(Vector2(-10, 0), Vector2(10, 0), Color(COLOR, alpha), 3.0, true)
	draw_line(Vector2(0, -10), Vector2(0, 10), Color(COLOR, alpha), 3.0, true)
