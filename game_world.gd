extends Level

class_name Gameworld
#NOT: Since we are loading this scene as an export in the title, this stuff runs as soon as title.tscn is loaded.
#	In this case, this is when the game starts. 
@onready var music = $Music
signal end_game

@export var start_scene:String
var current_music:String
var current_level:Node2D
var old_level:Node2D

#This runs as soon as an instance of "game.tscn" enters the scene tree, which means whenever you add it with "add_child()"
func _ready():
	var packed_scene = load(start_scene) as PackedScene
	if packed_scene == null:
		push_error("No se pudo cargar la escena: " + start_scene)
		return

	current_level = packed_scene.instantiate()  # <- Cambiado de instance() a instantiate()
	$Levels.add_child(current_level)
	
	current_level.goto_room.connect(_on_goto_room)
	current_level.goto_main.connect(_on_goto_main)

func _on_goto_room(scene:PackedScene, position:Vector2, new_music):
	print("hola")
	$Mario.global_position = position
	#If we instance the new level insted of using change_scene(), we can do our setup in between. 
	#like using a tween to slowly move the camera to the new area.
	#get_tree().paused=true
	#ScreenFader.fade_out()
	#await ScreenFader.faded_out
	var new_level=scene.instantiate()
	$Levels.add_child(new_level)
	print(new_music)
	if !new_music == "": 
		music.stream = load(new_music)
		current_music = new_music
		music.play()
	new_level.goto_room.connect(_on_goto_room)
	new_level.goto_main.connect(_on_goto_main)
	old_level=current_level
	current_level=new_level
	#ScreenFader.fade_in()
	#await ScreenFader.faded_in
	get_tree().paused=false
	print("old level")
	if old_level:
		old_level.queue_free()
func _on_goto_main():
	#get_tree().paused=true
	emit_signal("end_game")
	
func _on_transition_faded_out():
	if old_level:
		old_level.queue_free()
		
		
func respawn_from_checkpoint():
	var scene_name = PlayerSpawnPoint.last_checkpoint_scene
	var position = PlayerSpawnPoint.last_checkpoint_position
	print(position)
	if scene_name == "":
		print("No hay checkpoint guardado.")
		return

	var new_level_scene = load(PlayerSpawnPoint.last_checkpoint_scene)
	print(new_level_scene)
	var new_level = new_level_scene.instantiate()
	
	
	# Elimina nivel anterior
	if current_level:
		current_level.queue_free()
	current_level = new_level
	$Levels.add_child(current_level)
	new_level.goto_room.connect(_on_goto_room)
	new_level.goto_main.connect(_on_goto_main)
	music.stream = load(current_music)
	music.play()

	# Reposicionar al jugador
	$Mario.respawn()
	$Mario.global_position = position
