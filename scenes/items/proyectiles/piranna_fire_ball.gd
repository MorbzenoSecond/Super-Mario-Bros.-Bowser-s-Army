extends Area2D

@export var horizontal_speed = 50
@export var bounce_force = 250
@onready var timer := $Timer
@onready var fireParticles := $Fire
@onready var poisonParticles := $Poison
@onready var skull := $Poison/skull
@onready var timer2 := $Timer2
var poison := false
var velocity := Vector2.ZERO
var has_hit = false

func setup(direction, PirannaType):
	if PirannaType == 1:
		horizontal_speed = horizontal_speed * 3
		fireParticles.emitting =  true
	if PirannaType == 2:
		poison = true
		poisonParticles.emitting = true
		skull.emitting = true
	timer.start(4)
	velocity = direction.normalized() * horizontal_speed

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position -= velocity * delta

	if poison:
		poisonParticles.emission_sphere_radius += 0.03
		skull.self_modulate.a -= 0.001
		poisonParticles.self_modulate.a -= 0.001
	else:
		fireParticles.self_modulate.a -= 0.001
		
		#$CPUParticles2D.emission_sphere_radius += 1

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.handle_proyectil_collision(2)

func _on_timer_2_timeout() -> void:
	skull.z_index = 1501
	poisonParticles.z_index = 1500
