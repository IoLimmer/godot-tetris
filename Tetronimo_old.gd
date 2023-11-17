extends Node2D


@export var startPos = Game.tetronimoSpawnPoint
var newInput = Vector2(0,0)

var leftMostBlock
var rightMostBlock
var shape

var blockPrefab = preload("res://block.tscn")
var blocks : Array

@export var isFalling : bool = true
var aboutToStopFlag : bool = false
var movementStagger : bool = true

@export var debug : bool = false



var tetShapes = {
	"I": [Vector2(-1,0),Vector2(0,0),Vector2(1,0),Vector2(2,0), "0_red"],
	"O": [Vector2(-1,0),Vector2(0,0),Vector2(-1,1),Vector2(0,1), "1_orange"],
	"T": [Vector2(-1,0),Vector2(0,0),Vector2(1,0),Vector2(0,1), "2_yellow"],
	"L": [Vector2(-1,0),Vector2(0,0),Vector2(0,-1),Vector2(-2,0), "3_green"],
	"J": [Vector2(-1,0),Vector2(0,0),Vector2(0,1),Vector2(-2,0), "4_cyan"],
	"Z": [Vector2(-1,0),Vector2(0,0),Vector2(0,1),Vector2(1,1), "5_blue"],
	"S": [Vector2(0,1),Vector2(0,0),Vector2(1,0),Vector2(-1,1), "6_purple"]
}

# Called when the node enters the scene tree for the first time.
func _ready():
#	tetShapes = testShapes
	shape = get_random(tetShapes)
	self.position = startPos * Game.PIXEL_SIZE
	spawn_blocks(4)


func get_random(dict):
	var a = dict.keys()
	a = a[randi() % a.size()]
	return a


func spawn_blocks(no_of_blocks: int):
	no_of_blocks = min(abs(no_of_blocks),4)
	if no_of_blocks == 0: no_of_blocks = 1
	
	# pick random shape from dictionary
	var newShape = get_random(tetShapes)
	while newShape == shape:
		newShape = get_random(tetShapes)
	shape = newShape
	
	# spawn in four blocks in specific arangement
	var tempBlocks = []
	for i in no_of_blocks:
		tempBlocks.append(blockPrefab.instantiate())
		tempBlocks[i].position = Vector2(tetShapes[shape][i]) * Game.PIXEL_SIZE
		add_child(tempBlocks[i])
	blocks = get_children()
	
	leftMostBlock = blocks[0]
	if no_of_blocks == 1:
		rightMostBlock = blocks[0]
		blocks[0].position = Vector2(0,0)
	else:
		rightMostBlock = blocks[1]
	
	
	for block in blocks:
		block.get_node("Sprite").play(tetShapes[shape][4])
	
	get_left_and_right()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	newInput = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	get_left_and_right()
	
	# if whole tetronimo at left limit and trying to move left, cancel input
	if (leftMostBlock.global_position.x / Game.PIXEL_SIZE) == Game.topLeftCorner.x && newInput.x == -1:
		newInput.x = 0
	elif (leftMostBlock.global_position.x / Game.PIXEL_SIZE) < Game.topLeftCorner.x:
		self.position.x += Game.PIXEL_SIZE
	# if whole tetronimo at right limit and trying to move right, cancel input
	elif (rightMostBlock.global_position.x / Game.PIXEL_SIZE) == Game.bottomRightCorner.x && newInput.x == 1:
		newInput.x = 0
	
	# if part of tet neighbouring other block in other tet ON LEFT
	if (leftMostBlock.global_position.x / Game.PIXEL_SIZE) == Game.topLeftCorner.x && newInput.x == -1:
		newInput.x = 0
	# if part of tet neighbouring other block in other tet ON RIGHT
	elif (rightMostBlock.global_position.x / Game.PIXEL_SIZE) == Game.bottomRightCorner.x && newInput.x == 1:
		newInput.x = 0
	
	if !isFalling:
		newInput = Vector2(0,0)

	if isFalling:      
		newInput = check_left_right_collision(newInput)
		if Input.is_action_just_pressed("ui_up"):
			rotate_tetronimo()
		elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			self.position.x += newInput.x * Game.PIXEL_SIZE
		elif Input.is_action_just_pressed("ui_down"): # if down pressed
			self.position.y += newInput.y * Game.PIXEL_SIZE


func rotate_tetronimo():
	var oldPos = []
	
	var testPos = []
	var leftMost = Vector2(400,400)
	var rightMost = Vector2(0,0)
	
	var direction_to_push : int = 0
	var block_rotation : bool = false
	
	# rotate testPos 90 counterclockwise
	for block in blocks:
		oldPos.append(block.global_position)
		var newPos = (self.position + Vector2(-block.position.y, block.position.x))
		if newPos.x <= leftMost.x:
			leftMost = newPos
		if newPos.x >= rightMost.x:
			rightMost = newPos
		
		testPos.append(newPos)
	
	# handle block rotating off side of level
	if leftMost.x < Game.topLeftCorner.x * Game.PIXEL_SIZE:
		direction_to_push -= leftMost.x - (Game.topLeftCorner.x * Game.PIXEL_SIZE)
		direction_to_push /= 8
	elif rightMost.x > Game.bottomRightCorner.x * Game.PIXEL_SIZE:
		direction_to_push += (Game.bottomRightCorner.x * Game.PIXEL_SIZE) - rightMost.x
		direction_to_push /= 8
	
	print(direction_to_push)
	print()
	
	# handle block rotating into other block
	for new_pos in testPos:
		for old_block in Game.fallenTetronimos:
			if new_pos == old_block.global_position:
				print("SHIT THE BED!!")
				print()
	
	
	for i in range(len(testPos)):
		blocks[i].position = self.position - testPos[i]
		print(blocks[i].global_position)
	
	self.position.x += direction_to_push * Game.PIXEL_SIZE

#	for block in blocks:
#		print(block.position)
#
#		oldPos.append(block.position)
#		var newPos = Vector2(-block.position.y, block.position.x) / Game.PIXEL_SIZE
#		block.position = newPos * Game.PIXEL_SIZE
#
#		print(newPos)
#
#	print()
	
	# check block hasn't rotated into other block

#	for block in blocks:
#		if block.global_position in Game.filledSpots:
#			print("SHIT THE BED!!!")
#			break
	
	# test for new positions
#	var test_positions_L = []
#	var test_positions_R = []
#	if overlap:
#		# push to left 
#		for block in blocks:
#			test_positions_L.append(Vector2(block.global_position.x - Game.PIXEL_SIZE, block.global_position.y))		
#			test_positions_R.append(Vector2(block.global_position.x + Game.PIXEL_SIZE, block.global_position.y))
#		if test_positions_L not in Game.filledSpots:
#			for i in range(len(blocks)):
#				blocks[i].global_position = test_positions_L[i]
#		elif test_positions_R not in Game.filledSpots:
#			for i in range(len(blocks)):
#				blocks[i].global_position = test_positions_R[i]
#		else:
#			for block in blocks:
#				var newPos = Vector2(block.position.y, -block.position.x) / Game.PIXEL_SIZE
#				block.position = newPos * Game.PIXEL_SIZE



func get_left_and_right():
	for block in blocks:
#		block.get_node("Sprite").play("default")
		if block.position.x < leftMostBlock.position.x:
			leftMostBlock = block
		elif block.position.x > rightMostBlock.position.x:
			rightMostBlock = block


func check_left_right_collision(newInput : Vector2):
	for block in blocks:
		if (block.collidingLeft and newInput.x == -1) or (block.collidingRight and newInput.x == 1):
			newInput.x = 0
	return newInput


func check_below_collisions():
	for block in blocks:
		if block.collidingBelow:
			isFalling = false


func block_drop_timer_timeout():
	if isFalling:
		check_below_collisions()
	if isFalling:
		self.position.y += Game.PIXEL_SIZE


func normal_timer_timeout():
	movementStagger = !movementStagger
	if newInput.x != 0 and movementStagger: # if left or right pressed
		self.position.x += newInput.x * Game.PIXEL_SIZE
	if newInput.y > 0: # if down pressed
		check_below_collisions()
		if isFalling:
			self.position.y += newInput.y * Game.PIXEL_SIZE
	
	
func rotation_timeout():
	if newInput.y < 0: # if up pressed
		rotate_tetronimo()
