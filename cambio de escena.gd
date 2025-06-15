extends Area2D

@export var changed_zone: String = ""

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		print("Cambiando a: ", changed_zone)
		Main.change_level(changed_zone)
