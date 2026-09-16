extends Control

## Oyun açılınca gelen ana menü.

const GAME_SCENE := "res://scenes/main.tscn"

@onready var _play: Button = $Center/Content/Buttons/Play
@onready var _quit: Button = $Center/Content/Buttons/Quit


func _ready() -> void:
	_play.pressed.connect(_on_play_pressed)
	_quit.pressed.connect(get_tree().quit)
	_play.grab_focus()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)
