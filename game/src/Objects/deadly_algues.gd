extends Node2D

onready var sprite = $sprite



func _ready():
	sprite.play('default')
	
	



func _on_area_entered(area):
	print('The area %s enter our DEADLY ALGUES' % area)
	
