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
	current_level.new_music.connect(_respawn_music)
	current_level.map_world.connect(_in_world_map)
	current_level.flag_reached.connect(_flag_reached)

func _flag_reached():
	music.stream = load("res://music/Super Mario World Music_ Level Complete.mp3")
	current_music = "res://music/Super Mario World Music_ Level Complete.mp3"
	music.play()
	$UI.fade_level()

func _on_goto_room(scene:PackedScene, position:Vector2, new_music):
	_in_a_level()
	$Mario.global_position = position
	#If we instance the new level insted of using change_scene(), we can do our setup in between. 
	#like using a tween to slowly move the camera to the new area.
	#get_tree().paused=true
	#ScreenFader.fade_out()
	#await ScreenFader.faded_out
	var new_level=scene.instantiate()
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

func _respawn_music(music):
	respawn_music = music
		
func respawn_from_checkpoint():
	var scene_name = PlayerSpawnPoint.last_checkpoint_scene
	var position = PlayerSpawnPoint.last_checkpoint_position
	if scene_name == "":
		print("No hay checkpoint guardado.")
		return
	current_music = respawn_music
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
	new_level.new_music.connect(_respawn_music)
	new_level.map_world.connect(_in_world_map)
	new_level.flag_reached.connect(_flag_reached)
	music.stream = load(current_music)
	music.play()

	# Reposicionar al jugador
	$Mario.respawn()
	$Mario.global_position = position

func mario_super_star():
	if effectmusic.stream == load("res://music/Remix 10 Theme - Super Mario Run (Mobile)  Music.mp3"):
		return
	effectmusic.stream = load("res://music/Remix 10 Theme - Super Mario Run (Mobile)  Music.mp3")
	effectmusic.play()
	star = true

func _process(delta: float) -> void:
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

	$Mario/PlayerCam.enabled = false
	$Mario.hide()
	$WorldPlayer.show()
	$WorldMap.in_level = false
	$Music.stream = load("res://music/Airship Theme - Super Mario Bros. Wonder OST.mp3")
	$Music.play()
	$WorldMap.show()
	$WorldPlayer.call_deferred("set_process", true)
