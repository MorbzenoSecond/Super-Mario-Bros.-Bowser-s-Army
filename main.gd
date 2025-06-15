extends Node

@export var game_scene: String
var game_world: Node2D

func _on_game_starting():
	ScreenFader.fade_out()
	
	# Esperar a que el nodo $Title salga del árbol de nodos
	await $Title.tree_exited
	
	# Instanciar y agregar la escena del juego
	var packed_scene = load(game_scene) as PackedScene
	game_world = packed_scene.instantiate() as Node2D
	add_child(game_world)
	
	# Conectar la señal desde el juego
	game_world.end_game.connect(open_main_menu)
	
	ScreenFader.fade_in()

func open_main_menu():
	# Fade out antes de liberar el juego
	ScreenFader.fade_out()
	await ScreenFader.faded_out
	
	game_world.queue_free()
	get_tree().paused = false
	
	# Instanciar el menú principal
	var packed_menu = load("res://scenes/menu/main_menu.tscn") as PackedScene
	var main_menu = packed_menu.instantiate()
	add_child(main_menu)
	
	main_menu.starting.connect(_on_game_starting)
	
	ScreenFader.fade_in()
