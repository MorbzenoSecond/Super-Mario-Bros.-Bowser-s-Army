extends Level

@onready var on_off_block = $"Blocks/On-off block"
@onready var off_tile = $"Node/off-block"
@onready var on_tile = $"Node/on-block"
var path_to_scene

func _ready() -> void:
	on_off_block.state_changed.connect(_on_block_state_changed)

func _on_block_state_changed(new_state: bool) -> void:
	## Este método es llamado automáticamente cuando On_off_block cambia
	for color_block in get_tree().get_nodes_in_group("color-blocks"):
		color_block._on_state_changed(new_state)
