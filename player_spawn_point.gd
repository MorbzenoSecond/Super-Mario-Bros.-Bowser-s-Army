extends Node

var activated_checkpoints = {}
var last_checkpoint_scene = ""
var last_checkpoint_position = Vector2.ZERO
var last_checkpoint_music = ""
var start_point = Vector2.ZERO
var respawn_pending = false

func set_checkpoint(scene_path: String, position: Vector2, music: String):
	last_checkpoint_scene = scene_path
	last_checkpoint_position = position
	last_checkpoint_music = music
	print(last_checkpoint_music)

func respawn_player(player: Node2D):
	if last_checkpoint_position != Vector2.ZERO:
		player.global_position = last_checkpoint_position
		print(last_checkpoint_position)
	else:
		print("No hay checkpoint definido aún.")

func start_point_selector(spawn):
	start_point = spawn
