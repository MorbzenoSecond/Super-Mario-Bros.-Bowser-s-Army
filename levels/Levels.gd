extends Node2D

class_name Level

var true_amount = 0
var level_coins = 0
@onready var ui = $UI as UI
@export var scene_id: String = "level 2"

func control_coins(amount:int) -> void:
	true_amount += amount
	level_coins += amount
	print(true_amount)
	if level_coins >= 100:
		level_coins = level_coins - 100
	#UI.set_coins(level_coins)

func control_music_label(game:String, song:String):
	ui.set_game_and_music(game, song)

signal goto_room(room: PackedScene, cordenades:Vector2)
signal goto_main

func _on_transition_entered(_body: Node2D, path, cordenades, music):
	print(path)
	call_deferred("emit_signal", "goto_room", load(path) as PackedScene, cordenades as Vector2, music)

func _on_quit_entered(_body: Node2D):
	emit_signal("goto_main")
