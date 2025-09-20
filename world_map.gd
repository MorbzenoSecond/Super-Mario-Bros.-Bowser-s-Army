extends Node2D

var player_is_in = false

@export var path_to_scene: String
@export var cordenades: Vector2
@export var path_activate: bool
@export var new_music: String
var in_level = false
signal goto_room(room: PackedScene, cordenades:Vector2)
signal goto_main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_is_in and Input.is_action_just_pressed("enter"):
		hide()

func _on_transition_entered(_body: Node2D, path, cordenades, music):
	call_deferred("emit_signal", "goto_room", load(path) as PackedScene, cordenades as Vector2, music)

func _on_quit_entered(_body: Node2D):
	emit_signal("goto_main")

func _enter_level(path_to_scene, cordenades, new_music):
	var game = owner
	game._on_goto_room(load(path_to_scene) as PackedScene,cordenades,new_music)
