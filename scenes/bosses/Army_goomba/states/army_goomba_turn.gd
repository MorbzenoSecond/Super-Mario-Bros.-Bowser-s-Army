extends State
class_name ArmyGoombaTurn

func Enter():
	$Timer.start( )
	player.velocity.x = 0
	$"../../../AnimationPlayer".play("turn")
	#if player.scale.y > 0:
		#if player.mario_is_left():
			#player.orientar_personaje(-1)
	#else:
		#if !player.mario_is_left():
			#player.orientar_personaje(-1)
	#player.orientar_personaje(-1)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "turn":
		Transitioned.emit(self, "ArmyGoombaIdle")
