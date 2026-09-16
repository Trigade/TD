extends Control

## Oyun açılınca gelen ana menü.

const LEVEL_SELECT := "res://scenes/ui/level_select.tscn"
const OPTIONS_SCENE := preload("res://scenes/ui/options_menu.tscn")

@onready var _play: Button = $Center/Content/Buttons/Play
@onready var _options: Button = $Center/Content/Buttons/Options
@onready var _quit: Button = $Center/Content/Buttons/Quit


func _ready() -> void:
	_play.pressed.connect(_on_play_pressed)
	_options.pressed.connect(_on_options_pressed)
	_quit.pressed.connect(get_tree().quit)
	_play.grab_focus()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_SELECT)


func _on_options_pressed() -> void:
	var menu: OptionsMenu = OPTIONS_SCENE.instantiate()
	add_child(menu)
	menu.closed.connect(_play.grab_focus)
