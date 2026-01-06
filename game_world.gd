extends Level

class_name Gameworld
#NOT: Since we are loading this scene as an export in the title, this stuff runs as soon as title.tscn is loaded.
#	In this case, this is when the game starts. 
@onready var music = $Music
@onready var effectmusic = $EffectMusic
signal end_game
@export var start_scene:String
var current_music:String
var respawn_music:String
var current_level:Node2D
var old_level:Node2D
var star = false

signal reloadMap()

#This runs as soon as an instance of "game.tscn" enters the scene tree, which means whenever you add it with "add_child()"
func _ready():
	LevelDataManager.load_data()
	pass
	#var packed_scene = load(start_scene) as PackedScene
	#if packed_scene == null:
		#push_error("No se pudo cargar la escena: " + start_scene)
		#return
#
	#current_level = packed_scene.instantiate()  # <- Cambiado de instance() a instantiate()
	#$Levels.add_child(current_level)
	#
	#current_level.goto_room.connect(_on_goto_room)
	#current_level.goto_main.connect(_on_goto_main)
	#current_level.new_music.connect(_respawn_music)
	#current_level.map_world.connect(_in_world_map)
	#current_level.flag_reached.connect(_flag_reached)

func _flag_reached():
	music.stream = load("res://assets/music/Super Mario World Music_ Level Complete.mp3")
	current_music = "res://assets/music/Super Mario World Music_ Level Complete.mp3"
	music.play()
	$UI.fade_level()

func _on_goto_room(scene:PackedScene, new_music, pipe: bool, conection):

	_in_a_level()
	_new_level(scene,new_music)
	await get_tree().process_frame
	
	if pipe:
		$Mario.global_position = _get_pipes_on_level(conection)
	else:
		$Mario.global_position = PlayerSpawnPoint.start_point

func _get_pipes_on_level(pipe_conection):
	var pipes = current_level.get_tree().get_nodes_in_group("Pipes")
	for pipe in pipes:
		if pipe.conection == pipe_conection:
			print("Pipe encontrada en:", pipe.global_position)
			return pipe.global_position + Vector2(0, -50)
	
	# Si no se encontró ninguna pipe con esa conexión
	print("No se encontró una pipe con conexión:", pipe_conection)
	return null

func _new_level(scene, new_music):
		#get_tree().paused=true
	#ScreenFader.fade_out()
	#await ScreenFader.faded_out
	var new_level = scene.instantiate()
	print("la nueva musica es", new_music)
	$Levels.add_child(new_level)
	if !new_music == "": 
		music.stream = load(new_music)
		current_music = new_music
		music.play()
	new_level.goto_room.connect(_on_goto_room)
	new_level.goto_main.connect(_on_goto_main)
	new_level.new_music.connect(_respawn_music)
	new_level.map_world.connect(_in_world_map)
	new_level.flag_reached.connect(_flag_reached)

	old_level=current_level
	current_level=new_level
	#ScreenFader.fade_in()
	#await ScreenFader.faded_in
	get_tree().paused=false
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
	var new_mario_position = PlayerSpawnPoint.last_checkpoint_position
	if scene_name == "":
		print("No hay checkpoint guardado.")
		return
	current_music = PlayerSpawnPoint.last_checkpoint_music
	var new_level_scene = load(PlayerSpawnPoint.last_checkpoint_scene)
	var new_level = new_level_scene.instantiate()
	
	# Elimina nivel anterior
	if current_level:
		current_level.queue_free()
	current_level = new_level
	$Levels.add_child(current_level)
	new_level.goto_room.connect(_on_goto_room)
	new_level.goto_main.connect(_on_goto_main)
	new_level.new_music.connect(_respawn_music)
	new_level.map_world.connect(_in_world_map)
	new_level.flag_reached.connect(_flag_reached)
	music.stream = load(current_music)
	music.play()

	# Reposicionar al jugador
	$Mario.respawn()
	$Mario.global_position = new_mario_position

func _respawn_music(hi):
	pass

func mario_super_star():
	if effectmusic.stream == load("res://assets/music/Remix 10 Theme - Super Mario Run (Mobile)  Music.mp3"):
		return
	effectmusic.stream = load("res://assets/music/Remix 10 Theme - Super Mario Run (Mobile)  Music.mp3")
	effectmusic.play()
	star = true

func _process(_delta: float) -> void:
	#print(get_global_mouse_position())
	#get_viewport().warp_mouse(get_viewport().get_mouse_position() - Vector2(0,2) * _delta)
	if star:
		if !music.volume_db == -80:
			effectmusic.volume_db += 1
			music.volume_db -= 1
	else:
		if !music.volume_db == 00:
			effectmusic.volume_db -= 1
			music.volume_db += 1

func mario_super_star_off():
	star = false

func mario_die():
	star = false
	music.stop()
	effectmusic.stop()

func _in_a_level():
	$Mario/PlayerCam.enabled = true
	$Mario.show()
	$WorldMap.hide()
	$WorldPlayer.hide()
	$WorldPlayer.call_deferred("set_process", false)

func _in_world_map():
	if is_instance_valid(current_level):
		current_level.queue_free()
	LevelDataManager.load_data()
	print("level finished")
	$Mario/PlayerCam.enabled = false
	await get_tree().process_frame
	connect_level_signals()
	await get_tree().process_frame
	emit_signal("reloadMap")
	$Mario.hide()
	$WorldPlayer.show()
	$WorldMap.in_level = false
	$Music.stream = load("res://music/Airship Theme - Super Mario Bros. Wonder OST.mp3")
	$Music.play()
	$WorldMap.show()
	$WorldPlayer.call_deferred("set_process", true)

func connect_level_signals():
	var levels = get_tree().get_nodes_in_group("mapLevel")
	for level in levels:
		level._on_reloadMap()
		if not level.is_connected("reloadMap", Callable(self, "_on_reloadMap")):
			level.connect("reloadMap", Callable(self, "_on_reloadMap"))
