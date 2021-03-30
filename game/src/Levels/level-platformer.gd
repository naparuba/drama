extends Node2D


onready var limit_right = $limits/right.position.x
onready var limit_left = $limits/left.position.x
onready var limit_top = $limits/top.position.y
onready var limit_bottom = $limits/bottom.position.y
onready var player_camera = $"Player-platformer/Camera2D"

onready var player = $"Player-platformer"
onready var teleport_points = $teleport_points/a


func _ready():
	
	var parameters = ScenesChanger.get_scene_parameters()
	if parameters == {}:
		assert( false, "ERROR: You must give teleport_point parameter in the teleporter.")
	var teleport_point_name = parameters['teleport_point']
	print('Scene teleport point name: %s' % teleport_point_name)
	var teleport_point = $teleport_points.get_node(teleport_point_name)
	print('Scene teleport point: %s' % teleport_point)
	if teleport_point == null:
		assert(false, 'Teleport point %s is missing' % teleport_point_name)
	player.global_position = teleport_point.global_position
	
	# On init, set camera limits
	player_camera.limit_left = limit_left
	player_camera.limit_top = limit_top
	player_camera.limit_right = limit_right
	player_camera.limit_bottom = limit_bottom
	print('Player camara limits sets to ',player_camera.limit_left,player_camera.limit_right,player_camera.limit_top,player_camera.limit_bottom)
