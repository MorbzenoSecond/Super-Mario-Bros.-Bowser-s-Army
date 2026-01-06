extends State
class_name ArmyGoombaJump

func Enter():
	if !player.rotation_degrees >= 0:
		player.rotate_children(360)
	else: 
		player.rotate_children(-180)
	player.velocity.x = 0
	$"../../../AnimationPlayer".play("idle")

func Physics_Update(_delta : float):
	if player.is_on_floor():
		Transitioned.emit(self, "ArmyGoombaIdle")
