extends Area2D

@export var level_id : String
@export var level_name: String
@export var path_to_scene: String
@export var cordenades: Vector2
@export var path_activate: bool
@export var music: String
var player_is_in = false


func _process(delta: float) -> void:
	var map = owner
	if player_is_in and Input.is_action_just_pressed("enter") and !map.in_level:
		map.in_level = true
		enter_level()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("world-player"):
		player_is_in = true
	print("hola")

func _on_area_exited(area: Area2D) -> void:
	player_is_in = false
	print("adios")

func enter_level():
	var level = owner
	level._enter_level(path_to_scene, cordenades, music)
