extends Node2D

## Ana sahne: haritayı bir araya getirir ve oyuncu etkileşimlerini yönlendirir.

@onready var tower_slots: Node2D = $TowerSlots


func _ready() -> void:
	for slot: TowerSlot in tower_slots.get_children():
		slot.clicked.connect(_on_slot_clicked)


func _on_slot_clicked(slot: TowerSlot) -> void:
	# Kule inşa menüsü gelene kadar sadece seçimi bildiriyoruz.
	print("Kule noktası seçildi: ", slot.name)
