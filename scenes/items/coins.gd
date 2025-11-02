extends CharacterBody2D

class_name Coins

var used : bool = false
@onready var area = $Area2D as Area2D
@onready var coin_noice = $AudioStreamPlayer
@onready var collision = $CollisionShape2D
var can_be_pushed_down = false

var total_coins := 0
var special_coin_number :String= ""
var gravity = 0
var is_special_coin = false
# Called when the node enters the scene tree for the first time.

func _process(delta: float) -> void:
	global_position.y += sin(Time.get_ticks_msec() / 500 * 1) * 7.5 * delta


func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.y += gravity * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !used:
		var entity = area.get_parent()
		if entity is not Player:
			return
		grab(false)
	else:
		return

func grab(going_up:bool):
	var direction : int
	if !going_up:
		direction = 1
	else:
		direction = -1
	coin_noice.play()
	used = true
	if !is_special_coin:
		var Level = get_tree().current_scene
		Level.control_coins(total_coins)
	else:
		GameState.specialCoins[special_coin_number] = true
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(global_position.x,global_position.y - 150 * direction), 0.4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2(global_position.x,global_position.y + 30 * direction), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate", Color("ffffff00"), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished

	queue_free()

func _fall_by_force():
	throw_random()

func throw_random():
	if can_be_pushed_down:
		set_process(false)
		gravity = 900.0
		collision.disabled = false
		var angle = randf_range(-PI / 4, -3 * PI / 4)
		var speed = randf_range(150.0, 200.0)       
		velocity = Vector2.RIGHT.rotated(angle) * speed
