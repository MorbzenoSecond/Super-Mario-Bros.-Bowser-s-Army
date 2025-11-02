extends Coins

enum CoinType {
	one,
	two,
	tree
}

@export var coin_type : CoinType = CoinType.one

func _ready() -> void:
	is_special_coin = true
	$AnimatedSprite2D.play("default")
	match coin_type:
		CoinType.one:
			special_coin_number = "coin_1"
		CoinType.two:
			special_coin_number = "coin_2"
		CoinType.tree:
			special_coin_number = "coin_3"

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	can_be_pushed_down = true

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	can_be_pushed_down = false# Replace with function body.
