extends Node2D

onready var player = $Turtle
onready var background = $background

func _ready():
	print('back ground %s' % get_node("background"))
	var limit_left = background.texture.get_size()
	var background_position = background.position
	# Position: top left part
	
	print('SPRITE LIMITS: %s' % limit_left, background_position)
	
	return
	#$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	#$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	#$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	#$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
