extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func setup(flip):
	$AnimatedSprite2D.flip_h = flip

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.in_yoshi = true
		if body.falling:
			queue_free()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.in_yoshi = false
