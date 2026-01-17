extends State
class_name PlayerAirSpin

func Enter() -> void:
	player.mario_spin_air = true 
	$freeTimeInAir.start()
	player.velocity.y = 0

func _on_free_time_in_air_timeout() -> void:
	Transitioned.emit(self, "PlayerFall")

func Exit():
	player.mario_spin_air = false
