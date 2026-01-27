extends RigidBody2D
var last_position : Vector2
@onready var collision = $CollisionShape2D
var sprite

func disarm(direction):
	$CollisionShape2D.call_deferred("set_disabled", false)
	linear_velocity.y = randf_range(-140,-280)
	if direction == 1:
		linear_velocity.x = randf_range(40,80)
	elif direction == -1:
		linear_velocity.x = randf_range(-40,-80)
	else:
		linear_velocity.x = randf_range(-40,40)
	gravity_scale = 0.75

func prepare_rearm():
	gravity_scale = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0

func rearm(position):
	var mat = get_sprite()
	if mat:
		mat.set_shader_parameter("active", true)
	var tween = create_tween()
	tween.parallel().tween_property(self, "rotation", 0, 2.5).set_trans(Tween.TRANS_SPRING)
	tween.parallel().tween_property(self, "position", position, 2.5).set_trans(Tween.TRANS_SPRING)

func rearmed():
	var mat = get_sprite()
	if mat:
		mat.set_shader_parameter("active", false)

func get_sprite():
	for node in get_children():
		if node is AnimatedSprite2D:
			var sprite = node
			var mat := sprite.material as ShaderMaterial
			return mat
	return null
