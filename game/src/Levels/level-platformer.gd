extends Node2D


onready var limit_right = $limits/right.position.x
onready var limit_left = $limits/left.position.x
onready var limit_top = $limits/top.position.y
onready var limit_bottom = $limits/bottom.position.y
onready var player_camera = $"Player-platformer/Camera2D"



func _ready():
	# On init, set camera limits
	player_camera.limit_left = limit_left
	player_camera.limit_top = limit_top
	player_camera.limit_right = limit_right
	player_camera.limit_bottom = limit_bottom
	print('Player camara limits sets to ',player_camera.limit_left,player_camera.limit_right,player_camera.limit_top,player_camera.limit_bottom)
