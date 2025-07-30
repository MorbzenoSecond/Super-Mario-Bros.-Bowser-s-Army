extends CharacterBody2D

class_name Shroom
@onready var animated_sprite_2d = $AnimatedSprite2D 
@export var SPEED = 90.0
@export var gravity = 900
@onready var animarion = $AnimationPlayer
@onready var raycast = $Raycast

func _ready() -> void:
	animated_sprite_2d.play("default")
	animarion.play("spawn")
	z_index = -1
	var spawn_tween = get_tree().create_tween()
	await spawn_tween.tween_property(self, "position", position + Vector2(0,-37), 1)
	animarion.play("fully")

func _physics_process(delta: float) -> void:
	if raycast.is_colliding():
		SPEED *= -1
		raycast.scale.x = raycast.scale.x * -1
	velocity.x = SPEED 
	if not is_on_floor():
		velocity.y += gravity * delta
	 

	move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		queue_free()
