extends Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_down"):
		self.start()
	elif Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_down"):
		self.stop()

