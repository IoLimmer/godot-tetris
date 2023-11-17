extends Node2D


var tetronimoPrefab = preload("res://tetronimo.tscn")
var spawnPos = Game.tetronimoSpawnPoint

var currentTet



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.spawnNewTet:
		spawnNewTet()
	if !currentTet.isFalling:
		Game.fallenTetronimos.append(currentTet)
		for block in currentTet.blocks:
			Game.filledSpots.append(block.global_position)
#		print(Game.filledSpots)
		Game.spawnNewTet = true


func spawnNewTet():
#	print("----------------------")
	var tetronimoTemp = tetronimoPrefab.instantiate()
	add_child(tetronimoTemp)
	currentTet = tetronimoTemp
	Game.spawnNewTet = false


func _on_block_drop_timer_timeout():
#	print()
	currentTet.block_drop_timer_timeout()


func _on_normal_timer_timeout():
	currentTet.normal_timer_timeout()


func _on_rotation_timer_timeout():
	currentTet.rotation_timeout()
