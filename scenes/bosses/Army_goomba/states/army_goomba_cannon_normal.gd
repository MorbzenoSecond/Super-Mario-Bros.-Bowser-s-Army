extends State
class_name ArmyGoombaCannonNormal

func Enter():
	$"../../AudioStreamPlayer2D".stream = preload("res://scenes/bosses/Army_goomba/cannon_Shoot.wav")
	$"../../Timer".start(3.5)

func Physics_Update(_delta : float):
	player.dir = player.mario.global_position - player.cannon.global_position
	var target_angle = -player.dir.angle() + PI 
	target_angle = player.clamp_angle(target_angle)
	if !player.spining:
		if player.father.scale.y > 0:
			if player.global_position.x > player.mario.global_position.x:
				player.cannon.rotation = lerp_angle(player.cannon.rotation, target_angle, player.max_turn_speed * _delta) 
			else: 
				player.cannon.rotation = lerp_angle(player.cannon.rotation, 0, player.max_turn_speed * _delta) 
		elif  player.father.scale.y < 0:
			if player.global_position.x < player.mario.global_position.x:
				player.cannon.rotation = lerp_angle(player.cannon.rotation, -target_angle, player.max_turn_speed * _delta) 
			else: 
				player.cannon.rotation = lerp_angle(player.cannon.rotation, deg_to_rad(180), player.max_turn_speed * _delta) 
	else:
		player.cannon.rotate(deg_to_rad(4))
