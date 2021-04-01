extends Node2D

onready var player = $"Turtle"
onready var teleport_points = $teleport_points/

func _set_player_teleport():
	var parameters = ScenesChanger.get_scene_parameters()
	#if parameters == {}:
	#	assert( false, "ERROR: You must give teleport_point parameter in the teleporter.")
	print('Parameters: %s' % parameters)
	var teleport_point_name = parameters.get('teleport_point', null)
	if teleport_point_name == null:
		print('WARNING: the teleport point was set to default: a')
		teleport_point_name = 'a'
	print('Scene teleport point name: %s' % teleport_point_name)
	var teleport_point = $teleport_points.get_node(teleport_point_name)
	print('Scene teleport point: %s' % teleport_point)
	if teleport_point == null:
		assert(false, 'Teleport point %s is missing' % teleport_point_name)
	print('PLAYER: %s' % player)
	player.global_position = teleport_point.global_position
