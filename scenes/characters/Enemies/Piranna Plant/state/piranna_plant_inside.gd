extends State
class_name PirannaPlantInside

@onready var timer2 := $Timer2

# Called when the node enters the scene tree for the first time.
func Enter() -> void:
	timer2.start(4.0)

func Physics_Update(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	Transitioned.emit(self, "PirannaPlantTransOut")
