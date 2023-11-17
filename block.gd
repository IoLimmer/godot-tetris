extends Area2D


@onready var isFalling = self.get_parent().isFalling
@onready var debug = self.get_parent().debug

#@onready var BLOCKS = get_node("../../BLOCKS")
#@onready var baseOfLevel = get_node("../../../Base of Level")

var collidingBelow = false
var collidingLeft = false
var collidingRight = false


# NOTE FOR FUTURE REFERENCE
# this script breaks if the two collision boxes overlap
# not on the same block but on adjacent blocks
# i.e. if block a is above b, and a's detect below box enters b's detect sides box
# it shits itself
# believe me
# - io, 11/11
# happy rememberance i guess??????

# further note. ignore this


#func _process(delta):
#	if self.global_position.y / Game.PIXEL_SIZE > Game.bottomRightCorner.y - 1:
#		self.get_parent().isFalling = false
#	print(collidingBelow)

func _process(delta):
	isFalling = self.get_parent().isFalling
		
	var belowHits = 0
	var leftHits = 0
	var rightHits = 0
		
	for tetronimo in Game.fallenTetronimos:
		for block in tetronimo.blocks:
			# if a block from list below current block, stop.
			if block.global_position == Vector2(self.global_position.x, self.global_position.y + Game.PIXEL_SIZE):
				belowHits += 1
			# if left of current block
			if block.global_position == Vector2(self.global_position.x - Game.PIXEL_SIZE, self.global_position.y):
				leftHits += 1
			# if right of current block
			if block.global_position == Vector2(self.global_position.x + Game.PIXEL_SIZE, self.global_position.y):
				rightHits += 1
				
	if belowHits > 0:
		collidingBelow = true
	else: 
		collidingBelow = false
	if leftHits > 0:
		collidingLeft = true
	else: 
		collidingLeft = false
	if rightHits > 0:
		collidingRight = true
	else: 
		collidingRight = false
		
	if self.global_position.y / Game.PIXEL_SIZE > Game.bottomRightCorner.y-1:
		collidingBelow = true
	
	if Input.is_action_just_pressed("ui_text_backspace") and isFalling:
		print(self.name)
		print(self.global_position)
		print()
		print("Below: " + str(collidingBelow))
		print("Left:  " + str(collidingLeft))
		print("Right: " + str(collidingRight))
		print()

#func _on_detect_sides_area_entered(area):
#	if self.get_parent() != area.find_parent("Tetronimo") and isFalling:
#		if area.position < self.position:
#			collidingLeft = true
#		else:
#			collidingRight = true
#
#
#func _on_detect_sides_area_exited(area):
#	if self.get_parent() != area.find_parent("Tetronimo") and isFalling:
#		if area.position < self.position:
#			collidingLeft = false
#		else:
#			collidingRight = false
#

#
#func _on_detect_below_area_entered(area):
#	if self.get_parent() != area.get_parent() and isFalling:
#		collidingBelow = true
#
#func _on_detect_below_area_exited(area):
#	if self.get_parent() != area.get_parent() and isFalling:
#		collidingBelow = false
