extends AnimatedSprite

func _ready():
	self.frame = 0  # be sure to reset! because if editor is playing it, it can change the value!
	self.play()

func _on_animation_finished():
	self.queue_free()
