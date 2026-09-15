class_name Hud
extends CanvasLayer

## Geçici arayüz: can, para, dalga ve durum mesajlarını gösterir. Asıl arayüz sonraki adımlarda gelecek.

@onready var build_menu: BuildMenu = $BuildMenu
@onready var _stats: Label = $Stats
@onready var _message: Label = $Message


func set_stats(lives: int, money: int, wave: int, total_waves: int) -> void:
	_stats.text = "Can: %d     Para: %d     Dalga: %d/%d" % [lives, money, wave, total_waves]


func show_message(text: String) -> void:
	_message.text = text
