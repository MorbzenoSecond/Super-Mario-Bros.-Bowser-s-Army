extends Level

@export var max_sections := 3

@onready var tilemap: TileMapLayer = $repetible_sections/seccion_repetible
@onready var container := $repetible_sections

var section_width: float

var active_sections: Array[Node2D] = []

var posible_sections = [preload("res://escenary_test/seccion_repetible.tscn"),preload("res://escenary_test/seccion_repetible_2.tscn")]

func _ready() -> void:
	calculate_section_width()

	spawn_front()
	spawn_back()
	spawn_front()
	$repetible_sections/seccion_repetible.queue_free()

func calculate_section_width() -> void:
	var used = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	section_width = used.size.x * tile_size.x * 3

func spawn_front() -> void:
	if active_sections.is_empty():
		var section = posible_sections.pick_random().instantiate()
		container.add_child(section)
		active_sections.append(section)
		update_triggers()
		return

	var last_section = active_sections.back()
	var last_front = last_section.get_node("Front")

	var section = posible_sections.pick_random().instantiate()
	container.add_child(section)

	var new_back = section.get_node("Back")
	section.global_position += last_front.global_position - new_back.global_position

	active_sections.append(section)

	cleanup_back()
	update_triggers()


func spawn_back() -> void:
	if active_sections.is_empty():
		var section = posible_sections.pick_random().instantiate()
		container.add_child(section)
		active_sections.append(section)
		update_triggers()
		return

	var first_section = active_sections.front()
	var first_back = first_section.get_node("Back")

	var section = posible_sections.pick_random().instantiate()
	container.add_child(section)

	var new_front = section.get_node("Front")
	section.global_position += first_back.global_position - new_front.global_position

	active_sections.insert(0, section)

	cleanup_front()
	update_triggers()

func cleanup_back() -> void:
	while active_sections.size() > max_sections:
		var old = active_sections.pop_front()
		old.call_deferred("queue_free")

func cleanup_front() -> void:
	while active_sections.size() > max_sections:
		var old = active_sections.pop_back()
		old.call_deferred("queue_free")

func update_triggers() -> void:
	if active_sections.is_empty():
		return

	for section in active_sections:
		section.disable_all()

	active_sections.front().enable_back(true)
	active_sections.back().enable_front(true)
