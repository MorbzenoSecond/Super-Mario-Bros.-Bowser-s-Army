extends PowerUps

class_name Super_star

@export var jumpvelocity = - 500
@onready var raycast = $Raycast
@onready var down = $Down

@export var afterimage_scene = preload("res://assets/visual effects/after_image.tscn")
var afterimage_timer := 0.0
var afterimage_interval := 0.1 

func spawn(direction):
	super.spawn(direction)

func _ready() -> void:
	super._ready()

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

func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.stream = load("res://assets/sounds/star_shine.wav")
	$AudioStreamPlayer2D.play()
