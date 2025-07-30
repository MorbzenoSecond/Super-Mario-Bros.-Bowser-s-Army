extends Area2D

@export var checkpoint_id: String = ""
@onready var flag = $AnimatedSprite2D
@export var invisible: bool = false
@export var scene_pat: String = ""
@export var new_music: String = ""
func _ready() -> void:
	if invisible:
		flag.visible = false
	if PlayerSpawnPoint.activated_checkpoints.has(checkpoint_id):
		flag.play("Mario")
	else:
		flag.play("Bowser")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and flag.animation == "Bowser":
		flag.play("Mario")
		_stablish_current_music()
		PlayerSpawnPoint.activated_checkpoints[checkpoint_id] = true
		
		var level = get_parent()
		print(level.scene_id)
		var scene_id = level.get("scene_id") if level.has_method("get") else null
		print(scene_id)
		if scene_id:
			PlayerSpawnPoint.set_checkpoint(scene_pat, global_position, checkpoint_id)
		else:
			print("No se pudo guardar el checkpoint porque falta 'scene_id'")
			

func _stablish_current_music():
	var current_level = owner
	current_level._stablish_current_music(new_music)
