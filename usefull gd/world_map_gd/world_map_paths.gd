extends Node2D
@onready var line2d = $Line2D as Line2D
@onready var Markers = $Points
@onready var direction_taked = $direction_taked

var waypoints := []
var current_target := 0
var last_point
var path_initial = true

@export var path_id : String
@export var speed : int = 100


func _ready() -> void:
	set_physics_process(false)
	line2d.clear_points()
	await get_tree().process_frame
	print(LevelDataManager.data["levels"][path_id]["path_unlocken"])
	if LevelDataManager.data["levels"][path_id]["path_unlocken"]:
		get_markers_positions()
		create_paths()
	

func get_markers_positions():
	for i in Markers.get_children():
		if i is Marker2D:
			#var break_point = SPRITE.instantiate()
			waypoints.append(i.global_position)
			#add_child(break_point)
			#break_point.global_position = i.global_position
	last_point = waypoints.back()

func create_paths():
	line2d.clear_points()
	for i in range(waypoints.size() - 1):
		create_lines(waypoints[i], waypoints[i+1])

func create_lines(last_point, new_point):
	var line = Line2D.new()
	
	line.texture = load("res://assets/sprites/particles_sprites/Line.png")
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	line.begin_cap_mode = Line2D.LINE_CAP_BOX
	line.end_cap_mode = Line2D.LINE_CAP_BOX
	line.add_point(line.to_local(last_point))
	line.add_point(line.to_local(new_point))
	line.width = 36
	$lines.add_child(line)

func _on_reloadMap():
	pass
	#set_physics_process(true)

var on_end = false

func go_to_all_points(delta):
	print(last_point, " ", direction_taked.global_position)
	var target = waypoints[current_target]
	var movement = speed * delta
	
	if direction_taked.global_position.distance_to(target) < 0.1:
		if target == last_point:
			on_end = true
			$Timer.stop()
			return
		else:
			current_target = (current_target + 1) % waypoints.size()
	direction_taked.global_position = direction_taked.global_position.move_toward(target, movement)
	
#func _physics_process(delta: float) -> void:
	#if !on_end:
		#go_to_all_points(delta)

func _on_timer_timeout() -> void:
	line2d.add_point(direction_taked.global_position)
