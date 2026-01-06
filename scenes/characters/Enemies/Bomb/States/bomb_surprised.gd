extends State
class_name BombSurprised

func Enter():
	player.animated_sprite_2d.play("detected")

func _on_animated_sprite_2d_animation_finished() -> void:
	Transitioned.emit(self, "BombAttackRun")
