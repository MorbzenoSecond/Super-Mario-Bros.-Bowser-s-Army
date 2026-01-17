extends State
class_name ArmyGoombaJump

var is_finished: bool = false

func Enter():
	$Timer.start()
	if !player.scale.y < 0:
		player.rotate_children(-360)
	else: 
		player.rotate_children(-180)
	player.velocity.x = 0
	$"../../../AnimationPlayer".play("idle")

func Physics_Update(_delta : float):
	if player.is_on_floor() and is_finished:
		Transitioned.emit(self, "ArmyGoombaFinishJump")

func _on_timer_timeout() -> void:
	is_finished = true

func Exit():
	is_finished = false
