extends RigidBody2D

@export var path_to_scene: String
@export var cordenades: Vector2
@export var path_activate: bool
@export var new_music: String
@onready var marker = $Marker2D
@onready var timer = $Timer
var body
var player_is_in = false
var player: Node2D = null

func _ready() -> void:
	if !path_activate:
		$Area2D.monitorable = false
		$Area2D.monitoring = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in = true
		player = body
	

func _process(delta: float) -> void:
	if player_is_in and Input.is_action_just_pressed("ui_down"):
		timer.start()
		player.global_position.x = marker.global_position.x
		player.enter_tube()

func _on_transition_entered(_body: Node2D, path, cordenades, music):
	call_deferred("emit_signal", "goto_room", load(path) as PackedScene, cordenades as Vector2, music)

func _on_quit_entered(_body: Node2D):
	emit_signal("goto_main")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in = false

func _on_timer_timeout() -> void:
	var current_level = owner
	current_level._on_transition_entered(body, path_to_scene, cordenades, new_music)
