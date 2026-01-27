extends Node2D

var player_is_in = false
var mario_has_entered = false
@onready var pole = $Pole
@onready var flag = $BanderasBowser
@onready var base = $ColorRect2
@onready var mario_flad = $BanderasMario
@onready var shape = $ShapeCast2D

@export var distance = 5
@export var unlock_path : String = ""

var global_flag_pos
var global_mario_flag_pos
var mario_touched = false
var mario_touch_pos


func _ready() -> void:
	if distance == 0:
		distance = 1
	flag.position.y = (-distance * 22) 
	pole.position.y = (-distance * 22) 
	
	# Obtenemos la posición global del flag y de la base
	global_flag_pos = Vector2(pole.global_position.x + 15,pole.global_position.y) 
	global_mario_flag_pos = Vector2(mario_flad.global_position.x,mario_flad.global_position.y) 
	# Transformamos las posiciones globales a locales dentro del Line2D
	var local_flag_pos = $Line2D.to_local(global_flag_pos)
	$Line2D.add_point(local_flag_pos-Vector2(15,0))
	
	var cast_direction = flag.global_position - shape.global_position
	shape.target_position = cast_direction
	shape.enabled = true
	shape.force_shapecast_update()

func _physics_process(_delta: float) -> void:
	if !shape.is_colliding():
		return
	var collision = shape.get_collider(0)
	if !mario_touched and shape.is_colliding():
		print(mario_touch_pos)
		if  collision.is_in_group("Player"):
			mario_touched = true
			player_is_in = true
			mario_touch_pos = shape.get_collision_point(0)
			print(mario_touch_pos)

func _process(_delta: float) -> void:
	var level = owner
	if player_is_in :
		get_flag_down()
		if !mario_has_entered:
			level.finished()
			mario_has_entered = true
			$Timer.start()

func enter_level():
	var level = owner
	LevelDataManager.data["levels"][GameState.actualLevel]["LevelStatus"] = true
	LevelDataManager.data["levels"][unlock_path]["path_unlocken"] = true
	LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"]["special_coin_1"] = GameState.specialCoins["special_coin_1"]
	LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"]["special_coin_2"] = GameState.specialCoins["special_coin_2"]
	LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"]["special_coin_3"] = GameState.specialCoins["special_coin_3"]
	LevelDataManager.save()
	level.level_end()

func get_flag_down():
	if flag.global_position.y < global_mario_flag_pos.y:
		flag.global_position.y += 1
		flag.visible = true
	else:
		flag.visible = false
	if mario_flad.global_position.y> mario_touch_pos.y:
		mario_flad.global_position.y -= 1
		mario_flad.visible = true
		#if  mario_touch_pos.y < pole.global_position.y +40:
			#mario_flad.color = Color(1.0, 0.84, 0.0)

func _on_timer_timeout() -> void:
	enter_level()
