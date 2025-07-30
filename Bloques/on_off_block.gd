extends  Block

class_name On_off_block

@onready var animated_sprite_2d = $Sprite2D
@export var block_State: bool = false
signal state_changed(new_state:bool)

func _ready() -> void:
	if block_State:
		animated_sprite_2d.play("On")
	else:
		animated_sprite_2d.play("Off")

func bump(player_mode: Player.PlayerMode, direction):
	super.bump(player_mode, direction)
	if block_State:
		animated_sprite_2d.play("Off")
		print ("apagado")
		block_State = false
	else:
		animated_sprite_2d.play("On")
		block_State = true 
		print("encendido")
	emit_signal("state_changed", block_State)

func toggle_state():
	block_State = !block_State
	_update_animation()
	emit_signal("state_changed", block_State)

func _update_animation():
	if block_State:
		animated_sprite_2d.play("On")
	else:
		animated_sprite_2d.play("Off")
