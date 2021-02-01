extends Actor


export var STOMP_IMPULSE: = 1000.0
export var SHOOTGUN_IMPULSE = 2000
export var FRICTION = 0.1  # force against stop
export var ACCELERATION = 0.2  #force against start, 0.2 is quite fast start

### Aiming / Moving
var _move_right_strength = 0.0
var _move_left_strength = 0.0
var _move_up_strength = 0.0
var _move_down_strength = 0.0
var _move_vec = Vector2(1, 0)  # what the player is asking to aim




var _is_shooting = false  # flag to block new shoot
# TODO var _current_direction : Vector2 = Vector2(1, 0)  # Looking at right
onready var Shootgun = load("res://src/Actors/Shoots/Shootgun.tscn")

func _on_StompDetector_area_entered(area: Area2D) -> void:
	#self._velocity = self._calculate_stomp_velocity(self._velocity, stomp_impulse)
	self._do_stomp()
	


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	self.die()


func _is_jumping() -> bool:
	return self._current_velocity.y < 0.0


func _is_jump_interrupted():
	return self._is_jumping() and Input.is_action_just_released("jump") 


func _get_snap_to_floor_vector(direction) -> Vector2:
	return Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO


######################## Shooting
func shoot_finished():
	self._is_shooting = false
	return



func _get_shoot_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1
		)


func do_shoot():
	if self._is_shooting:
		return
	var shootgun = Shootgun.instance()
	self._is_shooting = true
	shootgun.start_shoot(self)
	#shootgun.position = Vector2(50, -45)  # TODO: adjust with real sprite
	shootgun.position.y = -50  # by default it's high to match player arms
	shootgun.position += polar2cartesian(self._move_vec[0] * 50 , -1 * self._move_vec[1] )
	shootgun.scale = Vector2(2, 2)  # TODO: adjust with real sprite
	shootgun.rotation_degrees = -1 * rad2deg(self._move_vec[1] )
	self.add_child(shootgun)
	
	var reverse_force = polar2cartesian(self._move_vec[0]  ,  self._move_vec[1] )
	reverse_force[0] *=  -SHOOTGUN_IMPULSE  # -1 = >oposite force
	reverse_force[1] *= SHOOTGUN_IMPULSE  #-1 but as the y is inversed, it's +1
	print ('REVERSE FORCE  X=', reverse_force[0], 'Y=', reverse_force[1])
	#self._current_velocity.x -= SHOOTGUN_IMPULSE
	self._current_velocity += reverse_force



############# Moving / Inputs
func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		self.do_shoot()


func _physics_process(delta: float) -> void:
#	var is_jump_interrupted: = Input.is_action_just_released("jump") and self._is_jumping()
	var direction: = self._get_direction()

	# Apply X speed
	#velocity.x = lerp(velocity.x, dir * speed, acceleration)
	if direction.x != 0:
		var _wished_speed = speed.x * direction.x
		self._current_velocity.x = lerp(self._current_velocity.x, _wished_speed, ACCELERATION)
	else:  # do not stop immediatly
		var _wished_speed = 0  # want to stop
		self._current_velocity.x = lerp(self._current_velocity.x, _wished_speed, FRICTION)
		
	# Apply Y speed if any
	if direction.y != 0.0:
		self._current_velocity.y = speed.y * direction.y
	if self._is_jump_interrupted():
		self._current_velocity.y = 0.0

	# snap is a way to stuck to floor
	var snap = self._get_snap_to_floor_vector(direction)
	self._current_velocity = move_and_slide_with_snap(
		self._current_velocity, snap, FLOOR_NORMAL, true
	)


func _update_moving():
	self._move_right_strength = Input.get_action_strength("move_right")
	self._move_left_strength = Input.get_action_strength("move_left")
	self._move_up_strength = Input.get_action_strength("move_up")
	self._move_down_strength = Input.get_action_strength("move_down")
	
	var move_x = self._move_right_strength - self._move_left_strength
	var move_y = self._move_up_strength - self._move_down_strength
	var cur_move_vec = cartesian2polar(move_x, move_y)
	
	if cur_move_vec != Vector2.ZERO:
		print('X:', move_x, 'Y:', move_y, '=> force=', cur_move_vec[0],  'angle=', cur_move_vec[1])
		self._move_vec = Vector2(1, cur_move_vec[1])  # save only the angle


func _get_direction() -> Vector2:
	self._update_moving()
	var new_direction = Vector2(
		self._move_right_strength - self._move_left_strength,
		-Input.get_action_strength("jump") if self.is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)
	
	return new_direction
	


func _do_stomp():
	# I prefer to always have the full stomp impulse when jumping over an ennery
	#var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	self._current_velocity.y =  -speed.y #-STOMP_IMPULSE     TODO: why??


func die() -> void:
	PlayerData.deaths += 1
	queue_free()
