extends Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		self.start()
	elif Input.is_action_just_released("ui_up"):
		self.stop()


