extends PowerUps

class_name Shroom

@onready var raycast = $Raycast

func _ready() -> void:
	super._ready()
	$Timer.start()
	animarion.play("fully")

func _physics_process(delta: float) -> void:
	if can_move:
		if raycast.is_colliding():
			SPEED *= -1
			raycast.scale.x = raycast.scale.x * -1
		velocity.x = SPEED 
		super._physics_process(delta)

func spawn(direction):
	super.spawn(direction)

func _on_timer_timeout() -> void:
	super.scale_bounce()
