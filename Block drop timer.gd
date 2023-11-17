extends Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_down"):
		self.paused = true
	else:
		self.paused = false
