extends State
class_name ArmyGoombaJump

var is_finished: bool = false

func Enter():
	$Timer.start()
	$Timer2.start()
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
	$Timer2.stop()
	player.cannon.spining = false
	is_finished = false

func _on_timer_2_timeout() -> void:
	if player.cannon.heating <= 100.0: 
		player.cannon.shoot()
