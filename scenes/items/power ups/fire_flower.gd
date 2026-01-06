extends PowerUps

class_name Fire_flower
# Called when the node enters the scene tree for the first time.

func spawn(direction):
	super.spawn(direction)

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	if can_move:
		super._physics_process(delta)
