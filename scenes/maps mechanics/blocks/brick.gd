extends Block

class_name Brick
@onready var no_hit_timer := $Timer
var can_hit := true

func bump(player_mode: Player.PlayerMode, direction:String):
	if can_hit:
		if player_mode == Player.PlayerMode.SMALL:
			super.bump(player_mode, direction)
			can_hit = false
			no_hit_timer.start(0.3)
			
		elif player_mode != Player.PlayerMode.SMALL:
			super.bump(player_mode, direction)
			queue_free()


func _on_timer_timeout() -> void:
	can_hit = true
