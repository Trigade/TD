extends Control

## Bölüm seçme ekranı: bölümleri, kazanılan yıldızları ve kilit durumunu gösterir.

const DIFFICULTY_SELECT := "res://scenes/ui/difficulty_select.tscn"
const MAIN_MENU := "res://scenes/ui/main_menu.tscn"

@onready var _levels: VBoxContainer = $Center/Content/Levels
@onready var _back: Button = $Center/Content/Back


func _ready() -> void:
	_back.pressed.connect(_on_back_pressed)
	for index in Game.LEVELS.size():
		_levels.add_child(_build_row(index))


func _build_row(index: int) -> Control:
	var level: LevelData = Game.LEVELS[index]
	var unlocked := Game.is_unlocked(index)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)

	var button := Button.new()
	button.custom_minimum_size = Vector2(640, 80)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 28)
	button.text = level.display_name if unlocked else "%s   (kilitli)" % level.display_name
	button.tooltip_text = level.description if unlocked else "Önceki bölümü en az 1 yıldızla bitir."
	button.disabled = not unlocked
	button.pressed.connect(_on_level_pressed.bind(index))
	row.add_child(button)

	var stars := StarRow.new()
	stars.custom_minimum_size = Vector2(150, 48)
	stars.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	stars.stars = Game.best_stars(level.id)
	row.add_child(stars)
	return row


func _on_level_pressed(index: int) -> void:
	Game.level = Game.LEVELS[index]
	get_tree().change_scene_to_file(DIFFICULTY_SELECT)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
