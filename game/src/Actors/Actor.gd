extends KinematicBody2D
class_name Actor


const FLOOR_NORMAL: = Vector2.UP


export var GRAVITY: = 3500.0

var _current_velocity: = Vector2.ZERO


var _current_gravity = GRAVITY

var TOUCH_NO_WALL = 0
var TOUCH_LEFT_WALL = 1
var TOUCH_RIGHT_WALL = 2


func _init():
	print('INIT: Actor %s' % self.name)

func _apply_gravity(delta:float) -> void:
	self._current_velocity.y += self._current_gravity * delta
	# In all cases, reset the gravity value to the original
	self._current_gravity = GRAVITY
	

# The actor class compute the GRAVITY fall
func _physics_process(delta: float) -> void:
	self._apply_gravity(delta)



func get_which_wall_collided():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.normal.x > 0:
			return TOUCH_LEFT_WALL
		elif collision.normal.x < 0:
			return TOUCH_RIGHT_WALL
	return TOUCH_NO_WALL
