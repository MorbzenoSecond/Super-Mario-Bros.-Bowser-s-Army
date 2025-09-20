extends  Block

class_name Mystery_box

enum bonusType {
	COIN,
	SHROOM,
	FLOWER,
	STAR
}
const FIRE_FLOWER_SCENE = preload("res://scenes/items/power ups/fire_flower.tscn")
const SHROOM_SCENE = preload("res://scenes/items/power ups/mushroom.tscn")
const COIN_SCENE = preload("res://scenes/items/coin.tscn")
const STAR_SCENE = preload("res://star.tscn")
@onready var sprite = $Sprite2D
@export var bonus_type: bonusType = bonusType.COIN
@export var invisible: bool = false
@onready var animation = $AnimationPlayer

var is_empty = false

func _process(delta: float) -> void:
	if $RayCast2D.is_colliding() and invisible:
		$CollisionShape2D. disabled = false
	elif !is_empty and invisible:
		$CollisionShape2D. disabled = true

func _ready() -> void:
	if invisible:
		sprite.play("invisible")
		$CollisionShape2D.disabled = true
	else:
		sprite.play("default")

func bump(player_mode: Player.PlayerMode, direction):
	if is_empty:
		return
	super.bump(player_mode, direction)
	make_empty()
	match bonus_type:
		bonusType.COIN:
			spawn_coin(direction)
		bonusType.SHROOM:
			if player_mode == Player.PlayerMode.BIG:
				spawn_flower(direction)
			else:
				spawn_shroom(direction)
		bonusType.FLOWER:
			spawn_flower(direction)
		bonusType.STAR:
			spawn_star(direction)


func make_empty():
	self.animation.play("less_size")
	$CollisionShape2D. disabled = false
	call_deferred("set_process", false)
	is_empty = true
	sprite.play("empty")

func spawn_coin(direction):
	var coin = COIN_SCENE.instantiate()
	coin.global_position = global_position + Vector2 (0,-8)
	var Level = get_tree().current_scene
	Level.add_child(coin)
	coin.coin_noice.play()
	coin.area.monitorable = false
	coin.area.monitoring = false
	Level.control_coins(1)
	var spawn_tween = get_tree().create_tween()
	if direction == "up":
		spawn_tween.tween_property(coin, "position", position + Vector2(0,-80), 0.4)
		spawn_tween.tween_property(coin, "position", position + Vector2(0,-8), 0.4)
	elif direction == "down":
		spawn_tween.tween_property(coin, "position", position + Vector2(0,80), 0.4)
		spawn_tween.tween_property(coin, "position", position + Vector2(0,8), 0.4)
	await spawn_tween.finished
	coin.queue_free()

func spawn_shroom(direction):
	var shroom = SHROOM_SCENE.instantiate()
	if direction == "up":
		shroom.global_position = global_position + Vector2 (0,-7)
	elif direction == "down":
		shroom.global_position = global_position + Vector2 (0,7)
	get_parent().add_child(shroom) 

func spawn_flower(direction):
	var flower = FIRE_FLOWER_SCENE.instantiate()
	if direction == "up":
		flower.global_position = global_position + Vector2 (0,-7)
	elif direction == "down":
		flower.global_position = global_position + Vector2 (0,7)
	get_parent().add_child(flower) 
	flower.spawn(direction)

func spawn_star(direction):
	var star = STAR_SCENE.instantiate()
	if direction == "up":
		star.global_position = global_position + Vector2 (0,-7)
	elif direction == "down":
		star.global_position = global_position + Vector2 (0,7)
	get_parent().add_child(star) 
	star.spawn(direction)
