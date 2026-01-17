extends StaticBody2D

class_name Block

@onready var block_id = str(global_position)

@onready var collision = $CollisionShape2D
@onready var original_position = position
@onready var original_scale = scale

const PARTICLES_SCENE = preload("res://usefull gd/particles.tscn")
var destruction_texture 


func _ready() -> void:
	$Sprite2D.material = $Sprite2D.material.duplicate()

var tween : Tween
func shine(direction):
	tween = get_tree().create_tween()
	if $Sprite2D != null: 
		if direction == "up":
			tween.tween_property($Sprite2D.material, "shader_parameter/shine_progress", 0.6, 0)
			tween.tween_property($Sprite2D.material, "shader_parameter/shine_progress", 1, 0.35 ).set_ease(Tween.EASE_OUT)
			return
		if direction == "down":
			tween.tween_property($Sprite2D.material, "shader_parameter/shine_progress", 1, 0)
			tween.tween_property($Sprite2D.material, "shader_parameter/shine_progress", 0.6, 0.35 ).set_ease(Tween.EASE_OUT)
			return

func bump(player_mode: Player.PlayerMode, direction):
	var bump_tween = get_tree().create_tween()
	if direction == "up":
		bump_tween.tween_property(self,"position", position +Vector2(0,-10),.12)
		bump_tween.chain().tween_property(self, "position", original_position, .12)
	if direction == "down":
		bump_tween.tween_property(self,"position", position +Vector2(0,10),.12)
		bump_tween.chain().tween_property(self, "position", original_position, .12)
		
	for body in $Top.get_overlapping_bodies():
		if body is Enemy:
			body.die_by_block()
		#if body is Bomb:
			#body.die_by_block()
	grow()
	shine(direction)
	#if player_mode == Player.PlayerMode.FIRE:
	  	#grow()
	GameState.had_breaked_block(block_id)

var spawn_pos := global_position

func destruction():
	var particles = PARTICLES_SCENE.instantiate()
	get_parent().call_deferred("add_child", particles)
	
	particles.global_position = global_position
	
	particles.setup(destruction_texture, global_position)
	queue_free.call_deferred()

func grow():
	var bump_tween = get_tree().create_tween()
	var sprite = $Sprite2D
	if sprite != null:
		sprite.z_index = 2 
	bump_tween.tween_property(self,"scale", original_scale * 1.3, 0.2)
	
	bump_tween.chain().tween_property(self, "scale", original_scale, 0.2)
	
