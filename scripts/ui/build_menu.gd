class_name BuildMenu
extends PanelContainer

## Boş bir kule noktasına tıklanınca açılan inşa menüsü. Paranın yetmediği kuleler pasif görünür.

signal tower_chosen(data: TowerData)

## Menüde sunulan kuleler; yeni kule tipleri buraya eklenir.
const TOWERS := [
	preload("res://resources/towers/photon_turret.tres"),
]
## Menünün kule noktasına göre konumu.
const OFFSET := Vector2(60, -50)

var _buttons: Dictionary[TowerData, Button] = {}

@onready var _options: VBoxContainer = $Margin/Content/Options


func _ready() -> void:
	hide()
	for data: TowerData in TOWERS:
		var button := Button.new()
		button.text = "%s — %d" % [data.display_name, data.cost]
		button.tooltip_text = data.description
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_font_size_override("font_size", 26)
		button.pressed.connect(func() -> void: tower_chosen.emit(data))
		_options.add_child(button)
		_buttons[data] = button


func open_at(slot_position: Vector2, money: int) -> void:
	refresh(money)
	show()
	reset_size()
	var screen := get_viewport_rect().size
	var target := slot_position + OFFSET
	# Sağa sığmıyorsa noktanın soluna aç.
	if target.x + size.x > screen.x:
		target.x = slot_position.x - OFFSET.x - size.x
	target.y = clampf(target.y, 0.0, screen.y - size.y)
	position = target


func refresh(money: int) -> void:
	for data in _buttons:
		_buttons[data].disabled = money < data.cost
