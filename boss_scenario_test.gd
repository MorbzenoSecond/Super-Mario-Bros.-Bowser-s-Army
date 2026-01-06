extends Level

#@onready var beat_timer = $BeatTimer
#@onready var off_tile = $"Node/off-block"
#@onready var on_tile = $"Node/on-block"
#@onready var on_off_blocks = $blocks/on_off_blocks.get_children()
#var path_to_scene
#const SPRITE = preload("res://usefull gd/point_node.tscn")
#
#func _ready() -> void:
	##for i in on_off_blocks:
		##i.state_changed.connect(_on_block_state_changed)
	##beat_timer.start() # Inicia el timer
#
#func _on_beat_timer_timeout() -> void:
	#for i in on_off_blocks:
		#i.state_changed.connect(_on_block_state_changed)
#
#func _on_block_state_changed(new_state: bool, block_id) -> void:
	### Este método es llamado automáticamente cuando On_off_block cambia
	#for color_block in get_tree().get_nodes_in_group("color-blocks"):
		#color_block._on_state_changed(new_state, block_id)
