extends "res://src/Actors/Player_shoot.gd"


# Actor
# user-action
# detect current position / orientation
# apply shoot
# apply movement
# apply display

class_name PlayerWater, "res://assets/player/turtles/water/player.png"


export var speed: = Vector2(60.0, 200.0)

onready var camera_shake = $Camera2D/ScreenShake


## Body animation
onready var sprite = $sprite


export var FRICTION = 0.2  # force against stop
export var ACCELERATION = 0.2  #force against start, 0.2 is quite fast start

var _current_move_inhibition = 0.0
var _is_move_inhibition = false

### Aiming / Moving
var _move_right_strength = 0.0
var _move_left_strength = 0.0
var _move_up_strength = 0.0
var _move_down_strength = 0.0
var _aim_vector = Vector2(1, 0)  # what the player is asking to aim
var _last_looking_direction = 1  # looking at right

var _current_wall = TOUCH_NO_WALL


func _init():
	print('INIT: Player: %s' % self.name)
	

func _ready():
	print('PlayerWater::_ready')
	sprite.play('idle')



func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	if not body.is_dead():
		self.die()


func _is_jumping() -> bool:
	return self._current_velocity.y < 0.0


func _is_jump_interrupted():
	return self._is_jumping() and Input.is_action_just_released("jump") 


func _get_snap_to_floor_vector(direction) -> Vector2:
	return Vector2.ZERO


	
	

############# Moving / Inputs
func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		return


	

func _physics_process(delta: float) -> void:
	self._update_moving(delta)
	var direction: = self._get_direction()

	#### If dashing: do not look at direction, we are forcing the dash
	if false:
		pass
	else:  # Normal moving
		# Apply X speed
		if direction.x != 0:
			if not self._is_move_inhibition:  # Maybe the X is blocked by a shoot and cannot go against it
				var _wished_speed = speed.x * direction.x
				self._current_velocity.x = lerp(self._current_velocity.x, _wished_speed, ACCELERATION)
			else:
				print('NO X MOVE, block to %s' % self._current_velocity.x)
		else:  # do not stop immediatly
			var _wished_speed = 0  # want to stop
			self._current_velocity.x = lerp(self._current_velocity.x, _wished_speed, FRICTION)
		
		#self._current_velocity.y = speed.y * direction.y
		# Apply Y speed if any
		if direction.y != 0.0:
			self._current_velocity.y = speed.y * direction.y
		if self._is_jump_interrupted():
			if abs(self._current_velocity.y) > abs(speed.y):  # if we did super jump, do not interupt
				print('JUMP NOT INTERUPTED: was super jump')
				pass
			else:  # we are in a classic jump, then stop
				print('JUMP INTERUPTED: was in normal jump')
				self._current_velocity.y = 0.0

	# snap is a way to stuck to floor
	var snap = self._get_snap_to_floor_vector(direction)
	#print('CURRENT SPEED: %s' % self._current_velocity)
	self._current_velocity = move_and_slide_with_snap(
		self._current_velocity, snap, FLOOR_NORMAL, true
	)






func _update_moving(delta):
	self._move_right_strength = Input.get_action_strength("move_right")
	self._move_left_strength = Input.get_action_strength("move_left")
	self._move_up_strength = Input.get_action_strength("move_up")
	self._move_down_strength = Input.get_action_strength("move_down")
	
	
	var move_x = self._move_right_strength - self._move_left_strength
	var move_y = self._move_up_strength - self._move_down_strength
	var cur_move_vec = cartesian2polar(move_x, move_y)
	
	# Save if we did look at right or left
	if move_x != 0:
		self._last_looking_direction = 1 if move_x > 0 else -1
	
	if cur_move_vec != Vector2.ZERO:
		#print('X:', move_x, 'Y:', move_y, '=> force=', cur_move_vec[0],  'angle=', cur_move_vec[1])
		self._aim_vector = Vector2(1, cur_move_vec[1])  # save only the angle
	
	# Now look if we did collide with a wall
	var _previous_wall = self._current_wall
	if not self.is_on_wall():
		self._current_wall = TOUCH_NO_WALL
	else:
		self._current_wall = self.get_which_wall_collided()
		# We are griping the wall, so simulate a lower gravity, just for us
		self._set_lower_gravity()
	if _previous_wall != self._current_wall:
		print('Switch wall colision from', _previous_wall, ' to ', self._current_wall)
		
		


func _set_lower_gravity():
	self._current_gravity = GRAVITY / 4
	
	
func _is_touching_a_wall() -> bool:
	return false




func add_to_world(obj):
	self.get_parent().add_child(obj)



func _get_direction() -> Vector2:
	
	var _asking_for_jump = Input.is_action_just_pressed("jump")
	
	var was_on_floor = self._is_on_floor
	self._is_on_floor = self.is_on_floor()
	if _asking_for_jump:
		print('ASK JUMP', self._is_on_floor)
	var is_start_to_jump = self._is_on_floor and _asking_for_jump
	var is_landing = not was_on_floor and self._is_on_floor

	# When jumping, add a little dust
	if is_start_to_jump:
		self.sound_jump.play()
		
		


	
	if self._move_right_strength == 0 and self._move_left_strength == 0 and self._move_down_strength == 0 and self._move_up_strength == 0:
		sprite.play('idle')
		if _last_looking_direction == 1:
			sprite.flip_h = false  # right
		else:
			sprite.flip_h = true  # left
			
	else:
		# no step on the air ^^
		if self._is_on_floor:
			if not sound_walk.playing:  
				sound_walk.play()
		else:
			if sound_walk.playing:
				sound_walk.stop()
		if self._move_right_strength > self._move_left_strength:
			whole_body_animation.play("walk_right")
			#body_animation.play("walk_right")
			body.set_state("walk_right")
			self._get_weapon().set_walk_right()
			self._eyes_move_to_right()
		else:
			whole_body_animation.play("walk_left")
			#body_animation.play("walk_left")
			body.set_state("walk_left")
			self._get_weapon().set_walk_left()
			self._eyes_move_to_right()
	
	var new_direction = Vector2(
		self._move_right_strength - self._move_left_strength,
		#self._move_down_strength - self._move_up_strength
		-Input.get_action_strength("jump") if is_start_to_jump else 0.0
	)
	# Maybe we are wall jumping
	if _asking_for_jump and self._is_touching_a_wall():
		print('WALL JUMP from %s' % self._current_wall)
		self.sound_jump.play()
		new_direction[1] = -Input.get_action_strength("jump")
	#	# NOTE: to evade player input, we simulate a huge force against the wall
		new_direction[0] = 10
		if self._current_wall == TOUCH_RIGHT_WALL:
			new_direction[0] *= -1  # need to inverse force to get lower x
	return new_direction
	




func die() -> void:
	PlayerData.deaths += 1
	queue_free()

