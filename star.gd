extends CharacterBody2D

class_name Super_star

@export var jumpvelocity = - 500
@onready var animated_sprite_2d = $Star 
@export var SPEED = 150.0
@export var gravity = 900
@onready var animarion = $AnimationPlayer
@onready var raycast = $Raycast
@onready var down = $Down

@export var afterimage_scene = preload("res://after_image.tscn")
var afterimage_timer := 0.0
var afterimage_interval := 0.1 

func spawn(direction):
	var spawn_tween = get_tree().create_tween()
	if direction == "up":
		await spawn_tween.tween_property(self, "position", position + Vector2(0,-37), 1)
	if direction == "down":
		await spawn_tween.tween_property(self, "position", position + Vector2(0, 37), 1)


func _ready() -> void:
	animated_sprite_2d.play("default")
	animarion.play("spawn")
	z_index = -1
	animarion.play("fully")

func _physics_process(delta: float) -> void:
	if raycast.is_colliding():
		SPEED *= -1
		raycast.scale.x = raycast.scale.x * -1
	velocity.x = SPEED 
	if not is_on_floor():
		velocity.y += gravity * delta
	 
	if down.is_colliding():
		velocity.y = jumpvelocity
	move_and_slide()

func _process(delta):
	afterimage_timer += delta
	if afterimage_timer >= afterimage_interval:
		afterimage_timer = 0.0
		spawn_afterimage()

func spawn_afterimage():
	var img = afterimage_scene.instantiate()
	img.star_setup(
		animated_sprite_2d,  # AnimatedSprite2D del personaje
		global_position,
	)
	get_parent().add_child(img)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		queue_free()
