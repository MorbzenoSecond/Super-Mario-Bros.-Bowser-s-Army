extends CharacterBody2D

var total_coins := 0
enum CoinType {
	one,
	ten,
	onehundred
}
var used : bool = false
@onready var area = $Area2D as Area2D
@export var coin_type : CoinType = CoinType.one
@onready var coin_noice = $AudioStreamPlayer
func _ready() -> void:
	match coin_type:
		CoinType.one:
			total_coins = 1
		CoinType.ten:
			total_coins = 10
		CoinType.onehundred:
			total_coins = 100

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !used:
		var entity = area.get_parent()
		if entity is not Player:
			return
		coin_noice.play()
		used = true
		var Level = get_tree().current_scene
		Level.control_coins(total_coins)
		hide()
		await coin_noice.finished

		queue_free()
	else:
		return
