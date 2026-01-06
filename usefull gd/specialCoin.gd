extends Coins

enum CoinType {
	one,
	two,
	tree
}

@export var coin_type : CoinType = CoinType.one

func _ready() -> void:
	super._ready()
	is_special_coin = true
	$AnimatedSprite2D.play("default")
	match coin_type:
		CoinType.one:
			special_coin_number = "special_coin_1"
		CoinType.two:
			special_coin_number = "special_coin_2"
		CoinType.tree:
			special_coin_number = "special_coin_3"
	if LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"][special_coin_number]:
		taken_coin(special_coin_number)

func taken_coin(special_coin_number):
	LevelDataManager.data["levels"][GameState.actualLevel]["GoldenCoins"][special_coin_number] = true
	GameState.specialCoins[special_coin_number] = true
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	can_be_pushed_down = true

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	can_be_pushed_down = false
