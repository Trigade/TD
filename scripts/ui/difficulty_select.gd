extends Control

## Zorluk seçme ekranı: seçili bölüm için üç zorluğu ve o zorlukta kazanılmış yıldızları gösterir.

const GAME_SCENE := "res://scenes/main.tscn"
const LEVEL_SELECT := "res://scenes/ui/level_select.tscn"

@onready var _level_name: Label = $Center/Content/LevelName
@onready var _options: VBoxContainer = $Center/Content/Options
@onready var _back: Button = $Center/Content/Back


func _ready() -> void:
	_back.pressed.connect(_on_back_pressed)
	_level_name.text = Game.level.display_name
	for difficulty: DifficultyData in Game.DIFFICULTIES:
		_options.add_child(_build_row(difficulty))


func _build_row(difficulty: DifficultyData) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)

	var button := Button.new()
	button.custom_minimum_size = Vector2(860, 86)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 28)
	button.text = "%s — %s" % [difficulty.display_name, difficulty.description]
	button.pressed.connect(_on_difficulty_pressed.bind(difficulty))
	row.add_child(button)

	var stars := StarRow.new()
	stars.custom_minimum_size = Vector2(150, 48)
	stars.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	stars.stars = Game.stars_for(Game.level.id, difficulty.id)
	row.add_child(stars)
	return row


func _on_difficulty_pressed(difficulty: DifficultyData) -> void:
	Game.difficulty = difficulty
	get_tree().change_scene_to_file(GAME_SCENE)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_SELECT)
