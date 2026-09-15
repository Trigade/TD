extends SceneTree

## Denge simülasyonu: seçilen stratejiyle oyunu baştan sona oynar ve dalga dalga sonuç yazar.
## Proje klasöründe çalıştır:
##   godot --headless --fixed-fps 60 --quit-after 120000 --path . --script tools/balance_sim.gd -- karma
## Stratejiler: hic, foton, foton_yukselt, plazma_yukselt, nova_yukselt, karma
## Plan adımları sırayla, para yettiği anda uygulanır (sıradaki adım karşılanamıyorsa beklenir).

const TOWERS := {
	"foton": preload("res://resources/towers/photon_turret.tres"),
	"kuyu": preload("res://resources/towers/gravity_well.tres"),
	"plazma": preload("res://resources/towers/plasma_cannon.tres"),
	"nova": preload("res://resources/towers/nova_mortar.tres"),
}
## Yolu en iyi kapsayan noktadan en zayıfa doğru.
const SLOTS := ["Slot04", "Slot05", "Slot02", "Slot06", "Slot08", "Slot01", "Slot03", "Slot09", "Slot10", "Slot07"]

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


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	strategy = args[0] if args.size() > 0 else "karma"
	plan = _make_plan(strategy)

	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.wave_manager.wave_cleared.connect(_on_wave_cleared)
	main.wave_manager.all_waves_cleared.connect(_finish.bind("ZAFER"))
	main.wave_manager.boss_spawned.connect(_on_boss_spawned)
	main.wave_manager.enemy_reached_end.connect(_on_enemy_leaked)

	while not done:
		await process_frame
		if is_instance_valid(boss):
			boss_left = boss.health / boss.max_health
		if paused:
			_finish("KAYIP")
			break
		_run_plan()


func _make_plan(name: String) -> Array:
	var steps: Array = []
	match name:
		"hic":
			pass
		"foton":
			for slot in SLOTS:
				steps.append(["insa", slot, "foton"])
		"foton_yukselt", "plazma_yukselt", "nova_yukselt":
			var key := name.get_slice("_", 0)
			if key == "nova":
				# Nova başlangıç parasıyla alınamıyor; ilk savunma için tek bir Foton.
				steps.append(["insa", "Slot07", "foton"])
			for slot in SLOTS:
				steps.append_array([["insa", slot, key], ["yukselt", slot], ["yukselt", slot]])
		"karma":
			# Önce ucuz hasar, 5. dalganın kruvazörlerinden önce Plazma, 6. dalganın sürüsünden önce Nova,
			# destek kuleleri ve yükseltmeler sonra.
			steps = [
				["insa", "Slot04", "foton"],
				["insa", "Slot05", "foton"],
				["insa", "Slot02", "foton"],
				["insa", "Slot06", "plazma"],
				["yukselt", "Slot04"],
				["insa", "Slot08", "nova"],
				["yukselt", "Slot05"],
				["insa", "Slot01", "kuyu"],
				["yukselt", "Slot06"],
				["insa", "Slot09", "nova"],
				["yukselt", "Slot08"],
				["insa", "Slot03", "plazma"],
				["yukselt", "Slot02"],
			]
			for slot in ["Slot04", "Slot05", "Slot06", "Slot08", "Slot09", "Slot03", "Slot02", "Slot01"]:
				steps.append(["yukselt", slot])
			steps.append_array([["insa", "Slot10", "kuyu"], ["insa", "Slot07", "foton"]])
			for slot in ["Slot10", "Slot07", "Slot01"]:
				steps.append_array([["yukselt", slot], ["yukselt", slot]])
		_:
			push_error("Bilinmeyen strateji: " + name)
	return steps


func _run_plan() -> void:
	while not plan.is_empty():
		var step: Array = plan[0]
		var slot = main.get_node("TowerSlots/" + step[1])
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
	print("SIM %-15s | dalga %2d | can %2d | para %4d | harcanan %5d | kalan plan %2d" % [strategy, wave, main.lives, main.money, spent, plan.size()])


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
	print("SONUÇ %-15s | %s | dalga %2d | can %2d | kalan para %4d | harcanan %5d%s" % [strategy, result, main.wave_manager.current_wave, main.lives, main.money, spent, boss_note])
	quit()
