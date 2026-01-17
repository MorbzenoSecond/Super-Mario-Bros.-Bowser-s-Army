extends CharacterBody2D


@onready var camera: Camera2D = get_tree().get_first_node_in_group("active_camera")

@onready var anim = $"../AnimationPlayer"
@onready var sprite = $Sprite2D 
@onready var cannon = $Army_goomba_cannon

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
	print(mario.velocity)
	if not is_on_floor():
		velocity.y += 900 * delta
	move_and_slide()

func orientar_personaje(direccion: int):
	#var escala_base = abs(scale.y) 
	
	scale.x = direccion
	$"Army_goomba_cannon/Sprite2D3".scale = $"Army_goomba_cannon/Sprite2D3".scale * -1


func _on_timer_timeout() -> void:
	pass


func step(shake_force):
	$dust.restart()
	$footsteps.play()
	camera.trigger_shake(10)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Brick_golpeable"):
		body.bump(Player.PlayerMode.FIRE, "up")
	if body is Enemy:
		print("jhsakljadskñljñ{ladsas}")
		body.die_by_block()




func rotate_children(degree):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(degree), 2.1)
	if degree > 0:
		tween.tween_property(self, "rotation", deg_to_rad(0), 0)

var scale_tween: Tween

func hit():
	velocity.x = 0
	scale_tween = get_tree().create_tween()
	var modulate_tween = get_tree().create_tween()
	
	modulate_tween.tween_property(self, "modulate", Color("ff0000"), 0.12)
	modulate_tween.tween_property(self, "modulate", Color("ff8585"), 0.12)
	modulate_tween.tween_property(self, "modulate", Color("ff3b3b"), 0.12)
	modulate_tween.tween_property(self, "modulate", Color("ffffff"), 0.12)
	
	
	var multiplayer : int
	if scale.y > 0: 
		multiplayer = 1
	else:
		multiplayer = -1
		
	scale_tween.tween_property(self, "scale", Vector2(1.5, 0.5 * multiplayer), 0.12)
	scale_tween.tween_property(self, "scale", Vector2(0.75, 1.25 * multiplayer), 0.12)
	scale_tween.tween_property(self, "scale", Vector2(1.15, 0.85 * multiplayer), 0.12)
	scale_tween.tween_property(self, "scale", Vector2(1, 1 * multiplayer), 0.12)
	
	await  scale_tween.finished
	$State_machine.change_state("ArmyGoombaIdle")

func landing_animation():
	if scale_tween and scale_tween.is_running():
		scale_tween.kill()
	scale_tween = get_tree().create_tween()

	var multiplayer : int
	if scale.y > 0: 
		multiplayer = 1
	else:
		multiplayer = -1
		
	scale_tween.tween_property(self, "scale", Vector2(1.7, 0.3 * multiplayer), 0.15)
	scale_tween.tween_property(self, "scale", Vector2(1, 1 * multiplayer), 0.25)

func going_up_animation():
	scale_tween = get_tree().create_tween()
	
	var multiplayer : int
	if scale.y > 0: 
		multiplayer = 1
	else:
		multiplayer = -1
		
	scale_tween.tween_property(self, "scale", Vector2(1.2, 0.8 * multiplayer), 0.25)
	scale_tween.tween_property(self, "scale", Vector2(0.8, 1.2 * multiplayer), 0.25)
	scale_tween.tween_property(self, "scale", Vector2(1, 1 * multiplayer), 1.3)
	scale_tween.tween_property(self, "scale", Vector2(1.7, 0.3 * multiplayer), 3)

@onready var dust = $dust
@onready var landing_dust = $Landing_dust
func stomp():
	mario.velocity.x = 0
	landing_animation()
	$landing.play()
	landing_dust.restart()
	camera.trigger_shake(35)


func _on_mario_touch_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		mario_bounce(body)

@export var bounce_force := 800.0
@export var max_bounce_speed := 600.0

func mario_bounce(body):
	var direction = (body.global_position -global_position).normalized()
	body.velocity += direction * bounce_force

	if body.velocity.length() > max_bounce_speed:
		body.velocity = body.velocity.normalized() * max_bounce_speed
