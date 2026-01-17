extends State
class_name ArmyGoombaPrepareJump

func Enter():
	player.velocity.x = 0
	$"../../../AnimationPlayer".play("prepare_jump")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "prepare_jump":
		player.velocity.y = -1000
		Transitioned.emit(self, "ArmyGoombaJump")

#func Exit():
	#player.going_up_animation()
