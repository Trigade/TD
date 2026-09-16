extends Node

## Oyun genelinde seçili bölüm ile zorluğu ve kalıcı ilerlemeyi (yıldızlar) tutar.
## project.godot içinde otomatik yüklenir (autoload), yani her sahneden `Game` ile erişilir.

const LEVELS := [
	preload("res://resources/levels/level_01.tres"),
	preload("res://resources/levels/level_02.tres"),
]
const DIFFICULTIES := [
	preload("res://resources/difficulties/easy.tres"),
	preload("res://resources/difficulties/normal.tres"),
	preload("res://resources/difficulties/hard.tres"),
]

const SAVE_PATH := "user://progress.cfg"
## Kalan canın bu oranı ve üstü 3 yıldız, TWO_STAR_RATIO ve üstü 2 yıldız, kazanmak 1 yıldız.
const THREE_STAR_RATIO := 0.9
const TWO_STAR_RATIO := 0.5

var level: LevelData = LEVELS[0]
var difficulty: DifficultyData = DIFFICULTIES[1]
## Testlerin gerçek kaydı bozmaması için değiştirilebilir.
var save_path := SAVE_PATH

## "bölüm_id/zorluk_id" -> yıldız sayısı
var _stars := {}


func _ready() -> void:
	load_progress()


func stars_for(level_id: String, difficulty_id: String) -> int:
	return _stars.get("%s/%s" % [level_id, difficulty_id], 0)


## Bir bölümün herhangi bir zorluktaki en iyi sonucu.
func best_stars(level_id: String) -> int:
	var best := 0
	for entry: DifficultyData in DIFFICULTIES:
		best = maxi(best, stars_for(level_id, entry.id))
	return best


## İlk bölüm hep açıktır; sonrakiler bir önceki bölümden en az 1 yıldız alınınca açılır.
func is_unlocked(index: int) -> bool:
	if index <= 0:
		return true
	return best_stars(LEVELS[index - 1].id) > 0


func rate(lives_left: int, starting_lives: int) -> int:
	if lives_left <= 0:
		return 0
	var ratio := float(lives_left) / float(starting_lives)
	if ratio >= THREE_STAR_RATIO:
		return 3
	if ratio >= TWO_STAR_RATIO:
		return 2
	return 1


## Sonucu kaydeder; sadece önceki sonuçtan iyiyse yazılır.
func record_result(level_id: String, difficulty_id: String, stars: int) -> void:
	var key := "%s/%s" % [level_id, difficulty_id]
	if stars <= _stars.get(key, 0):
		return
	_stars[key] = stars
	save_progress()


func load_progress() -> void:
	_stars.clear()
	var config := ConfigFile.new()
	if config.load(save_path) != OK:
		return
	for level_id in config.get_sections():
		for difficulty_id in config.get_section_keys(level_id):
			_stars["%s/%s" % [level_id, difficulty_id]] = config.get_value(level_id, difficulty_id)


func save_progress() -> void:
	var config := ConfigFile.new()
	for key in _stars:
		var parts: PackedStringArray = key.split("/")
		config.set_value(parts[0], parts[1], _stars[key])
	config.save(save_path)


func reset_progress() -> void:
	_stars.clear()
	save_progress()
