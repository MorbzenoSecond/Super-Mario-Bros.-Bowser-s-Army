extends Node

var grabbed_coin = {}
var used_block = {}

var actualLevel:String = ""
var specialCoins = {
	"special_coin_1": false,
	"special_coin_2": false,
	"special_coin_3": false,
}

enum Player_mode { SMALL, BIG, FIRE }
var global_gravity = 300.0


func send_final_resoult():
	for coin in specialCoins:
		LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"][coin] = specialCoins[coin]
	grabbed_coin.clear()

func reset_level_data():
	print("hello world")
	specialCoins["special_coin_1"] = false
	specialCoins["special_coin_2"] = false
	specialCoins["special_coin_3"] = false

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("enter"):
		#pass

func had_used_coin(coin_id):
	grabbed_coin[coin_id] = true 

func check_coin_was_used(coin_id):
	return grabbed_coin.has(coin_id)

func had_breaked_block(block_id):
	used_block[block_id] = true

func check_block_was_destroyed(block_id):
	return used_block.has(block_id)
