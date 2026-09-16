extends Node2D

## Oyun sahnesi: seçili bölümün haritasını yükler, dalgaları, kule inşasını,
## oyuncu durumunu (can, para) ve oyun akışını bir araya getirir.

const MAIN_MENU_SCENE := "res://scenes/ui/main_menu.tscn"
const OPTIONS_SCENE := preload("res://scenes/ui/options_menu.tscn")
const LEVEL_SELECT_SCENE := "res://scenes/ui/level_select.tscn"
## Dalga bitince verilen bonus: taban + dalga numarası × artış (1. dalga 20, 13. dalga 80).
const WAVE_BONUS_BASE := 15
const WAVE_BONUS_PER_WAVE := 5
## 2x butonuna basılıyken oyunun akış hızı.
const FAST_SPEED := 2.0

var level: LevelData
var difficulty: DifficultyData
var lives := 20
var money := 100

## Bu bölümün kule noktaları; harita yüklenince doldurulur.
var tower_slots: Node2D

## Menüsü açık olan kule noktası.
var _selected_slot: TowerSlot

@onready var map_root: Node2D = $Map
@onready var wave_manager: WaveManager = $WaveManager
@onready var hud: Hud = $Hud
@onready var overlay: GameOverlay = $GameOverlay


func _ready() -> void:
	level = Game.level
	difficulty = Game.difficulty
	lives = difficulty.starting_lives
	money = difficulty.starting_money + level.starting_money_bonus

	var map: Node2D = level.map_scene.instantiate()
	map_root.add_child(map)
	tower_slots = map.get_node("TowerSlots")
	wave_manager.path = map.get_node("EnemyPath")
	wave_manager.waves = level.waves()
	wave_manager.health_multiplier = difficulty.health_multiplier

	for slot: TowerSlot in tower_slots.get_children():
		slot.clicked.connect(_on_slot_clicked)
	hud.build_menu.tower_chosen.connect(_on_tower_chosen)
	hud.tower_menu.upgrade_requested.connect(_on_upgrade_requested)
	hud.tower_menu.sell_requested.connect(_on_sell_requested)
	hud.pause_requested.connect(_pause)
	hud.early_call_requested.connect(_on_early_call_requested)
	hud.speed_toggled.connect(_on_speed_toggled)
	overlay.resume_requested.connect(_resume)
	overlay.restart_requested.connect(_restart)
	overlay.options_requested.connect(_open_options)
	overlay.main_menu_requested.connect(_to_level_select)
	overlay.quit_requested.connect(get_tree().quit)

	wave_manager.countdown_changed.connect(_on_countdown_changed)
	wave_manager.wave_started.connect(_on_wave_started)
	wave_manager.wave_cleared.connect(_on_wave_cleared)
	wave_manager.all_waves_cleared.connect(_on_all_waves_cleared)
	wave_manager.enemy_reached_end.connect(_on_enemy_reached_end)
	wave_manager.enemy_killed.connect(_on_enemy_killed)
	wave_manager.boss_spawned.connect(hud.show_boss)
	hud.set_level_name("%s · %s" % [level.display_name, difficulty.display_name])
	_refresh_hud()
	if wave_manager.is_idle():
		hud.show_start_prompt()


func _unhandled_input(event: InputEvent) -> void:
	# ESC: açık bir menü varsa onu kapatır, yoksa oyunu duraklatır.
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if _selected_slot:
			_close_menus()
		else:
			_pause()
		return

	# Menü dışına yapılan tıklama menüyü kapatır. Tıklama bir kule noktasına denk geldiyse
	# nokta bu olaydan sonra işlenir ve menüyü yeniden açar.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_close_menus()


func _on_slot_clicked(slot: TowerSlot) -> void:
	_close_menus()
	_selected_slot = slot
	slot.selected = true
	if slot.tower:
		hud.tower_menu.open_for(slot.tower, slot.global_position, money)
	else:
		hud.build_menu.open_at(slot.global_position, money)


func _on_tower_chosen(data: TowerData) -> void:
	if _selected_slot == null or _selected_slot.tower or money < data.cost:
		return
	money -= data.cost
	_selected_slot.build(data)
	_close_menus()
	_refresh_hud()


func _on_upgrade_requested() -> void:
	if _selected_slot == null or _selected_slot.tower == null:
		return
	var tower := _selected_slot.tower
	var next := tower.data.next_level
	if next == null or money < next.cost:
		return
	money -= next.cost
	tower.upgrade()
	_refresh_hud()
	# Menü içeriği değişti; boyutu ve konumu yeniden hesaplansın.
	hud.tower_menu.open_for(tower, _selected_slot.global_position, money)


func _on_sell_requested() -> void:
	if _selected_slot == null or _selected_slot.tower == null:
		return
	money += _selected_slot.tower.sell_value()
	_selected_slot.remove_tower()
	_close_menus()
	_refresh_hud()


func _close_menus() -> void:
	if _selected_slot:
		_selected_slot.selected = false
		_selected_slot = null
	hud.build_menu.hide()
	hud.tower_menu.close()


func _exit_tree() -> void:
	# Yeniden başlatma veya menüye dönüşte hızlandırma sonraki oyuna taşınmasın.
	Engine.time_scale = 1.0


func _on_speed_toggled(fast: bool) -> void:
	Engine.time_scale = FAST_SPEED if fast else 1.0


func _on_early_call_requested() -> void:
	# İlk dalga oyuncunun başlatmasını bekler; sonrakiler geri sayımla gelir ve erkene alınabilir.
	if wave_manager.is_idle():
		wave_manager.start()
		return
	var bonus := wave_manager.call_next_wave_early()
	if bonus > 0:
		money += bonus
		hud.notify("+%d erken çağrı" % bonus)
		_refresh_hud()


func _on_countdown_changed(seconds_left: float) -> void:
	hud.show_countdown(wave_manager.current_wave + 1, seconds_left, wave_manager.early_call_bonus())


func _on_wave_started(wave_number: int, total_waves: int) -> void:
	hud.hide_countdown()
	if wave_manager.is_boss_wave(wave_number):
		hud.announce_boss_wave(wave_number, total_waves)
	else:
		hud.announce_wave(wave_number, total_waves)
	_refresh_hud()
	print("Dalga %d/%d başladı" % [wave_number, total_waves])


func _on_wave_cleared(wave_number: int) -> void:
	var bonus := WAVE_BONUS_BASE + WAVE_BONUS_PER_WAVE * wave_number
	money += bonus
	hud.notify("+%d dalga bonusu" % bonus)
	_refresh_hud()
	print("Dalga %d bitti — can: %d, para: %d (+%d bonus)" % [wave_number, lives, money, bonus])


func _on_all_waves_cleared() -> void:
	var stars := Game.rate(lives, difficulty.starting_lives)
	Game.record_result(level.id, difficulty.id, stars)
	_end_game()
	overlay.show_victory(lives, stars)
	print("Zafer! — %d yıldız" % stars)


func _on_enemy_reached_end(enemy: Enemy) -> void:
	lives = maxi(lives - enemy.data.lives_damage, 0)
	_refresh_hud()
	if lives == 0:
		_game_over()


func _on_enemy_killed(enemy: Enemy) -> void:
	money += enemy.data.reward
	_refresh_hud()


func _game_over() -> void:
	_end_game()
	overlay.show_defeat(wave_manager.current_wave)
	print("Oyun bitti — dalga %d" % wave_manager.current_wave)


func _pause() -> void:
	_close_menus()
	get_tree().paused = true
	overlay.show_pause()


func _resume() -> void:
	overlay.hide()
	get_tree().paused = false


func _restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


## Duraklatma ekranının üstünde ayarları açar.
func _open_options() -> void:
	add_child(OPTIONS_SCENE.instantiate())


## Bölüm seçme ekranına döner.
func _to_level_select() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(LEVEL_SELECT_SCENE)


## Oyunu durdurur; düşmanlar ve dalgalar yerinde donar, sonuç ekranı üstte kalır.
func _end_game() -> void:
	_close_menus()
	hud.hide_countdown()
	get_tree().paused = true


func _refresh_hud() -> void:
	hud.set_stats(lives, money, wave_manager.current_wave, wave_manager.total_waves())
	hud.build_menu.refresh(money)
	hud.tower_menu.refresh(money)
