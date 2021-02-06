extends Actor

class_name Player, "res://assets/player.png"


export var speed: = Vector2(1000.0, 1500.0)

onready var dust_scene = load("res://src/Objects/Dust.tscn")
onready var camera_shake = $Camera2D/ScreenShake


## Body animation
onready var whole_body_animation = $body_display/whole_body

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

var _current_wall = TOUCH_NO_WALL

# By default, we are on the floor
var _is_on_floor = true


var _is_shooting = false  # flag to block new shoot
# TODO var _current_direction : Vector2 = Vector2(1, 0)  # Looking at right
onready var Shootgun = load("res://src/Actors/Shoots/Shootgun.tscn")



#func _ready():
#	self.speed = Vector2(900.0, 500.0)
	

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


func _add_shootgun():
	var shootgun = Shootgun.instance()
	self._is_shooting = true
	shootgun.start_shoot(self)
	#shootgun.position = Vector2(50, -45)  # TODO: adjust with real sprite
	shootgun.position.y = -50  # by default it's high to match player arms
	shootgun.position += polar2cartesian(self._move_vec[0] * 50 , -1 * self._move_vec[1] )
	shootgun.scale = Vector2(4, 4)  # TODO: adjust with real sprite
	shootgun.rotation_degrees = -1 * rad2deg(self._move_vec[1] )
	self.add_child(shootgun)


func _apply_reverse_shootgun_force():
	var reverse_force = polar2cartesian(self._move_vec[0]  ,  self._move_vec[1] )
	reverse_force[0] *=  -SHOOTGUN_IMPULSE  # -1 = >oposite force
	reverse_force[1] *= SHOOTGUN_IMPULSE  #-1 but as the y is inversed, it's +1
	print ('REVERSE FORCE  X=', reverse_force[0], 'Y=', reverse_force[1])
	#self._current_velocity.x -= SHOOTGUN_IMPULSE
	self._current_velocity += reverse_force


func do_shoot():
	if self._is_shooting:
		return
	# We can shoot, add the shootgun
	self._add_shootgun()
	# we did shoot, so apply an oposite force (... lol ...)
	self._apply_reverse_shootgun_force()
	Input.start_joy_vibration(0, 0.1, 1, 0.2)
	#$shell_emiter.emitting = true
	#$shell_emiter.one_shot = true
	

func did_kill_enemy(enemy):
	# Slow a bit each time an enemy is killed
	SlowTime.start()
	self.camera_shake.start()
	
	

############# Moving / Inputs
func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		self.do_shoot()


func _physics_process(delta: float) -> void:
	var direction: = self._get_direction()

	# Apply X speed
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
		#print('X:', move_x, 'Y:', move_y, '=> force=', cur_move_vec[0],  'angle=', cur_move_vec[1])
		self._move_vec = Vector2(1, cur_move_vec[1])  # save only the angle


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
	return self._current_wall == TOUCH_LEFT_WALL or self._current_wall == TOUCH_RIGHT_WALL



# When we are jumping, put a smoke dust at our jumping position
func _spawn_jump_dust():
	self._spawn_dusts(1)  # only one dust each side


# When we are jumping, put a smoke dust at our jumping position
func _spawn_jump_reception_dust():
	self._spawn_dusts(2)  # only one dust each side




func _spawn_dusts(nb_each_side):
	var dust_position = self.global_position

	for _i in range(-nb_each_side, nb_each_side+1):
		var dust = dust_scene.instance()
		dust.position = dust_position
		dust.scale.x *= _i/3.0
		dust.scale.y *= abs(_i/3.0)
		get_parent().add_child(dust)
		
		
# TODO: jump: jump buffer, to allow jump a bit before landing, or exiting a platform (coyote_time)
# TODO: shader border avec ce qu'il peux interagir? desature color for hits
# MUSICS & sound effect!
# TODO: reduce camera (top & bottom black lines) to focus on action?
# TODO: add armo shell particules when firing
# on enemy: spirkle at impact point, blink the enemy,let the enemy corpse, shake the camera when hitting
# shoot: visual glitch like in https://gravityace.com/devlog/making-better-bullets/ ( point 9)
# TODO: when boost: apply a total screen lightning like in https://www.jeuxvideo.com/videos/1271799/swimsanity-le-shooter-aquatique-est-disponible.htm

func _get_direction() -> Vector2:
	self._update_moving()
	var _asking_for_jump = Input.is_action_just_pressed("jump")
	
	var was_on_floor = self._is_on_floor
	self._is_on_floor = self.is_on_floor()
	
	var is_start_to_jump = self._is_on_floor and _asking_for_jump
	var is_landing = not was_on_floor and self._is_on_floor

	# When jumping, add a little dust
	if is_start_to_jump:
		self._spawn_jump_dust()
		
	#when landing, add more dusts
	if is_landing:
		print('Landing')
		self._spawn_jump_reception_dust()
	
	if self._move_right_strength - self._move_left_strength == 0:
		whole_body_animation.play("idle_right")
	else:
		whole_body_animation.play("walk_right")
	
	var new_direction = Vector2(
		self._move_right_strength - self._move_left_strength,
		-Input.get_action_strength("jump") if is_start_to_jump else 0.0
	)
	# Maybe we are wall jumping
	if _asking_for_jump and self._is_touching_a_wall():
		print('WALL JUMP from %s' % self._current_wall)
		new_direction[1] = -Input.get_action_strength("jump")
		# NOTE: to evade player input, we simulate a huge force against the wall
		new_direction[0] = 10
		if self._current_wall == TOUCH_RIGHT_WALL:
			new_direction[0] *= -1  # need to inverse force to get lower x
	return new_direction
	


func _do_stomp():
	# I prefer to always have the full stomp impulse when jumping over an ennery
	#var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	self._current_velocity.y =  -speed.y


func die() -> void:
	PlayerData.deaths += 1
	queue_free()

