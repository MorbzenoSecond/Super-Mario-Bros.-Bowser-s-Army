extends State
class_name PlayerPound

var collision_actual
var has_left_floor := false
var landed := false
var is_in_correct_floor:= false
@onready var land_timer := $LandTimer

func Enter() -> void:
	player.velocity.y = player.velocity.y / 2
	player.velocity.x = player.velocity.x / 2
	player.animation_player.play("pound")
	player.down.enabled = false
	player.get_current_sprite().play("pound")
	player.GRAVITY = 10.0
	$Timer.start()

func Physics_Update(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	if abs(player.velocity.x) > 100:
		if direction == 1:
			player.velocity.x -= 5
		elif direction == -1:
			player.velocity.x += 5

	if not player.is_on_floor() :
		has_left_floor = true

	if has_left_floor and player.is_on_floor() and not landed and is_in_correct_floor:
		  
		if !player.get_floor_normal().x == 0:
			Transitioned.emit(self, "PlayerSliding")
		landed = true
		player.velocity.x = 0
		player.get_current_sprite().play("pound_fall")
		land_timer.start(0.3)

	if player.down.is_colliding():
		var count = player.down.get_collision_count()
		for i in range(count):
			collision_actual = player.down.get_collider(i)
			if collision_actual != null:
				handle_movement_collision(collision_actual)

func handle_movement_collision(collision):
	if collision.is_in_group("Brick_rompible"):
		(collision as Block).bump(player.Player_mode, "down")
		return
	elif collision.is_in_group("Brick_golpeable"):
		(collision as Block).bump(player.Player_mode, "down")
		is_in_correct_floor = true
	elif collision: 
		is_in_correct_floor = true



func _on_timer_timeout() -> void:
	player.down.enabled = true
	player.GRAVITY = 900.0

func _on_land_timer_timeout() -> void:
	Transitioned.emit(self, "PlayerIdle")

func Exit() -> void:
	player.GRAVITY = 900.0
	is_in_correct_floor = false
	has_left_floor = false
	landed = false
	$Timer.stop()
	land_timer.stop()
