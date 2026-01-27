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

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player") and player.shell and player.is_spining:
		var direction = sign(area.global_position.x - player.global_position.x)
		if direction == 0:
			direction = 1  # default to right if exactly aligned

		player.direction = direction
		player.horizontal_speed = direction * 1  # opcional si quieres empujón inicial
		Transitioned.emit(self, "KoopaShellSpining")
