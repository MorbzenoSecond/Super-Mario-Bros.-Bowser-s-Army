extends Node

var actualLevel:String = ""
var specialCoins = {
	"coin_1" = false,
	"coin_2" = false,
	"coin_3" = false,
}

enum Player_mode { SMALL, BIG, FIRE } 

func send_final_resoult():
	LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"]["coin_1"] = specialCoins["coin_1"]
	LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"]["coin_2"] = specialCoins["coin_2"]
	LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"]["coin_3"] = specialCoins["coin_3"]

func reset_level_data():
	specialCoins["coin_1"] = false
	specialCoins["coin_1"] = false
	specialCoins["coin_1"] = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		print(specialCoins)
