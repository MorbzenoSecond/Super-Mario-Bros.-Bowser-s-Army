extends Node

var data = {
	"levels": {
		"level_1": {
			"LevelStatus": false,
			"path_unlocken": false,
			"LevelCoins": 0,
			"GoldenCoins": {
				"special_coin_1": false,
				"special_coin_2": false,
				"special_coin_3": false
			},
			"GoldenFlagStatus": false
		},
		"level_2": {
			"LevelStatus": false,
			"path_unlocken": true,
			"LevelCoins": 0,
			"GoldenCoins": {
				"special_coin_1": false,
				"special_coin_2": false,
				"special_coin_3": false
			},
			"GoldenFlagStatus": false
		}
	}
}

const SAVE_PATH = "res://hola.json"
# Called when the node enters the scene tree for the first time.
func save():
	var file = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		save()
		await save()
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	if json:
		data = json
	else:
		return
