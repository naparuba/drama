extends "res://src/Levels/Level.gd"

#onready var player = $Turtle
onready var background = $background



func _ready():
	print('back ground %s' % get_node("background"))
	var size = background.texture.get_size()
	var background_position = background.position
	# Position: top left part
	
	self._set_player_teleport()
	
	print('SPRITE LIMITS: %s' % size, background_position)
	player.set_camera_limit(background_position, size)
	
	return
	
