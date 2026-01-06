extends AnimatableBody2D

@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer

var waypoints := []
var current_target := 0
var speed : int = 0
var last_point : Vector2

func _ready() -> void:
	set_physics_process(false)
	sprite.play("default")
	sprite.frame = randi() % sprite.sprite_frames.get_frame_count("default")
	setup_animations()

func setup_animations():
	var tw = create_tween().set_loops()
	tw.tween_property(sprite, "rotation", deg_to_rad(20), 0.5).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property(sprite, "position", Vector2(3, -2), 0.5)
	tw.tween_property(sprite, "rotation", deg_to_rad(-20), 0.5).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property(sprite, "position", Vector2(-3, -2), 0.5)
	tw.tween_property(sprite, "rotation", deg_to_rad(20), 0.5).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property(sprite, "position", Vector2(-3, 2), 0.5)
	tw.tween_property(sprite, "rotation", deg_to_rad(-20), 0.5).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property(sprite, "position", Vector2(3, 2), 0.5)
	var random = randf_range(0.34, 0.55)
	var tw2 = create_tween().set_loops()
	tw2.tween_property(sprite, "scale", Vector2(1.2, 1.4), random).set_trans(Tween.TRANS_BACK)
	tw2.tween_property(sprite, "scale", Vector2(1, 0.8), random)

func _physics_process(delta: float) -> void:
	if waypoints.is_empty(): return
	go_to_all_points(delta)

func go_to_all_points(delta):
	var target = waypoints[current_target]
	global_position = global_position.move_toward(target, speed * delta)
	
	if global_position.distance_to(target) < 1.0:
		if target == last_point:
			waypoints.reverse()
			current_target = 0 
			last_point = waypoints.back()
		else:
			current_target = (current_target + 1) % waypoints.size()

func get_new_point(w_points: Array, c_target: int, s: int, l_point: Vector2, Incremental):
	waypoints = w_points # Aquí ya viene duplicado desde el padre
	current_target = c_target
	speed = s
	last_point = l_point
	timer.start(Incremental)
	# Posicionar al fuzzy en el primer punto de inmediato
	if not waypoints.is_empty():
		global_position = waypoints[current_target]

#extends AnimatableBody2D
#@onready var sprite = $AnimatedSprite2D
#
#var time_passed : float = 0.0
#var last_point : Vector2 
#var waypoints := []
#var current_target := 0
#var speed : int = 0
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#sprite.play("default")
	#var tween = get_tree().create_tween().set_loops()
	#tween.tween_property(sprite, "rotation", deg_to_rad(20), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.parallel().tween_property(sprite, "position", Vector2(3, -2), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.tween_property(sprite, "rotation", deg_to_rad(0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.parallel().tween_property(sprite, "position", Vector2(0,0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.tween_property(sprite, "rotation", deg_to_rad(-20), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.parallel().tween_property(sprite, "position", Vector2(-3, -2), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.tween_property(sprite, "rotation", deg_to_rad(0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.parallel().tween_property(sprite, "position", Vector2(0,0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#var bumb_tween = get_tree().create_tween().set_loops()
	#bumb_tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#bumb_tween.tween_property(sprite, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#bumb_tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#bumb_tween.tween_property(sprite, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#go_to_all_points(delta)
	##time_passed += delta
	##sprite.position = Vector2(0, sin(time_passed * 3) * 12.5)
#
#func go_to_all_points(delta):
	#print("hi")
	#var target = waypoints[current_target]
	#var movement = speed * delta
	#global_position = global_position.move_toward(target, movement)
	#if global_position.distance_to(target) < 0.1:
		#if target == last_point:
			#waypoints.reverse()
			#last_point = waypoints.back()
			#current_target = 0
		#current_target = (current_target + 1) % waypoints.size()
#
#func get_new_point(waypoints2, current_target2, speed2, last_point2):
	#waypoints = waypoints2
	#current_target = current_target2
	#speed = speed2
	#last_point = last_point2


func _on_timer_timeout() -> void:
	set_physics_process(true)
