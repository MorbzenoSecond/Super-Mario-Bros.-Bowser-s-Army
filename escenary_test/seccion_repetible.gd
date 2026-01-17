extends TileMapLayer

@onready var father= self.get_parent()
# Called when the node enters the scene tree for the first time.

@onready var front_trigger: Area2D = $front
@onready var back_trigger: Area2D = $back

func enable_front(enabled: bool) -> void:
	front_trigger.monitoring = enabled

func enable_back(enabled: bool) -> void:
	back_trigger.monitoring = enabled

func disable_all() -> void:
	front_trigger.monitoring = false
	back_trigger.monitoring = false

func _on_front_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_parent().get_parent().call_deferred("spawn_front")


func _on_back_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_parent().get_parent().call_deferred("spawn_back")
