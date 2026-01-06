extends StaticBody2D

enum color {
	blue,
	red
}
@onready var sprite = $Sprite2D
@onready var collion = $CollisionShape2D
@export var start_color: color = color.blue
@export var state: bool
@onready var shader_mat : ShaderMaterial= $Sprite2D.material as ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_state(state)
	

func _on_state_changed(new_state: bool, _block_id) -> void:
	# Azul sigue la señal tal cual, rojo lo invierte
	if start_color == color.blue:
		update_state(new_state)
	else: # color.red
		update_state(!new_state)

func update_state(active: bool) -> void:
	state = active
	match start_color:
		color.blue:
			if active:
				sprite.play("blue_on")
				collion.disabled = false
			else:
				sprite.play("blue_off")
				collion.disabled = true
		color.red:
			if active:
				sprite.play("red_on")
				collion.disabled = false
			else:
				sprite.play("red_off")
				collion.disabled = true
	
