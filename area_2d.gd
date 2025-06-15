extends Area2D


# Called when the node enters the scene tree for the first time.
@onready var collision := $CollisionShape2D as CollisionShape2D
@export var size_y = 100
@export var size_x = 100

func _ready() -> void: 
	collision.shape.extents = Vector2(size_x,size_y)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		for child in get_children():
			if child != collision:
				child.active()



func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		for child in get_children():
			if child != collision:
				child.inactive()
