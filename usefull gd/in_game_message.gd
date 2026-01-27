extends Node2D

@onready var point = $points as Label
@onready var sprite = $Sprite2D as Sprite2D

func setup(texture, points):
	fade_in_fade_out()
	if !texture == null:
		point.visible = false
		sprite.texture = texture
		return
	if !points == null:
		sprite.visible = false
		point.text = str(points)
		return

var tween : Tween

func fade_in_fade_out():
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color("ffffff"), 0.5)
	tween.parallel().tween_property(self, "global_position", global_position + Vector2(15, -5), 1)
	tween.tween_property(self, "modulate", Color("ffffff00"), 0.5)
	tween.parallel().tween_property(self, "global_position", global_position + Vector2(22, -10.5), 0.5)
	tween.parallel().tween_property(self, "scale", Vector2(0, 8), 0.5)

func _on_timer_timeout() -> void:
	queue_free()
