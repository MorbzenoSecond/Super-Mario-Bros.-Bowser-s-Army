extends State
class_name KoopaShell

func Enter():
	var character = owner
	character.shell_size()
	character.animated_sprite_2d.play("green_shell")

func Physics_Update(delta : float):
	var character = owner
	if not character.is_on_floor():
		character.velocity.y += character.gravity * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	var character = owner

	if body.is_in_group("Player") and character.shell and character.is_spining:
		var direction = sign(body.global_position.x - character.global_position.x)
		if direction == 0:
			direction = 1  # default to right if exactly aligned

		character.direction = direction
		character.horizontal_speed = direction * 1  # opcional si quieres empujón inicial
		Transitioned.emit(self, "KoopaShellSpining")
