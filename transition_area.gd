extends Node2D

@export var path_to_scene: String

signal goto_room(room: PackedScene)
signal goto_main

func _on_transition_entered(_body: Node2D):
	emit_signal("goto_room", load(path_to_scene) as PackedScene)

func _on_quit_entered(_body: Node2D):
	emit_signal("goto_main")
