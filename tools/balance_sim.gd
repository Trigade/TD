extends SceneTree

## Denge simülasyonu: seçilen stratejiyle bir bölümü baştan sona oynar ve dalga dalga sonuç yazar.
## Proje klasöründe:
##   godot --headless --fixed-fps 60 --quit-after 120000 --path . --script tools/balance_sim.gd -- karma
## Stratejiler: hic, foton, foton_yukselt, plazma_yukselt, nova_yukselt, karma
## Stratejiden sonra anahtar=değer ile geçici ayar yapılabilir:
##   level=2 difficulty=zor boss_hp=2000 growth=0.17 brood_reward=5
## Plan adımları sırayla, para yettiği anda uygulanır (sıradaki adım karşılanamıyorsa beklenir).

const TOWERS := {
	"foton": preload("res://resources/towers/photon_turret.tres"),
	"kuyu": preload("res://resources/towers/gravity_well.tres"),
	"plazma": preload("res://resources/towers/plasma_cannon.tres"),
	"nova": preload("res://resources/towers/nova_mortar.tres"),
}
## Kule noktaları, yolu en iyi kapsayandan en zayıfa doğru sıralanır.
const PLAN_RANGE := 230.0

var main
var strategy := ""
var plan: Array = []
var spent := 0
var done := false
var boss: Enemy
var boss_seen := false
## Boss'un son görülen can oranı; sahneden silinse de kaybolmasın diye her karede kaydedilir.
var boss_left := 1.0
var boss_max_health := 0.0
## İstasyona ulaşan düşmanlar: ad -> sayı
var leaks := {}
## Geçici ayarların kaynakları bellekten atılmasın diye tutulur.
var _tweaked: Array[Resource] = []


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	strategy = " ".join(args)
	var game := root.get_node("Game")

	var overrides := {}
	for arg in args.slice(1):
		overrides[arg.get_slice("=", 0)] = arg.get_slice("=", 1)

	if overrides.has("level"):
		game.level = game.LEVELS[int(overrides["level"]) - 1]
	if overrides.has("difficulty"):
		for entry in game.DIFFICULTIES:
			if entry.id == overrides["difficulty"]:
				game.difficulty = entry
	if overrides.has("lives"):
		game.difficulty.starting_lives = int(overrides["lives"])
		_tweaked.append(game.difficulty)
	if overrides.has("difficulty_mult"):
		game.difficulty.health_multiplier = float(overrides["difficulty_mult"])
		_tweaked.append(game.difficulty)
	if overrides.has("money_bonus"):
		game.level.starting_money_bonus = int(overrides["money_bonus"])
		_tweaked.append(game.level)
	if overrides.has("boss_hp"):
		var boss_data: EnemyData = load("res://resources/enemies/boss_eta.tres")
		boss_data.max_health = float(overrides["boss_hp"])
		_tweaked.append(boss_data)
	if overrides.has("brood_reward"):
		var brood_data: EnemyData = load("res://resources/enemies/brood.tres")
		brood_data.reward = int(overrides["brood_reward"])
		_tweaked.append(brood_data)

	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	if overrides.has("growth"):
		main.wave_manager.health_growth_per_wave = float(overrides["growth"])

	plan = _make_plan(args[0] if args.size() > 0 else "karma")
	main.wave_manager.wave_cleared.connect(_on_wave_cleared)
	main.wave_manager.all_waves_cleared.connect(_finish.bind("ZAFER"))
	main.wave_manager.boss_spawned.connect(_on_boss_spawned)
	main.wave_manager.enemy_reached_end.connect(_on_enemy_leaked)
	main.wave_manager.start()

	while not done:
		await process_frame
		if is_instance_valid(boss):
			boss_left = boss.health / boss.max_health
		if paused:
			_finish("KAYIP")
			break
		_run_plan()


## Kule noktalarını, menzilleri içindeki yol uzunluğuna göre sıralar; böylece plan her haritada çalışır.
func _ranked_slots() -> Array:
	var points: PackedVector2Array = main.wave_manager.path.curve.get_baked_points()
	var scored := []
	for slot in main.tower_slots.get_children():
		var covered := 0
		for point in points:
			if slot.position.distance_to(point) <= PLAN_RANGE:
				covered += 1
		scored.append({"name": String(slot.name), "covered": covered})
	scored.sort_custom(func(a, b): return a.covered > b.covered)
	var names := []
	for entry in scored:
		names.append(entry.name)
	return names


func _make_plan(name: String) -> Array:
	var slots := _ranked_slots()
	var steps: Array = []
	match name:
		"hic":
			pass
		"foton":
			for slot in slots:
				steps.append(["insa", slot, "foton"])
		"foton_yukselt", "plazma_yukselt", "nova_yukselt":
			var key := name.get_slice("_", 0)
			if key == "nova":
				# Nova başlangıç parasıyla alınamıyor; ilk savunma için tek bir Foton.
				steps.append(["insa", slots[slots.size() - 1], "foton"])
			for slot in slots:
				steps.append_array([["insa", slot, key], ["yukselt", slot], ["yukselt", slot]])
		"karma_plazma":
			# Zırhlılara erken hazırlanan plan: ikinci kule Plazma.
			steps = [
				["insa", slots[0], "foton"],
				["insa", slots[1], "plazma"],
				["insa", slots[2], "foton"],
				["yukselt", slots[1]],
				["insa", slots[3], "nova"],
				["yukselt", slots[0]],
				["insa", slots[4], "plazma"],
				["yukselt", slots[3]],
				["insa", slots[5], "kuyu"],
				["yukselt", slots[4]],
				["insa", slots[6], "nova"],
				["yukselt", slots[2]],
				["insa", slots[7], "foton"],
			]
			for index in [1, 4, 3, 6, 0, 2, 7, 5]:
				steps.append(["yukselt", slots[index]])
			steps.append_array([["insa", slots[8], "plazma"], ["insa", slots[9], "kuyu"]])
			for index in [8, 9, 5, 7]:
				steps.append_array([["yukselt", slots[index]], ["yukselt", slots[index]]])
		"karma":
			# Önce ucuz hasar, zırhlılardan önce Plazma, sürülerden önce Nova, destek ve yükseltmeler sonra.
			steps = [
				["insa", slots[0], "foton"],
				["insa", slots[1], "foton"],
				["insa", slots[2], "foton"],
				["insa", slots[3], "plazma"],
				["yukselt", slots[0]],
				["insa", slots[4], "nova"],
				["yukselt", slots[1]],
				["insa", slots[5], "kuyu"],
				["yukselt", slots[3]],
				["insa", slots[6], "nova"],
				["yukselt", slots[4]],
				["insa", slots[7], "plazma"],
				["yukselt", slots[2]],
			]
			for index in [0, 1, 3, 4, 6, 7, 2, 5]:
				steps.append(["yukselt", slots[index]])
			steps.append_array([["insa", slots[8], "kuyu"], ["insa", slots[9], "foton"]])
			for index in [8, 9, 5]:
				steps.append_array([["yukselt", slots[index]], ["yukselt", slots[index]]])
		_:
			push_error("Bilinmeyen strateji: " + name)
	return steps


func _run_plan() -> void:
	while not plan.is_empty():
		var step: Array = plan[0]
		var slot = main.tower_slots.get_node(step[1])
		var cost: int
		if step[0] == "insa":
			if slot.tower:
				plan.pop_front()
				continue
			cost = TOWERS[step[2]].cost
		else:
			if slot.tower == null or slot.tower.data.next_level == null:
				plan.pop_front()
				continue
			cost = slot.tower.data.next_level.cost
		if main.money < cost:
			return
		main._on_slot_clicked(slot)
		if step[0] == "insa":
			main._on_tower_chosen(TOWERS[step[2]])
		else:
			main._on_upgrade_requested()
		main._close_menus()
		spent += cost
		plan.pop_front()


func _on_enemy_leaked(enemy: Enemy) -> void:
	leaks[enemy.data.display_name] = leaks.get(enemy.data.display_name, 0) + 1


func _on_boss_spawned(enemy: Enemy) -> void:
	boss = enemy
	boss_seen = true
	boss_max_health = enemy.max_health
	enemy.died.connect(func(_enemy: Enemy) -> void: boss_left = 0.0)


func _on_wave_cleared(wave: int) -> void:
	print("SIM %-28s | dalga %2d | can %2d | para %4d | harcanan %5d | kalan plan %2d" % [strategy, wave, main.lives, main.money, spent, plan.size()])


func _finish(result: String) -> void:
	if done:
		return
	done = true
	var boss_note := ""
	if boss_seen:
		boss_note = " | boss kalan can %%%d / %d" % [roundi(maxf(boss_left, 0.0) * 100.0), boss_max_health]
	var leak_parts := PackedStringArray()
	for enemy_name in leaks:
		leak_parts.append("%s x%d" % [enemy_name, leaks[enemy_name]])
	if not leak_parts.is_empty():
		boss_note += " | sızan: " + ", ".join(leak_parts)
	print("SONUÇ %-28s | %s | dalga %2d | can %2d | kalan para %4d | harcanan %5d%s" % [strategy, result, main.wave_manager.current_wave, main.lives, main.money, spent, boss_note])
	quit()
