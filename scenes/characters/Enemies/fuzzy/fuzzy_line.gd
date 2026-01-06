extends Node2D

var last_point : Vector2 
var waypoints := []
@export var speed : int = 100
@export var fuzzies : int = 1
@export var incremental_value : float = 0.5
var incremental : float
const SPRITE = preload("res://usefull gd/point_node.tscn")
const FUZZY = preload("res://scenes/characters/Enemies/fuzzy/fuzzy.tscn")

#func _process(delta: float) -> void:
	#global_position.x += 100 * delta

func _ready() -> void:
	
	z_index = 1000
	get_markers_positions()
	for i in range(fuzzies):
		var fuzzy = FUZZY.instantiate()
		$fuzzys.add_child(fuzzy)
	# Inicializar fuzzies DESPUÉS de tener los waypoints
	for fuzzy in $fuzzys.get_children():
		incremental += incremental_value
		
		# .duplicate() es CLAVE para que cada uno tenga su lógica independiente
		fuzzy.get_new_point(waypoints.duplicate(), 0, speed, last_point, incremental)

func get_markers_positions():
	for i in $points.get_children():
		if i is Marker2D:
			var break_point = SPRITE.instantiate()
			waypoints.append(i.global_position)
			$points.add_child(break_point)
			break_point.global_position = i.global_position
			
	last_point = waypoints.back()
	create_paths()

func create_paths():
	$Line2D.clear_points()
	#for i in waypoints:
		#line2d.add_point(line2d.to_local(i))
	for i in range(waypoints.size() - 1):
		create_lines(waypoints[i], waypoints[i+1])
	#create_lines(waypoints.front(), waypoints.back())

func create_lines(p_inicio, p_final):
	var line = Line2D.new()
	
	# 1. Configuración Visual (SIN TOCAR SCALE)
	line.texture = load("res://assets/sprites/particles_sprites/Line.png")
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	# En lugar de scale 0.3, ajustamos el ancho directamente
	line.width = 33 # Si antes era 100 con escala 0.33, ahora es 33
	
	# 2. El truco de la posición
	# Añadimos la línea al padre ANTES de calcular los puntos
	$lines.add_child(line)
	
	# 3. Ahora que la línea está en el árbol, to_local funciona correctamente
	line.add_point(line.to_local(p_inicio))
	line.add_point(line.to_local(p_final))
