extends Light2D

onready var player = $AnimationPlayer


func _ready():
	print('NEW BLOOD MASK AT %s' % self.global_position)
	player.play("display")
	
	
func finish():
	print('NO MORE BLOOD')
	self.queue_free()
