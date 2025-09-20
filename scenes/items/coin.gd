extends Coins

enum CoinType {
	one,
	ten,
	onehundred
}

@export var coin_type : CoinType = CoinType.one

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	match coin_type:
		CoinType.one:
			total_coins = 1
		CoinType.ten:
			total_coins = 10
		CoinType.onehundred:
			total_coins = 100


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	can_be_pushed_down = true


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	can_be_pushed_down = false# Replace with function body.
