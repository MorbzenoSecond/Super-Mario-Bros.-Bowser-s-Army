extends State
class_name ArmyGoombaCannonHeat

func Enter():
	$"../../AudioStreamPlayer2D".stream = preload("res://scenes/bosses/Army_goomba/steam-hissing-386157.wav")
	$"../../AudioStreamPlayer2D".play()
	$"../../Timer".stop()
	$"../../Sprite2D3/black_smoke".emitting = true
	$"../../ColorRect/Area2D/CollisionShape2D".disabled = false

func Physics_Update(_delta : float): 
	if player.father.scale.y > 0:
		if player.global_position.x > player.mario.global_position.x:
			player.cannon.rotation = lerp_angle(player.cannon.rotation, rad_to_deg(120), player.max_turn_speed * _delta) 
	elif  player.father.scale.y < 0:
		if player.global_position.x < player.mario.global_position.x:
			player.cannon.rotation = lerp_angle(player.cannon.rotation, rad_to_deg(-120), player.max_turn_speed * _delta) 

func Exit():
	$"../../Sprite2D3/black_smoke".emitting = false
	$"../../ColorRect/Area2D/CollisionShape2D".disabled = true
