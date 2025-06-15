extends StaticBody2D

class_name Block


func bump(player_mode: Player.PlayerMode):
	var bump_tween = get_tree().create_tween()
	bump_tween.tween_property(self,"position", position +Vector2(0,-10),.12)
	bump_tween.chain().tween_property(self, "position", position, .12)
	for body in $Top.get_overlapping_bodies():
		if body is Enemy:
			body.die_by_block()
		#if body is Bomb:
			#body.die_by_block()
	if player_mode == Player.PlayerMode.FIRE:
		grow()


func grow():
	var bump_tween = get_tree().create_tween()
	var sprite = $Sprite2D
	sprite.z_index = 2 
	bump_tween.tween_property(sprite,"scale", sprite.scale * 1.2, 0.1)
	bump_tween.chain().tween_property(sprite, "scale", Vector2(1,1), 0.11)
	sprite.z_index = 0
