class_name OptionsMenu
extends CanvasLayer

## Ses ve görüntü ayarları. Hem ana menüden hem de duraklatma ekranından açılır;
## oyun durdurulmuşken de çalışır (process_mode = Always).

signal closed

const AUDIO_PATH := "Center/Panel/Margin/Content/Audio/"

var _sliders := {}
var _values := {}

@onready var _fullscreen: CheckButton = $Center/Panel/Margin/Content/Fullscreen
@onready var _back: Button = $Center/Panel/Margin/Content/Back


func _ready() -> void:
	_sliders = {
		"master": get_node(AUDIO_PATH + "MasterSlider"),
		"music": get_node(AUDIO_PATH + "MusicSlider"),
		"sfx": get_node(AUDIO_PATH + "SfxSlider"),
	}
	_values = {
		"master": get_node(AUDIO_PATH + "MasterValue"),
		"music": get_node(AUDIO_PATH + "MusicValue"),
		"sfx": get_node(AUDIO_PATH + "SfxValue"),
	}
	for kind in _sliders:
		var slider: HSlider = _sliders[kind]
		slider.value = Game.volumes[kind]
		slider.value_changed.connect(_on_volume_changed.bind(kind))
		_update_value_label(kind)
	_fullscreen.button_pressed = Game.fullscreen
	_fullscreen.toggled.connect(Game.set_fullscreen)
	_back.pressed.connect(close)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	closed.emit()
	queue_free()


func _on_volume_changed(value: float, kind: String) -> void:
	Game.set_volume(kind, value)
	_update_value_label(kind)


func _update_value_label(kind: String) -> void:
	_values[kind].text = "%d%%" % roundi(Game.volumes[kind] * 100.0)
