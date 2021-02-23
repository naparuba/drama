extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character =  $Player


onready var nav_poly : NavigationPolygonInstance = $Navigation2D/NavigationPolygonInstance
onready var collision_box = $Navigation2D/collision_box


func _ready():
	return
	
	
	

func _unhandled_input(event: InputEvent) -> void:
	#print('Input: %s' % event)
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_RIGHT or not event.pressed:
		return
	print('PARENT %s' % event)
	return
	
