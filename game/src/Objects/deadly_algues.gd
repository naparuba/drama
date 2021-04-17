extends Node2D

onready var sprite = $sprite



func _ready():
	sprite.play('default')
	
	



func _on_area_entered(area):
	print('The area %s enter our DEADLY ALGUES' % area)
	


func _on_Area2D_body_entered(body):
	if not body.is_in_group('player'):
		return
	print('DEADLY: %s enter us' % body)
	body.hurt(8)
