class_name RingEffect
extends Node2D

## Kısa süre büyüyüp sönen halka: patlama ve yerçekimi dalgası efektleri için.

const DURATION := 0.35

var radius := 50.0
var color := Color.WHITE

var _elapsed := 0.0


static func spawn(parent: Node, at: Vector2, effect_radius: float, effect_color: Color) -> void:
	var effect := RingEffect.new()
	effect.radius = effect_radius
	effect.color = effect_color
	effect.top_level = true
	effect.z_index = 9
	parent.add_child(effect)
	effect.global_position = at


func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= DURATION:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var t := _elapsed / DURATION
	var current_radius := radius * ease(t, 0.4)
	draw_circle(Vector2.ZERO, current_radius, Color(color, 0.15 * (1.0 - t)))
	draw_arc(Vector2.ZERO, current_radius, 0.0, TAU, 48, Color(color, 0.8 * (1.0 - t)), 3.0, true)
