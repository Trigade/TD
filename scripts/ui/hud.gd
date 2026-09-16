class_name Hud
extends CanvasLayer

## Oyun içi arayüz: üst bar (can, para, dalga), dalga afişi, boss can çubuğu, bildirimler ve oyun akışı butonları.

signal pause_requested
signal early_call_requested
signal speed_toggled(fast: bool)

const ANNOUNCE_TIME := 1.5
const NOTIFY_TIME := 2.2
const LIFE_LOST_COLOR := Color(1.0, 0.35, 0.35)
const BONUS_COLOR := Color(1.0, 0.85, 0.45)
const BANNER_COLOR := Color(1.0, 0.85, 0.5)
const BOSS_COLOR := Color(1.0, 0.4, 0.55)

var _shown_lives := -1
var _banner_tween: Tween
var _lives_tween: Tween
var _boss: Enemy

@onready var build_menu: BuildMenu = $BuildMenu
@onready var tower_menu: TowerMenu = $TowerMenu
@onready var _lives: Label = $TopBar/Margin/Stats/Lives/Value
@onready var _money: Label = $TopBar/Margin/Stats/Money/Value
@onready var _wave: Label = $TopBar/Margin/Stats/Wave/Value
@onready var _banner: PanelContainer = $Banner
@onready var _banner_label: Label = $Banner/Margin/Label
@onready var _boss_bar: PanelContainer = $BossBar
@onready var _boss_name: Label = $BossBar/Margin/Content/Name
@onready var _boss_health: ProgressBar = $BossBar/Margin/Content/Health
@onready var _notifications: VBoxContainer = $Notifications
@onready var _pause_button: Button = $PauseButton
@onready var _speed_button: Button = $SpeedButton
@onready var _early_call: Button = $EarlyCallButton


func _ready() -> void:
	_pause_button.pressed.connect(pause_requested.emit)
	_speed_button.toggled.connect(speed_toggled.emit)
	_early_call.pressed.connect(early_call_requested.emit)


func _process(_delta: float) -> void:
	if not _boss_bar.visible:
		return
	if is_instance_valid(_boss) and _boss.health > 0.0:
		_boss_health.value = _boss.health / _boss.max_health
	else:
		_boss = null
		_boss_bar.hide()


func set_stats(lives: int, money: int, wave: int, total_waves: int) -> void:
	if _shown_lives >= 0 and lives < _shown_lives:
		_flash_lives()
	_shown_lives = lives
	_lives.text = str(lives)
	_money.text = str(money)
	_wave.text = "%d / %d" % [wave, total_waves]


func show_countdown(next_wave: int, seconds_left: float, early_bonus: int) -> void:
	_set_banner("Dalga %d geliyor · %d" % [next_wave, ceili(seconds_left)])
	_early_call.text = "Dalgayı çağır  +%d" % early_bonus
	_early_call.show()


func hide_countdown() -> void:
	_early_call.hide()
	_banner.hide()


## Dalga başladığında afişi kısa süre gösterir.
func announce_wave(wave: int, total_waves: int) -> void:
	_set_banner("Dalga %d / %d" % [wave, total_waves])
	_hide_banner_after(ANNOUNCE_TIME)


func announce_boss_wave(wave: int, total_waves: int) -> void:
	_set_banner("BOSS DALGASI · %d / %d" % [wave, total_waves], BOSS_COLOR)
	_hide_banner_after(ANNOUNCE_TIME * 2.0)


## Boss sahneye çıktığında üst ortada adını ve can çubuğunu gösterir; boss ölünce kendiliğinden gizlenir.
func show_boss(enemy: Enemy) -> void:
	_boss = enemy
	_boss_name.text = enemy.data.display_name
	_boss_health.value = 1.0
	_boss_bar.show()


## Üst barın altında kısa süre görünüp kaybolan bildirim.
func notify(text: String, color := BONUS_COLOR) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 8)
	label.add_theme_font_size_override("font_size", 26)
	_notifications.add_child(label)
	var tween := label.create_tween()
	tween.tween_interval(NOTIFY_TIME * 0.6)
	tween.tween_property(label, "modulate:a", 0.0, NOTIFY_TIME * 0.4)
	tween.tween_callback(label.queue_free)


func _set_banner(text: String, color := BANNER_COLOR) -> void:
	if _banner_tween:
		_banner_tween.kill()
	_banner_label.text = text
	_banner_label.add_theme_color_override("font_color", color)
	_banner.show()


func _hide_banner_after(seconds: float) -> void:
	_banner_tween = create_tween()
	_banner_tween.tween_interval(seconds)
	_banner_tween.tween_callback(_banner.hide)


func _flash_lives() -> void:
	if _lives_tween:
		_lives_tween.kill()
	_lives.modulate = LIFE_LOST_COLOR
	_lives_tween = create_tween()
	_lives_tween.tween_property(_lives, "modulate", Color.WHITE, 0.6)


## Oyun başlamadan önce oyuncuyu bekleyen istem.
func show_start_prompt() -> void:
	_set_banner("İstasyon hazır · dalgayı sen başlat")
	_early_call.text = "Dalgayı başlat"
	_early_call.show()
