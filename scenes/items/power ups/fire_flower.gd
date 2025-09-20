extends CharacterBody2D

class_name Fire_flower
@onready var animated_sprite_2d = $AnimatedSprite2D
var gravity = 600.0
# Called when the node enters the scene tree for the first time.

func spawn(direction):
	if direction == "up":
		var spawn_tween = get_tree().create_tween()
		spawn_tween.tween_property(self, "position", position + Vector2(0,-37), 1)
	if direction == "down":
		var spawn_tween = get_tree().create_tween()
		spawn_tween.tween_property(self, "position", position + Vector2(0, 37), 1)

func _ready() -> void:
	animated_sprite_2d.play("default")
	z_index = -1


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += delta * gravity
	move_and_slide()

func used()->void:
	queue_free()
