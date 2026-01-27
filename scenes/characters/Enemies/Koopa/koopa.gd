extends Enemy
class_name Koopa

@export var red : bool = false
@export var shell := false
@onready var area2d = $Area2D2
@onready var collision_koopa = $CollisionShape2D
@onready var collision_shell = $CollisionShape2D2
@onready var area_shell = $Area2D2/CollisionShape2D
@onready var floor = $Floor
@onready var animated_player = $AnimationPlayer
@onready var particles = $CPUParticles2D
var direction: int = 1
var is_spining :=true
var a_gopleado:= false


func _ready() -> void:
	update_shader()
	initial_position = global_position
	#super.inactive()

func _physics_process(_delta: float) -> void:
	if !shell:
		if red:
			if !floor.is_colliding() and is_on_floor():
				
				super._turn()
				floor.position.x = -floor.position.x 
				animated_sprite_2d.flip_h = -horizontal_speed < 0 

	var _previous_position = position
	move_and_slide()

func call_child_ready():
	shell = true
	if shell:
		animated_player.play("shell_hit")
		if is_spining:
			is_spining = false
		else:
			is_spining = true

func big_hit(_direction):
	#super.die_by_block()
	$CollisionShape2D.call_deferred("set_disabled", true)
	gravity = 0
	$Area2D.set_deferred("monitorable", false)
	$Area2D.set_deferred("monitoring", false)
	await get_tree().create_timer(0.7).timeout
	animated_sprite_2d.visible = false


func shell_size():
	collision_koopa.disabled = true
	area_collision.disabled = true
	collision_shell.disabled = false
	area_shell.disabled = false

func update_shader():
	animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	animated_sprite_2d.material.set_shader_parameter("red", red)
