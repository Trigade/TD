class_name TowerMenu
extends SlotPopup

## Kurulu bir kuleye tıklanınca açılan menü: seviye ve değerleri gösterir, yükseltme ve satış sunar.

signal upgrade_requested
signal sell_requested

var _tower: Tower

@onready var _title: Label = $Margin/Content/Title
@onready var _level: Label = $Margin/Content/Level
@onready var _stats: Label = $Margin/Content/Stats
@onready var _upgrade: Button = $Margin/Content/Upgrade
@onready var _sell: Button = $Margin/Content/Sell


func _ready() -> void:
	_upgrade.pressed.connect(upgrade_requested.emit)
	_sell.pressed.connect(sell_requested.emit)


func open_for(tower: Tower, slot_position: Vector2, money: int) -> void:
	_tower = tower
	refresh(money)
	show_near(slot_position)


func close() -> void:
	_tower = null
	hide()


func refresh(money: int) -> void:
	if _tower == null:
		return
	var data := _tower.data
	_title.text = data.display_name
	_level.text = "Seviye %d / %d" % [data.level, data.max_level()]
	_stats.text = describe(data)
	if data.next_level:
		_upgrade.text = "Yükselt — %d" % data.next_level.cost
		_upgrade.tooltip_text = "Sonraki seviye:\n" + describe(data.next_level)
		_upgrade.disabled = money < data.next_level.cost
	else:
		_upgrade.text = "Maksimum seviye"
		_upgrade.tooltip_text = ""
		_upgrade.disabled = true
	_sell.text = "Sat — +%d" % _tower.sell_value()


static func describe(data: TowerData) -> String:
	var lines := PackedStringArray()
	lines.append("Hasar: %s" % String.num(data.damage, 1))
	var rate_label := "Dalga" if data.attack_mode == TowerData.AttackMode.PULSE else "Atış"
	lines.append("%s: %s / sn" % [rate_label, String.num(data.fire_rate, 2)])
	lines.append("Menzil: %d" % data.attack_range)
	if data.splash_radius > 0.0:
		lines.append("Patlama alanı: %d" % data.splash_radius)
	if data.slow_factor > 0.0:
		lines.append("Yavaşlatma: %%%d, %s sn" % [roundi(data.slow_factor * 100.0), String.num(data.slow_duration, 1)])
	if data.armor_piercing > 0.0:
		lines.append("Zırh delme: %%%d" % roundi(data.armor_piercing * 100.0))
	return "\n".join(lines)
