extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
		if Input.is_action_pressed("ui_up"):
			$up.animation="click"
		if !Input.is_action_pressed("ui_up"):
			$up.animation="default"

		if Input.is_action_pressed("ui_left"):
			$left.animation="click"
		if !Input.is_action_pressed("ui_left"):
			$left.animation="default"

		if Input.is_action_pressed("ui_right"):
			$right.animation="click"
		if !Input.is_action_pressed("ui_right"):
			$right.animation="default"

		if Input.is_action_pressed("ui_down"):
			$down.animation="click"
		if !Input.is_action_pressed("ui_down"):
			$down.animation="default"

		if Input.is_action_pressed("enter"):
			$shift.animation="click"
		if !Input.is_action_pressed("enter"):
			$shift.animation="default"

		if Input.is_action_pressed("space"):
			$space.animation="click"
		if !Input.is_action_pressed("space"):
			$space.animation="default"
