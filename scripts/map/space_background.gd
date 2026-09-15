@tool
extends Node2D

## Carina Nebulası esintili geometrik arka plan: koyu uzay, bulutsu lekeleri ve yıldızlar.

const SIZE := Vector2(1920, 1080)
const SPACE_COLOR := Color(0.03, 0.03, 0.07)
const STAR_COUNT := 220
const STAR_SEED := 2026
const GLOW_STEPS := 8

## Her bulut: merkez, yarıçap, renk (Carina'nın pas turuncusu, iyonize gaz turkuazı ve macenta tonları).
const CLOUDS := [
	{"center": Vector2(260, 920), "radius": 560.0, "color": Color(0.85, 0.35, 0.18, 0.05)},
	{"center": Vector2(1500, 180), "radius": 620.0, "color": Color(0.20, 0.65, 0.75, 0.045)},
	{"center": Vector2(980, 620), "radius": 480.0, "color": Color(0.70, 0.22, 0.55, 0.035)},
	{"center": Vector2(1780, 980), "radius": 420.0, "color": Color(0.95, 0.60, 0.25, 0.04)},
]

var _stars: Array[Dictionary] = []


func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = STAR_SEED
	for i in STAR_COUNT:
		_stars.append({
			"position": Vector2(rng.randf() * SIZE.x, rng.randf() * SIZE.y),
			"radius": rng.randf_range(0.6, 2.2),
			"alpha": rng.randf_range(0.25, 0.95),
		})
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, SIZE), SPACE_COLOR)

	# Üst üste binen yarı saydam daireler, merkezi parlak yumuşak bir bulut etkisi verir.
	for cloud in CLOUDS:
		for step in GLOW_STEPS:
			var radius: float = cloud.radius * (1.0 - float(step) / GLOW_STEPS)
			draw_circle(cloud.center, radius, cloud.color)

	for star in _stars:
		draw_circle(star.position, star.radius, Color(1.0, 0.96, 0.9, star.alpha))
