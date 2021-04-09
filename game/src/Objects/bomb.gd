extends Node2D

onready var sprite = $sprite
var enabled = true


func _ready():
	sprite.play('default')
	
	



func _on_area_entered(area):
	if not self.enabled:
		print('%s enter us, but we are already disabled' % area)
		return
	print('The area %s enter our bomb' % area)
	self.enabled = false
	sprite.play('disabled')
