extends Area2D

@export var level_id : String
@export var level_name: String
@export var path_to_scene: String
@export var cordenades: Vector2
@export var path_activate: bool
@export var music: String
@onready var level = $level
enum levelStatus { complete, incomplete, golden, locked } 
var level_status: levelStatus = levelStatus.incomplete
signal reloadMap
var player_is_in = false

var completeLevelArray = [Color(0.067, 0.09, 0.286, 1), Color(0.11, 0.165, 0.502, 1), 
				Color(0.157, 0.239, 0.737, 1), Color(0.416, 0.614, 1, 1), Color(0.702, 0.773, 0.996 ,1)]

var goldenLevelArray = [Color(0.439, 0.298, 0.035, 1), Color(0.651, 0.416, 0.059, 1), 
				Color(0.878, 0.659, 0.125, 1), Color(1, 0.839, 0.251, 1), Color(1, 0.965, 0.627 ,1)]

var incompleteLevelArray  = [Color(0.29, 0.055, 0.055, 1), Color(0.424, 0.075, 0.075, 1), 
				Color(0.686, 0.125, 0.125, 1), Color(0.878, 0.251, 0.188, 1), Color(1, 0.541, 0.314 ,1)]

func update_shader():
	print(level_status)
	var currentColor = [0]
	match level_status:
		levelStatus.complete:
			currentColor = completeLevelArray
		levelStatus.incomplete:
			currentColor = incompleteLevelArray
		levelStatus.golden:
			currentColor = goldenLevelArray
		levelStatus.locked:
			return
	level.material = level.material.duplicate()
	level.material.set_shader_parameter("NEWCOLOR1", currentColor[0])
	level.material.set_shader_parameter("NEWCOLOR2", currentColor[1])
	level.material.set_shader_parameter("NEWCOLOR3", currentColor[2])
	level.material.set_shader_parameter("NEWCOLOR4", currentColor[3])
	level.material.set_shader_parameter("NEWCOLOR5", currentColor[4])

func _on_reloadMap():
	if LevelDataManager.data["levels"].has(level_name):
		if !LevelDataManager.data["levels"][level_name]["path_unlocken"]:
			print("golden")
			level_status = levelStatus.locked
		else:
			level_status = levelStatus.complete if LevelDataManager.data["levels"][level_name]["LevelStatus"] else levelStatus.incomplete
		var coin_keys = LevelDataManager.data["levels"][level_name]["GoldenCoins"].keys()
		for key in coin_keys:
			var coin_node_name =  key
			
			if has_node(coin_node_name):
				var coin_node = get_node(coin_node_name)
				
				if LevelDataManager.data["levels"][level_name]["GoldenCoins"][key]:
					coin_node.show()
				else:
					coin_node.hide()
			else:
				pass

	update_shader()

func _ready() -> void:
	$special_coin_1.play("default")
	$special_coin_2.play("default")
	$special_coin_3.play("default")
	await get_tree().process_frame
	_on_reloadMap()
	add_to_group("mapLevel")

func _process(delta: float) -> void:
	var map = owner
	if player_is_in and Input.is_action_just_pressed("enter") and !map.in_level:
		map.in_level = true
		enter_level()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("world-player") and !level_status == 3:
		player_is_in = true

func _on_area_exited(area: Area2D) -> void:
	player_is_in = false

func enter_level():
	var level = owner
	GameState.actualLevel = level_name
	level._enter_level(path_to_scene, cordenades, music)
