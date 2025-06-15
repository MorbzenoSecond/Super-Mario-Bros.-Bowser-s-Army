extends Area2D

@export var path_to_scene: String
@export var cordenades: Vector2

func _on_body_entered(body: Node2D) -> void:
	var player = owner
	print("path to scene")
	player._on_transition_entered(body, path_to_scene, cordenades)
