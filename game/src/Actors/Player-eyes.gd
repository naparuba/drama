extends AnimatedSprite


onready var _animation = $"eyes-animation"
onready var _eyes = $eyes

func _ready():
	play_idle()
	self.reset_eyes_position()
	
	
func play_idle():
	self._animation.play("idle")
	
	
func play_walk_right():
	self._animation.play("walk_right")


func reset_eyes_position():
	self.set_eyes_position(0, 0)
	
	
func set_eyes_position(x,y):
	_eyes.position = Vector2(x, y)
	_eyes.material.set_shader_param("offset_x", float(x))
	_eyes.material.set_shader_param("offset_y", float(y))


func step1():
	self.set_eyes_position(2, 0)
	
func step2():
	self.set_eyes_position(4, 0)
	
func step3():
	self.set_eyes_position(6, 0)
	
func step4():
	self.set_eyes_position(8, 0)
