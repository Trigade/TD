class_name Hud
extends CanvasLayer

## Oyun içi arayüz: can, para, dalga, durum mesajları, duraklatma ve dalgayı erken çağırma butonları.

signal pause_requested
signal early_call_requested

@onready var build_menu: BuildMenu = $BuildMenu
@onready var tower_menu: TowerMenu = $TowerMenu
@onready var _stats: Label = $Stats
@onready var _message: Label = $Message
@onready var _pause_button: Button = $PauseButton
@onready var _early_call: Button = $EarlyCallButton


func _ready() -> void:
	_pause_button.pressed.connect(pause_requested.emit)
	_early_call.pressed.connect(early_call_requested.emit)


func set_stats(lives: int, money: int, wave: int, total_waves: int) -> void:
	_stats.text = "Can: %d     Para: %d     Dalga: %d/%d" % [lives, money, wave, total_waves]


func show_message(text: String) -> void:
	_message.text = text


func show_early_call(bonus: int) -> void:
	_early_call.text = "Dalgayı çağır  +%d" % bonus
	_early_call.show()


func hide_early_call() -> void:
	_early_call.hide()
