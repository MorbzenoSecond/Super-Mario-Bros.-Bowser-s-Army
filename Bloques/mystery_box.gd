extends  Block

class_name Mystery_box

enum bonusType {
	COIN,
	SHROOM,
	FLOWER
}
const FIRE_FLOWER_SCENE = preload("res://Power ups/fire_flower.tscn")
const COIN_SCENE = preload("res://Power ups/coin.tscn")
@onready var animated_sprite_2d = $Sprite2D
@export var bonus_type: bonusType = bonusType.COIN
@export var invisible: bool = false

var is_empty = false

func _ready() -> void:
	if invisible:
		animated_sprite_2d.play("invisible")
	else:
		animated_sprite_2d.play("default")

func bump(player_mode: Player.PlayerMode):
	if is_empty:
		return
	super.bump(player_mode)
	make_empty()
	match bonus_type:
		bonusType.COIN:
			spawn_coin()
		bonusType.SHROOM:
			spawn_shroom()
		bonusType.FLOWER:
			spawn_flower()

func make_empty():
	is_empty = true
	animated_sprite_2d.play("empty")

func spawn_coin():
	var coin = COIN_SCENE.instantiate()
	coin.global_position = global_position + Vector2 (0,-8)
	var Level = get_tree().current_scene
	Level.add_child(coin)
	coin.coin_noice.play()
	coin.area.monitorable = false
	coin.area.monitoring = false
	Level.control_coins(1)
	var spawn_tween = get_tree().create_tween()
	spawn_tween.tween_property(coin, "position", position + Vector2(0,-80), 0.4)
	spawn_tween.tween_property(coin, "position", position + Vector2(0,-8), 0.4)
	await spawn_tween.finished
	coin.queue_free()

func spawn_shroom():
	print("shroom")

func spawn_flower():
	var flower = FIRE_FLOWER_SCENE.instantiate()
	flower.global_position = global_position + Vector2 (0,-7)
	get_parent().add_child(flower) 
