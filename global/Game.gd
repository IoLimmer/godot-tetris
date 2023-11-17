extends Node


const PIXEL_SIZE = 8
var tetronimoSpawnPoint = Vector2(12,2)

var topLeftCorner = Vector2(7,2)
var bottomRightCorner = Vector2(16,18)

var fallenTetronimos : Array = []
var filledSpots : Array = []
var spawnNewTet : bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if Input.is_action_just_pressed("ui_text_backspace"):
		for tetronimo in fallenTetronimos:
			for block in tetronimo.blocks:
				print(block.global_position)
		print()
