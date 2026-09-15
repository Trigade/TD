class_name SlotPopup
extends PanelContainer

## Bir kule noktasının yanında açılan menülerin ortak davranışı: ekrana sığacak şekilde konumlanır.

## Menünün kule noktasına göre konumu.
const OFFSET := Vector2(60, -50)


func show_near(slot_position: Vector2) -> void:
	show()
	reset_size()
	var screen := get_viewport_rect().size
	var target := slot_position + OFFSET
	# Sağa sığmıyorsa noktanın soluna aç.
	if target.x + size.x > screen.x:
		target.x = slot_position.x - OFFSET.x - size.x
	target.y = clampf(target.y, 0.0, screen.y - size.y)
	position = target
