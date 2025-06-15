extends StaticBody2D

enum color {
	blue,
	red
}
@onready var sprite = $Sprite2D
@onready var collion = $CollisionShape2D
@export var start_color: color = color.blue
@export var state: bool
@export var speed: int = 100
@onready var shader_mat : ShaderMaterial= $Sprite2D.material as ShaderMaterial
var new_color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.material = sprite.material.duplicate()
	shader_mat = sprite.material as ShaderMaterial
	update_state(state)
	
func _process(delta: float) -> void:
	for body in $Area2D.get_overlapping_bodies():
		if new_color == "blue":
			body.global_position.x += speed * delta
		else:
			body.global_position.x -= speed * delta

	

func _on_state_changed(new_state: bool) -> void:
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
				blue_coveyor()
			else:
				red_coveyor()
		color.red:
			if active:
				blue_coveyor()
			else:
				red_coveyor()
				
	
func blue_coveyor():
	new_color = "blue"
	sprite.play()
	sprite.material.set("shader_param/NEWCOLOR1", Color("7c8df3"))
	sprite.material.set("shader_param/NEWCOLOR2", Color("5b6ee1"))
	sprite.material.set("shader_param/NEWCOLOR3", Color("3949ad"))
	sprite.material.set("shader_param/NEWCOLOR4", Color("3949ad"))

func red_coveyor():
	new_color = "red"
	sprite.play_backwards()
	sprite.material.set("shader_param/NEWCOLOR1", Color("cc4040"))
	sprite.material.set("shader_param/NEWCOLOR2", Color("ac3232"))
	sprite.material.set("shader_param/NEWCOLOR3", Color("852121"))
	sprite.material.set("shader_param/NEWCOLOR4", Color("7c1818"))
