extends CharacterBody2D

class_name PowerUps

var can_move = true
@onready var animated_sprite_2d = $AnimatedSprite2D 
@export var SPEED = 30
@export var gravity = GameState.global_gravity
@onready var animarion = $AnimationPlayer

func _ready() -> void:
	animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	animated_sprite_2d.play("default")
	z_index = -1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func spawn(direction):
	shine()
	can_move = false
	var spawn_tween = get_tree().create_tween().set_parallel(true)
	if direction == "up":
		spawn_tween.tween_property(self, "position", position + Vector2(0,-10), 0.6).set_ease(tween.EASE_IN_OUT)
		spawn_tween.tween_property(self, "scale", Vector2(0.6, 1.15), 0.6).set_ease(tween.EASE_IN_OUT)
		spawn_tween.chain().tween_property(self, "scale", Vector2(1,1), 0.3).set_ease(tween.EASE_IN_OUT)
		await spawn_tween.finished
		can_move = true
	elif  direction == "down":
		spawn_tween.tween_property(self, "position", position + Vector2(0, 10), 0.6).set_ease(tween.EASE_IN_OUT)
		spawn_tween.tween_property(self, "scale", Vector2(0.6, 1.15), 0.6).set_ease(tween.EASE_IN_OUT)
		spawn_tween.chain().tween_property(self, "scale", Vector2(1,1), 0.3).set_ease(tween.EASE_IN_OUT)
		await spawn_tween.finished
		can_move = true

const MESSAGE_SCENE = preload("res://usefull gd/in_game_message.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		queue_free()

var tween : Tween
func shine():
	tween = get_tree().create_tween()
	tween.tween_interval(0.3)
	tween.tween_property(animated_sprite_2d.material, "shader_parameter/shine_progress", 1, 0.6)


var scale_tween = Tween

func scale_bounce() -> void:
	scale_tween = get_tree().create_tween().set_loops()
	scale_tween.set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(self, "scale", Vector2(1.15, 0.85), 0.4).set_ease(tween.EASE_IN_OUT)
	scale_tween.tween_property(self, "scale", Vector2(0.85, 1.15), 0.4).set_ease(tween.EASE_IN_OUT)
