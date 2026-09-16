class_name GameOverlay
extends CanvasLayer

## Duraklatma, zafer ve yenilgi ekranı. Oyun ağacı durdurulmuşken de çalışır (process_mode = Always).

signal resume_requested
signal restart_requested
signal options_requested
signal main_menu_requested
signal quit_requested

@onready var _title: Label = $Center/Panel/Margin/Content/Title
@onready var _subtitle: Label = $Center/Panel/Margin/Content/Subtitle
@onready var _stars: StarRow = $Center/Panel/Margin/Content/Stars
@onready var _resume: Button = $Center/Panel/Margin/Content/Resume
@onready var _restart: Button = $Center/Panel/Margin/Content/Restart
@onready var _options: Button = $Center/Panel/Margin/Content/Options
@onready var _main_menu: Button = $Center/Panel/Margin/Content/MainMenu
@onready var _quit: Button = $Center/Panel/Margin/Content/Quit


func _ready() -> void:
	_resume.pressed.connect(resume_requested.emit)
	_restart.pressed.connect(restart_requested.emit)
	_options.pressed.connect(options_requested.emit)
	_main_menu.pressed.connect(main_menu_requested.emit)
	_quit.pressed.connect(quit_requested.emit)


func _unhandled_input(event: InputEvent) -> void:
	# Duraklatma ekranında ESC oyuna döner; zafer ve yenilgi ekranlarında bir şey yapmaz.
	if visible and _resume.visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		resume_requested.emit()


func show_pause() -> void:
	_open("Duraklatıldı", "", true, "Yeniden başlat")


func show_defeat(wave: int) -> void:
	_open("İstasyon düştü!", "%d. dalgada yenildin" % wave, false, "Tekrar oyna")


func show_victory(lives: int, stars := 0) -> void:
	_open("Zafer!", "İstasyon savunuldu — kalan can: %d" % lives, false, "Tekrar oyna")
	_stars.stars = stars
	_stars.visible = true


func _open(title: String, subtitle: String, can_resume: bool, restart_text: String) -> void:
	_title.text = title
	_subtitle.text = subtitle
	_subtitle.visible = not subtitle.is_empty()
	_resume.visible = can_resume
	_stars.visible = false
	_restart.text = restart_text
	show()
