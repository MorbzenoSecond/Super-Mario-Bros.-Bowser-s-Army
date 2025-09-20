extends PokeyBodyPart

@export_range(0, 15, 0) var balls_number = 2
const balls = preload("res://scenes/characters/Enemies/Pokey/PokeyBody.tscn")

func _ready() -> void:
	for i in range(balls_number):
		var ball = balls.instantiate()
		var body = get_node("Balls")
		
		body.add_child(ball)
		ball.velocity = Vector2.ZERO
		ball.global_position = global_position + Vector2(0, 60 * (i + 1))
