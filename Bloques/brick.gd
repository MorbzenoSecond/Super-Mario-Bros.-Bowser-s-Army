extends Block

class_name Brick

func bump(player_mode: Player.PlayerMode):
	if player_mode == Player.PlayerMode.SMALL:
		super.bump(player_mode)
	elif player_mode != Player.PlayerMode.SMALL:
		var tween = get_tree().create_tween()
		var sprite = $Sprite2D  # O el nodo visual que uses
		
		# Escalar hacia 0 en 0.2 segundos
		tween.tween_property(sprite, "scale", Vector2.ZERO, 0.2)
		super.bump(player_mode)
		# Cuando termine, borrar el nodo
		tween.tween_callback(self.queue_free)
