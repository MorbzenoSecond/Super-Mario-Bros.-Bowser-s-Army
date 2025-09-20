extends Node2D

func setup(original_sprite: AnimatedSprite2D, position: Vector2, modulate_color: Color):
	global_position = position
	print(original_sprite.name) 
	if original_sprite.name == "Big":
		$Star.visible = false
		$Small.visible = false
		$Big.visible = true
		$Big.animation = original_sprite.animation
		$Big.frame = original_sprite.frame
		$Big.flip_h = original_sprite.flip_h
		await self.ready 
		var tween = get_tree().create_tween()
		tween.tween_property($Big, "modulate:a", 0.0, 0.5)
		tween.tween_callback(Callable(self, "queue_free"))

	if original_sprite.name == "Small":
		$Star.visible = false
		$Small.visible = true
		$Big.visible = false
		$Small.animation = original_sprite.animation
		$Small.frame = original_sprite.frame
		$Small.flip_h = original_sprite.flip_h
		await self.ready  
		var tween = get_tree().create_tween()
		tween.tween_property($Small, "modulate:a", 0.0, 0.5)
		tween.tween_callback(Callable(self, "queue_free"))

func star_setup(original_sprite:AnimatedSprite2D, position: Vector2):
	global_position = position
	$Star.visible = true
	$Small.visible = false
	$Big.visible = false
	
	await self.ready  
	var tween = get_tree().create_tween()
	tween.tween_property($Star, "modulate:a", 0.0, 0.5)
	tween.tween_callback(Callable(self, "queue_free"))
