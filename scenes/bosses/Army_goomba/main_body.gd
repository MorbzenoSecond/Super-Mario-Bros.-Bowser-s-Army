extends CharacterBody2D


@onready var camera: Camera2D = get_tree().get_first_node_in_group("active_camera")

@onready var anim = $"../AnimationPlayer"
@onready var sprite = $Sprite2D 
@onready var cannon = $Army_goomba_cannon

const STEP_PARTICLES = preload("res://scenes/bosses/Army_goomba/army_goomba_particles.tscn")
var SPEED_VAL = 70
var mario

func _ready() -> void:

	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		mario = players[0]

func mario_is_left() -> bool:
	if global_position.x < mario.global_position.x:
		return true
	else:
		return false

func _physics_process(delta: float) -> void:
	print(rotation_degrees)
	if not is_on_floor():
		velocity.y += 900 * delta
	move_and_slide()

func orientar_personaje(direccion: int):
	var escala_base = abs(scale.y) 
	
	scale.x = direccion
	$"Army_goomba_cannon/Sprite2D3".scale = $"Army_goomba_cannon/Sprite2D3".scale * -1




func _on_timer_timeout() -> void:
	pass


func step(shake_force):
	var particles = STEP_PARTICLES.instantiate()
	add_child(particles)
	
	$footsteps.play()
	particles.setup($Marker2D.global_position)
	camera.trigger_shake(10)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Brick_golpeable"):
		body.bump(Player.PlayerMode.FIRE, "up")

func rotate_children(degree):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(degree), 1.75)
	if degree > 0:
		tween.tween_property(self, "rotation", deg_to_rad(0), 0)
		
