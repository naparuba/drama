extends Node2D

onready var sprites = $sprites
onready var timer_switch = $timer_switch

var enabled = true

var body = null
var body_inside = false

func enable():
	self.enabled = true
	if self.body_inside:
		self.body.hurt(1)
		print('ZAP: Reenabling on user, no luck ^^')
		
	
func disable():
	self.enabled = false


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
	


func _on_area_body_entered(body):
	if not body.is_in_group('player'):
		return
	self.body_inside = true
	self.body = body
	
	if not self.enabled:
		print('ZAP IS DISABLED')
		return
	
	print('ZAPPER: body: %s' % body)
	body.hurt(1)


func _on_area_body_exited(body):
	if not body.is_in_group('player'):
		return
	self.body_inside = false
	self.body = null
