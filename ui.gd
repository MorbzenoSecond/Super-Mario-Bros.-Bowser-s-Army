extends CanvasLayer

class_name UI
@onready var coins_label = $MarginContainer/HBoxContainer/CoinsLabel
@onready var enemies_label = $MarginContainer/HBoxContainer/EnemiesLabel
@onready var gameLabel = $MarginContainer2/juego
@onready var songLabel = $MarginContainer2/cancion
@onready var animationplayer = $AnimationPlayer
@onready var timer = $Timer
@onready var area2d = $MarginContainer2/ColorRect/Area2D as Area2D


func _ready() -> void:
	area2d.monitorable = false
	area2d.monitoring = false

func set_coins(coins:int):
	coins_label.text = "         x %d" % coins


func set_game_and_music(game:String, song:String):
	timer.start()
	animationplayer.play("send front")
	gameLabel.text = game
	songLabel.text = song




func _on_timer_timeout() -> void:
	animationplayer.play("send back")
	await animationplayer.animation_finished
	area2d.monitorable = true
	area2d.monitoring = true




func _on_area_2d_mouse_entered() -> void:
	area2d.monitorable = false
	area2d.monitoring = false
	animationplayer.play("send front")
	timer.start()
