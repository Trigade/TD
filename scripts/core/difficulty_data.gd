class_name DifficultyData
extends Resource

## Zorluk seviyesi: başlangıç canı, parası ve düşman canı çarpanı.

@export var id := ""
@export var display_name := ""
@export_multiline var description := ""
@export var starting_lives := 20
@export var starting_money := 100
## Düşman canı bu oranla çarpılır.
@export var health_multiplier := 1.0
