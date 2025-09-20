extends Level

@onready var beat_timer = $BeatTimer
@onready var on_off_block = $"bloques/On-off block"

var path_to_scene

func _ready() -> void:
	on_off_block.state_changed.connect(_on_block_state_changed)
	beat_timer.start() # Inicia el timer
	#super.control_music_label("Super Mario 3D World", "Beep Block Skyway")
#
func _on_beat_timer_timeout() -> void:
	on_off_block.toggle_state() # Cambia su estado, emitirá la señal
#
func _on_block_state_changed(new_state: bool) -> void:
	## Este método es llamado automáticamente cuando On_off_block cambia
	for color_block in get_tree().get_nodes_in_group("color-blocks"):
		color_block._on_state_changed(new_state)
