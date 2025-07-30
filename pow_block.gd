extends  Block

class_name pow_block

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
var is_empty = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bump(player_mode: Player.PlayerMode, direction):
	if is_empty:
		return
	super.bump(player_mode, direction)
	make_empty()

func make_empty():
	get_tree().call_group("Enemies", "all_die")
	get_tree().call_group("coins", "_fall_by_force")
	self.animation.play("less_size")
	$CollisionShape2D. disabled = false
	call_deferred("set_process", false)
	is_empty = true
	sprite.play("empty")
