extends Node

@onready var timer = $Timer

var cankill := false


func _on_body_entered(body: Node2D) -> void:
	if !cankill:
		return

	if body.is_in_group("Player") and not body.is_dead:
		body.die()


func _on_timer_timeout() -> void:
	cankill = true
