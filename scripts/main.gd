extends Node2D

## Ana sahne: haritayı, dalgaları ve oyuncu durumunu (can, para) bir araya getirir.

const STARTING_LIVES := 20
const STARTING_MONEY := 100

var lives := STARTING_LIVES
var money := STARTING_MONEY

@onready var tower_slots: Node2D = $TowerSlots
@onready var wave_manager: WaveManager = $WaveManager
@onready var hud: Hud = $Hud


func _ready() -> void:
	for slot: TowerSlot in tower_slots.get_children():
		slot.clicked.connect(_on_slot_clicked)

	wave_manager.countdown_changed.connect(_on_countdown_changed)
	wave_manager.wave_started.connect(_on_wave_started)
	wave_manager.wave_cleared.connect(_on_wave_cleared)
	wave_manager.all_waves_cleared.connect(_on_all_waves_cleared)
	wave_manager.enemy_reached_end.connect(_on_enemy_reached_end)
	wave_manager.enemy_killed.connect(_on_enemy_killed)
	_refresh_hud()


func _on_slot_clicked(slot: TowerSlot) -> void:
	# Kule inşa menüsü gelene kadar sadece seçimi bildiriyoruz.
	print("Kule noktası seçildi: ", slot.name)


func _on_countdown_changed(seconds_left: float) -> void:
	hud.show_message("Dalga %d geliyor: %d" % [wave_manager.current_wave + 1, ceili(seconds_left)])


func _on_wave_started(wave_number: int, total_waves: int) -> void:
	hud.show_message("")
	_refresh_hud()
	print("Dalga %d/%d başladı" % [wave_number, total_waves])


func _on_wave_cleared(wave_number: int) -> void:
	print("Dalga %d bitti — can: %d, para: %d" % [wave_number, lives, money])


func _on_all_waves_cleared() -> void:
	hud.show_message("Tüm dalgalar püskürtüldü!")
	print("Zafer!")


func _on_enemy_reached_end(enemy: Enemy) -> void:
	lives = maxi(lives - enemy.data.lives_damage, 0)
	_refresh_hud()
	if lives == 0:
		_game_over()


func _on_enemy_killed(enemy: Enemy) -> void:
	money += enemy.data.reward
	_refresh_hud()


func _game_over() -> void:
	# Ağacı durdurmak düşmanları ve dalgaları yerinde dondurur; yeniden başlatma menüsü sonra gelecek.
	get_tree().paused = true
	hud.show_message("İstasyon düştü!")
	print("Oyun bitti — dalga %d" % wave_manager.current_wave)


func _refresh_hud() -> void:
	hud.set_stats(lives, money, wave_manager.current_wave, wave_manager.total_waves())
