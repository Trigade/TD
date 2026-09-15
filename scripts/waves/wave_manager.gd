class_name WaveManager
extends Node

## Dalgaları sırayla başlatır, düşmanları yola çıkarır ve dalga bitişlerini bildirir.

signal countdown_changed(seconds_left: float)
signal wave_started(wave_number: int, total_waves: int)
signal wave_cleared(wave_number: int)
signal all_waves_cleared
signal enemy_reached_end(enemy: Enemy)
signal enemy_killed(enemy: Enemy)

enum State { COUNTDOWN, RUNNING, FINISHED }

const ENEMY_SCENE := preload("res://scenes/enemies/enemy.tscn")

@export var path: Path2D
@export var first_wave_delay := 5.0
@export var break_between_waves := 8.0
## Her dalgada düşman canına eklenen oran: 0.15 ile 2. dalga %115, 12. dalga %265 can.
@export var health_growth_per_wave := 0.15

## 1'den başlar; 0 henüz hiçbir dalganın başlamadığı anlamına gelir.
var current_wave := 0

var _state := State.COUNTDOWN
var _countdown := 0.0
var _wave_time := 0.0
## Bu dalgada henüz çıkmamış düşmanlar, çıkış zamanına göre sıralı: {"time": float, "enemy": EnemyData}
var _pending: Array[Dictionary] = []
var _alive := 0


func _ready() -> void:
	_start_countdown(first_wave_delay)


func _process(delta: float) -> void:
	match _state:
		State.COUNTDOWN:
			_countdown -= delta
			countdown_changed.emit(maxf(_countdown, 0.0))
			if _countdown <= 0.0:
				_start_next_wave()
		State.RUNNING:
			_wave_time += delta
			while not _pending.is_empty() and _pending[0].time <= _wave_time:
				_spawn(_pending.pop_front().enemy)
			if _pending.is_empty() and _alive == 0:
				_finish_wave()


func total_waves() -> int:
	return WaveTable.WAVES.size()


func _start_countdown(seconds: float) -> void:
	_countdown = seconds
	_state = State.COUNTDOWN
	countdown_changed.emit(seconds)


func _start_next_wave() -> void:
	current_wave += 1
	_wave_time = 0.0
	for group in WaveTable.WAVES[current_wave - 1]:
		for i in group.count:
			_pending.append({"time": group.delay + i * group.interval, "enemy": group.enemy})
	_pending.sort_custom(func(a, b): return a.time < b.time)
	_state = State.RUNNING
	wave_started.emit(current_wave, total_waves())


func _finish_wave() -> void:
	wave_cleared.emit(current_wave)
	if current_wave >= total_waves():
		_state = State.FINISHED
		all_waves_cleared.emit()
	else:
		_start_countdown(break_between_waves)


func _spawn(data: EnemyData) -> void:
	var enemy: Enemy = ENEMY_SCENE.instantiate()
	enemy.data = data
	enemy.health_multiplier = 1.0 + health_growth_per_wave * (current_wave - 1)
	enemy.reached_end.connect(_on_enemy_reached_end)
	enemy.died.connect(_on_enemy_died)
	path.add_child(enemy)
	_alive += 1


func _on_enemy_reached_end(enemy: Enemy) -> void:
	_alive -= 1
	enemy_reached_end.emit(enemy)


func _on_enemy_died(enemy: Enemy) -> void:
	_alive -= 1
	enemy_killed.emit(enemy)
