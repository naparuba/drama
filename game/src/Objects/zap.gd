extends Node2D

onready var sprites = $sprites
onready var timer_switch = $timer_switch



func _on_timer_switch_timeout():
	print('SWITCH')
	for child in sprites.get_children():
		child.flip_v = !child.flip_v
		#if child.flip_h:
		#	child.position.x += 8
		#else:
		#	child.position.x -= 8
	timer_switch.start()
	
