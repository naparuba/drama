extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character : Sprite = $Character


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	print('Global: %s' % event.global_position)
	print('VIEWPORT %s' % get_viewport())
	print('WINDOWS %s' % OS.window_size)
	print('ON %s' % (event.global_position / OS.window_size * get_viewport().get_position_in_parent()))

	var new_path : = nav_2d.get_simple_path(
		character.global_position,
		# Scales the mouse position from the window's coordinate system to the viewport's.
		event.global_position / OS.window_size * get_viewport().size
	)
	character.path = new_path
	line_2d.points = new_path
