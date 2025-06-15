extends Area2D

class_name Fire_flower
@onready var animated_sprite_2d = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("default")
	z_index = -1
	var spawn_tween = get_tree().create_tween()
	spawn_tween.tween_property(self, "position", position + Vector2(0,-37), 1)

func used()->void:
	queue_free()
