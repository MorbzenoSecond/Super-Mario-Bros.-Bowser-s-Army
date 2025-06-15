extends Node
class_name MainGame

@onready var level_root = $LevelRoot
@export var initial_level = ""

func _ready():
	change_level(initial_level)

func change_level(new_level_path: String) -> void:
	if not level_root:
		push_error("❌ LevelRoot no encontrado.")
		return

	# Elimina el contenido anterior
	for child in level_root.get_children():
		child.queue_free()

	# Carga e instancia el nuevo nivel
	var new_level = load(new_level_path)
	if new_level:
		level_root.add_child(new_level.instantiate())
		print("✅ Nivel cargado:", new_level_path)
	else:
		push_error("❌ No se pudo cargar el nivel: " + new_level_path)
