extends State
class_name PirannaPlantOutside

@onready var timer2 := $Timer
@onready var shootTimer := $ShootTimer

# Called when the node enters the scene tree for the first time.
func Enter() -> void:
	shootTimer.start(1.0)
	timer2.start(4.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float) -> void:
	if player.piranna_type == player.PirannaType.Poison :
		if player.ticks >= 0:
			if player.ticks % 10 == 0:
				player.shoot()
			player.ticks -= 1

func _on_timer_timeout() -> void:
	Transitioned.emit(self, "PirannaPlantTransIn")

func _on_shoot_timer_timeout() -> void:
	if player.piranna_type == player.PirannaType.Fire:
		player.shoot()

func Exit():
	player.ticks = 60
	shootTimer.stop()
