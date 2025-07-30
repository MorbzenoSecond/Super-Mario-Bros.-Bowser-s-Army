extends State
class_name PirannaPlantTransIn

# Called when the node enters the scene tree for the first time.
func Enter() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float) -> void:
	if player.global_position.y < player.initial_position.y:
		var pos_root: Vector2 = player.global_position

		pos_root.y += 0.8

		player.global_position = pos_root
	else:
		Transitioned.emit(self, "PirannaPlantInside")
