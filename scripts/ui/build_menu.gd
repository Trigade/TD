class_name BuildMenu
extends SlotPopup

## Boş bir kule noktasına tıklanınca açılan inşa menüsü. Paranın yetmediği kuleler pasif görünür.

signal tower_chosen(data: TowerData)

## Menüde sunulan kuleler (1. seviyeleri); yeni kule tipleri buraya eklenir.
const TOWERS := [
	preload("res://resources/towers/photon_turret.tres"),
	preload("res://resources/towers/gravity_well.tres"),
	preload("res://resources/towers/plasma_cannon.tres"),
	preload("res://resources/towers/nova_mortar.tres"),
]

var _buttons: Dictionary[TowerData, Button] = {}

@onready var _options: VBoxContainer = $Margin/Content/Options


func _ready() -> void:
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
	show_near(slot_position)


func refresh(money: int) -> void:
	for data in _buttons:
		_buttons[data].disabled = money < data.cost
