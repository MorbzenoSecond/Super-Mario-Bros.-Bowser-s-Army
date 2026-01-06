extends Node2D

@onready var line2d = $Line2D as Line2D
@onready var animatableBody = $super/AnimatableBody2D as AnimatableBody2D
var last_point : Vector2 
var waypoints := []
var current_target := 0
const SPRITE = preload("res://usefull gd/point_node.tscn")
enum SinLevels {SMALL, MEDIUM, BIG}

@export var speed : int = 100

@export var activable_to_use : bool = false
@export_group("sin")
@export var sin : bool = false
var sin_active : bool = false
var sin_force : Vector2
@export var sin_level : SinLevels = SinLevels.SMALL
@export_group("")

func _ready() -> void:
	$lines.scale = Vector2(0.3333333,0.3333333)
	if sin:
		match sin_level:
			SinLevels.SMALL:
				sin_force = Vector2(2, 12.5)
			SinLevels.MEDIUM:
				sin_force = Vector2(4, 20)
			SinLevels.BIG:
				sin_force = Vector2(6, 40)
	if activable_to_use:
		$super/AnimatableBody2D/Sprite2D.modulate = Color("ffffff")
	get_markers_positions()
	create_paths()

func get_markers_positions():
	for i in $points.get_children():
		if i is Marker2D:
			var break_point = SPRITE.instantiate()
			waypoints.append(i.global_position)
			$points.add_child(break_point)
			break_point.global_position = i.global_position + Vector2(0, 7)
			
	last_point = waypoints.back()

func create_paths():
	line2d.clear_points()
	#for i in waypoints:
		#line2d.add_point(line2d.to_local(i))
	for i in range(waypoints.size() - 1):
		create_lines(waypoints[i], waypoints[i+1])

func create_lines(last_point, new_point):
	var line = Line2D.new()
	
	line.texture = load("res://assets/sprites/particles_sprites/Line.png")
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.modulate = Color("ffffff")
	line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	line.begin_cap_mode = Line2D.LINE_CAP_BOX
	line.end_cap_mode = Line2D.LINE_CAP_BOX
	line.scale =  Vector2(0.3,0.3)
	line.add_point(line.to_local(last_point))
	line.add_point(line.to_local(new_point))
	line.width = 100
	line.scale
	$lines.add_child(line)
	#print("line_position: ", line.get_point_position(1))


func go_to_all_points(delta):
	var target = waypoints[current_target]
	var movement = speed * delta
	$super.global_position = $super.global_position.move_toward(target, movement)
	if $super.global_position.distance_to(target) < 0.1:
		if target == last_point:
			waypoints.reverse()
			last_point = waypoints.back()
			current_target = 0
		current_target = (current_target + 1) % waypoints.size()

var time_passed : float = 0.0

var current_characters_above = 0

func _physics_process(delta: float) -> void:
	
	#print(current_characters_above)
	if sin_active:
		time_passed += delta
		animatableBody.position = Vector2(0, sin(time_passed * 3) * sin_force.y)
		

	if activable_to_use: 
		go_to_all_points(delta)

var tween : Tween

func detected_body(body: Node2D) -> void:
	current_characters_above += 1
	if body.is_in_group("Player"):
		if activable_to_use or (tween and tween.is_running()):
			return
		$AudioStreamPlayer2D.play()
		tween = create_tween()
		tween.tween_property(animatableBody, "position:y", 5, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property($super/AnimatableBody2D/Sprite2D, "modulate", Color("ff2a6b"), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property($lines, "modulate", Color("5efdd4"), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(animatableBody, "position:y", 0, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property($super/AnimatableBody2D/Sprite2D, "modulate", Color("ffffff"), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property($lines, "modulate", Color("3de6f1"), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		await tween.finished
		color_cycle()
		if sin:
			sin_active = true
			
		activable_to_use = true

func detected_body_out(body: Node2D) -> void:
	current_characters_above -= 1

func color_cycle():
	tween = create_tween().set_loops()
	tween.tween_property($super/AnimatableBody2D/Sprite2D, "modulate", Color("ff2a6b"), 2.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(line2d, "default_color", Color("5efdd4"), 2.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($super/AnimatableBody2D/Sprite2D, "modulate", Color("ffffff"), 2.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(line2d, "default_color", Color("3de6f1"), 2.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
