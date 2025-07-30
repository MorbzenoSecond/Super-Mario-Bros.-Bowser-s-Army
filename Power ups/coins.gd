extends CharacterBody2D

class_name Coins

var used : bool = false
@onready var area = $Area2D as Area2D
@onready var coin_noice = $AudioStreamPlayer
@onready var collision = $CollisionShape2D
var can_be_pushed_down = false
var total_coins := 0
var gravity = 0
# Called when the node enters the scene tree for the first time.

func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.y += gravity * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !used:
		var entity = area.get_parent()
		if entity is not Player:
			return
		coin_noice.play()
		used = true
		var Level = get_tree().current_scene
		Level.control_coins(total_coins)
		hide()
		await coin_noice.finished

		queue_free()
	else:
		return

func _fall_by_force():
	throw_random()
	

func throw_random():
	if can_be_pushed_down:
		gravity = 900.0
		collision.disabled = false
		var angle = randf_range(-PI / 4, -3 * PI / 4)
		var speed = randf_range(150.0, 200.0)       
		velocity = Vector2.RIGHT.rotated(angle) * speed
