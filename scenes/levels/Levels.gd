extends Node2D

class_name Level

var true_amount = 0
var level_coins = 0
@onready var ui = $UI as UI
@export var scene_id: String = "level 2"
signal goto_room(room: PackedScene, cordenades:Vector2)
signal goto_main
signal new_music
signal map_world
signal flag_reached
signal enemies_on_screen

func control_coins(amount:int) -> void:
	true_amount += amount
	level_coins += amount
	if level_coins >= 100:
		level_coins = level_coins - 100
	#UI.set_coins(level_coins)

func control_music_label(game:String, song:String):
	ui.set_game_and_music(game, song)

func finished():
	get_tree().call_group("Enemies", "all_die")
	get_tree().call_group("coins", "_fall_by_force")
	emit_signal("flag_reached")

func _stablish_current_music(new_music):
	call_deferred("emit_signal", "new_music", new_music)

func _on_transition_entered(_body: Node2D, path, music, pipe, conection):
	call_deferred("emit_signal", "goto_room", load(path) as PackedScene, music, pipe, conection)

func _on_quit_entered(_body: Node2D):
	emit_signal("goto_main")

func level_end():
	emit_signal("map_world")
