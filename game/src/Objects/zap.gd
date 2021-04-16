extends Node2D

onready var sprites = $sprites
onready var timer_switch = $timer_switch



func _on_timer_switch_timeout():
	#print('SWITCH')
	for child in sprites.get_children():
		child.flip_v = !child.flip_v
		child.flip_h = !child.flip_h
		if child.flip_h and child.flip_v:
			child.position.x += 8
		if !child.flip_h and !child.flip_v:
			child.position.x -= 8
	timer_switch.start()
	
