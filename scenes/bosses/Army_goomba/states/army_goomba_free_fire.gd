extends State
class_name ArmyGoombaFreeFire

func Enter():
	player.velocity.x = 0
	player.cannon.timer.start(0.75)
	$"../../../AnimationPlayer".play("free_fire")

func Physics_Update(_delta : float):
	if player.cannon.heating >= 100.0:
		Transitioned.emit(self, "ArmyGoombaIdle")


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "turn":
		#Transitioned.emit(self, "ArmyGoombaIdle")
