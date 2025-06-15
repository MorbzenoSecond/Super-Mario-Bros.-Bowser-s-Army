extends Node

@onready var level_container = $LevelContainer

func _ready() -> void:
	print(level_container)

func change_level(new_level_path: String):
	# Limpia el nivel anterior
	for child in level_container.get_children():
		child.queue_free()
  
	# Carga e instancia el nuevo nivel
	var new_level = load(new_level_path).instantiate()
	level_container.add_child(new_level)
