extends Area2D

@export var checkpoint_id: String = ""
@onready var flag = $AnimatedSprite2D
@onready var base = $Sprite2D
@export var start_point: bool = false
var scene_pat
var level_music = ""
func _ready() -> void:
	scene_pat = owner.get_scene_file_path()
	print(scene_pat)
	print(PlayerSpawnPoint.activated_checkpoints)
	if PlayerSpawnPoint.activated_checkpoints.has(checkpoint_id):
		flag.play("Mario")
		return
	if start_point:
		PlayerSpawnPoint.start_point_selector(global_position)
		base.visible = false
		flag.visible = false

	else:
		flag.play("Bowser")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and flag.animation == "Bowser":
		flag.play("Mario")
		PlayerSpawnPoint.activated_checkpoints[checkpoint_id] = true
		
		var level = get_parent()
		level_music = get_tree().get_nodes_in_group("music")[0].stream
		if level_music == null:
			level_music = ""
		var scene_id = level.get("scene_id") if level.has_method("get") else null
		print(scene_id)
		if scene_id:
			PlayerSpawnPoint.set_checkpoint(scene_pat, global_position, level_music.resource_path )
		else:
			print("No se pudo guardar el checkpoint porque falta 'scene_id'")
			

func _stablish_current_music():
	var current_level = owner
	current_level._stablish_current_music(level_music.resource_path)
