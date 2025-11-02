extends Area2D

@export var speed: int = 100
var initial_position = Vector2(0,0)
var boo_position
var mario_position
var _player_watching: bool
var care_zone
var dir
var can_move = true
var already_used = false
var boo_laught = ["res://scenes/characters/Enemies/Boo/boo_laught_1.ogg", "res://scenes/characters/Enemies/Boo/boo_laught_2.ogg", 
				"res://scenes/characters/Enemies/Boo/boo_laught_3.ogg"]
var boo_faces = ["boo_1", "boo_2", "boo_3"]
var boo_sprite
@onready var sprite = $AnimatedSprite2D
@export var boo_size = Vector2(0.5,0.5)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_choose_random_face()
	scale += boo_size
	scale -= Vector2(0.5,0.5)
	initial_position = global_position
	#animation.play("Plant movement")
	mario_position = get_tree().get_nodes_in_group("Player")[0]
	$Label.text = str(boo_size)

func _choose_random_face():
	boo_sprite = boo_faces.pick_random()
	$AnimatedSprite2D.play(boo_sprite)

func _process(delta: float) -> void:
	var follow_strength = 0.5
	var target_position = mario_position.global_position

	dir = mario_position.global_position - $AnimatedSprite2D.global_position
	var target_angle = -dir.angle() + PI / 2 
	if mario_position.get_current_sprite().flip_h and global_position.x < mario_position.global_position.x:
		_player_watching = true
	elif !mario_position.get_current_sprite().flip_h  and global_position.x > mario_position.global_position.x:
		_player_watching = true
	else: 
		_player_watching = false

	if can_move:
		if care_zone:
			_player_watching = false
		if !_player_watching :
			$AnimatedSprite2D.play(boo_sprite)
			speed = 100
			if global_position.x < mario_position.global_position.x:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			global_position = global_position.move_toward(target_position, speed * delta)
			global_position.y += sin(Time.get_ticks_msec() / 1000.0 * 1) * 45 * delta
		else:
			$AnimatedSprite2D.play("blush")
			speed = 0
			global_position = global_position.move_toward(target_position, speed * delta)
			global_position.y += sin(Time.get_ticks_msec() / 1000 * 1) * 15 * delta

func _choose_boo_to_big(boo_position, other_boo_size):
	if boo_size.length() > other_boo_size.length():
		var new_scale = scale + other_boo_size
		
		var tween = create_tween()
		tween.tween_property(self, "scale", new_scale, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		boo_size += other_boo_size
		$Label.text = str(boo_size)
	elif global_position.x < boo_position.x:
		var new_scale = scale + other_boo_size
		
		var tween = create_tween()
		tween.tween_property(self, "scale", new_scale, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		boo_size += other_boo_size
		$Label.text = str(boo_size)
	else:
		_little_boo_move(boo_position, z_index)

func _little_boo_move(other_boo_position, other_z_index):
	already_used = true
	await get_tree().process_frame
	$AudioStreamPlayer2D.stream = load(_random_laught())
	$AudioStreamPlayer2D.play()
	monitorable = false
	monitoring = false
	z_index = other_z_index + 1
	can_move = false
	var tween = create_tween()
	tween.parallel().tween_property(self, "global_position", other_boo_position, 0.5).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "modulate", Color("ffffff00") , 0.5).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "scale", Vector2(2, 2), 0.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	$Timer.start(2)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		care_zone = true
	if area.is_in_group("BOO") and !area.already_used:
		area._choose_boo_to_big(global_position, boo_size)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		care_zone = false

func _on_timer_timeout() -> void:
	queue_free()

func _on_timer_2_timeout() -> void:
	print("boo entered")
	var areas = get_overlapping_areas()
	for area in areas:
		_on_area_entered(area)

func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.volume_db = -80

func _random_laught():
	return boo_laught.pick_random()
