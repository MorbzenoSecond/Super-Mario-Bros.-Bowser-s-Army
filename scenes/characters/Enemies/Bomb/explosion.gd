extends Area2D

class_name explosion

func _on_area_2d_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	if enemy is Enemy:
		enemy.die()
