extends AnimatedSprite


onready var _animation = $"eyes-animation"
onready var _eyes = $eyes

func _ready():
	play_idle()
	self.reset_eyes_position()
	
	
func play_idle():
	self._animation.play("idle_right")
	
	
func play_idle_right():
	self._animation.play("idle_right")
	
func play_idle_left():
	self._animation.play("idle_left")
	
func play_walk_right():
	self._animation.play("walk_right")


func play_walk_left():
	self._animation.play("walk_left")

func reset_eyes_position():
	self.set_eyes_position(0, 0)
	
	
func set_eyes_position(x,y):
	_eyes.position = Vector2(x, y)
	_eyes.material.set_shader_param("offset_x", float(x))
	_eyes.material.set_shader_param("offset_y", float(y))


# Look at the distant point (with a difference_vector)
func set_eyes_from_cartesian_vector(diff_vector):
	diff_vector = diff_vector.normalized() * 10
	# DEBUG print('Move eyes to', vector.x, ' / ', vector.y)
	self.set_eyes_position(diff_vector.x, diff_vector.y)
	
