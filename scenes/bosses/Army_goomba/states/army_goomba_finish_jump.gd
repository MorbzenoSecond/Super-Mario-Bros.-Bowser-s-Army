extends State
class_name ArmyGoombaFinishJump

func Enter():
	player.velocity.x = 0
	$"../../../AnimationPlayer".play("landing")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "landing":
		Transitioned.emit(self, "ArmyGoombaIdle")
