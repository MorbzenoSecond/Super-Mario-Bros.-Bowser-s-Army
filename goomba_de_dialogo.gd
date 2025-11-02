extends Area2D

@export var dialogue = ""
var player_is_in :=false
var dialogue_started:= false 

@onready var noise = $Noise
@onready var timer = $Timer as Timer
@onready var sprite = $AnimatedSprite2D
var mario
signal change_skin(new_skin)


func change_mario_skin(new_skin):
	emit_signal("change_skin", new_skin)

var has_stop_talking := false 
func _ready() -> void:
	mario = get_tree().get_first_node_in_group("Player")
	connect("change_skin", Callable(mario, "_on_change_skin"))
	$AnimatedSprite2D.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("accedio el player ")
		player_is_in = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("salio el player ")
		player_is_in = false
		dialogue_started = false


func  _process(_delta: float) -> void:
	var player = get_tree().get_nodes_in_group("Player")[0]
	if player_is_in and !dialogue_started:
		if Input.is_action_pressed("Up"):
			DialogueManager.show_dialogue_balloon(load(dialogue), "start", [self])
			dialogue_started = true
	if player_is_in:
		if player.global_position.x > self.global_position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

func play_noises(seconds: float, animation: String):
	noise.play()
	timer.wait_time = seconds
	sprite.play(animation)
	timer.start()

func _on_timer_timeout() -> void:
	print("has started")
	noise.stop()
	sprite.play("default")
