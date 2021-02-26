extends "res://src/Actors/Player_shoot.gd"


# Actor
# user-action
# detect current position / orientation
# apply shoot
# apply movement
# apply display

class_name PlayerPlatformer, "res://assets/player.png"


export var speed: = Vector2(600.0, 1500.0)

onready var dust_scene = load("res://src/Objects/Dust.tscn")
onready var camera_shake = $Camera2D/ScreenShake


## Sounds
onready var sound_walk = $sounds/walk
onready var sound_landing = $sounds/landing
onready var sound_dash = $sounds/dash
onready var sound_jump = $sounds/jump

## Body animation
onready var whole_body_animation = $body_display/whole_body
onready var body_animation = $body/body/AnimationPlayer
onready var body = $body
onready var eyes = $"body_display/body/eyes-back"


export var FRICTION = 0.2  # force against stop
export var ACCELERATION = 0.2  #force against start, 0.2 is quite fast start

export var X_MOVE_SHOOT_INHIBITION = 0.3  # during 0.3s, don't touch the

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

# By default, we are on the floor
var _is_on_floor = true

var _is_dashing = false  # will be set when pushing the dash button
export var DASH_SPEED = 2000
export var DASH_DURATION = 0.3
var _current_dash_duration = 0.0
var _dash_direction = 1  # by default a dash is on the right
var _is_dash_available = true  # dash is reset when getting back on the floor
onready var dash_animation = $dash/AnimationPlayer


func _init():
	print('INIT: Player: %s' % self.name)
	

func _ready():
	print('Player::_ready')
	print('Player::_ready:: body is %s' % self.body)
	#self.weapon = self.body.get_weapon()
	print('Player::_ready:: weapon is %s' % self.body.get_weapon())
	self._get_weapon().set_holder(self)





func _on_StompDetector_area_entered(area: Area2D) -> void:
	#self._velocity = self._calculate_stomp_velocity(self._velocity, stomp_impulse)
	print('DO STOMP BECAUSE JUMP ON AREA %s' % area)
	self._do_stomp()
	


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	if not body.is_dead():
		self.die()


func _is_jumping() -> bool:
	return self._current_velocity.y < 0.0


func _is_jump_interrupted():
	return self._is_jumping() and Input.is_action_just_released("jump") 


func _get_snap_to_floor_vector(direction) -> Vector2:
	# If we are shooting, we must allow the shoot impact to make us
	# fly over, so no snap in this case
	if self.is_shooting():
		return Vector2.ZERO
	# Normal case, if we are not currently jumpingg try to stay on the floor
	return Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO

func _get_body():
	print('GIVE BACK BODY %s' % self.body)
	return self.body
	

func _eyes_move_to_right():
	eyes.set_eyes_position(10, 0)
	
func _eyes_reset_position():
	eyes.reset_eyes_position()
	

	
	

############# Moving / Inputs
func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		print('SHOOT TO %s' % self.get_global_mouse_position())
		print('PLAYER POSITION: %s' % self.global_position)
		self.do_shoot()
		return
	if Input.is_action_just_pressed("go_to"):
		print('GO TO from child')
		if event.get('global_position') == null:
			print('BAD EVENT: %s' % event)
			return
		print('PATH: %s' % event.global_position)
		print('WINDOWS SIZE: %s' % OS.window_size)
		print('VIEWPORT %s' % get_viewport().size)
		var p = event.global_position / OS.window_size * get_viewport().size
		print('CALCUL: %s' % p)
		print('MOUSE POS %s' % self.get_global_mouse_position())
		var nav_2d = get_parent().get_node("Navigation2D")
		var new_path = nav_2d.get_simple_path(
			self.global_position,
			# Scales the mouse position from the window's coordinate system to the viewport's.
			self.get_global_mouse_position()
		)
		self.set_path(new_path)
		get_parent().get_node("Line2D").points = new_path
		print('NEw path: %s' % new_path)

func _find_nearest_enemy() -> Enemy:
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	#print('ALL ENEMIES', all_enemies)
	if len(all_enemies) == 0:
		return null
	
	var my_position = self.global_position
	var nearest_enemy = all_enemies[0]
	var min_distance = nearest_enemy.global_position.distance_to(my_position)

	# look through all enemies and find nearer
	for enemy in all_enemies:
		var enemy_distance = enemy.global_position.distance_to(my_position)
		if enemy_distance < min_distance:
			min_distance = enemy_distance
			nearest_enemy = enemy
	#print('NEAREST ENEMY', nearest_enemy, 'with distance', min_distance)		
	return nearest_enemy


func _look_at_nearest_enemy():
	var enemy = _find_nearest_enemy()
	if enemy == null:
		eyes.reset_eyes_position()
		return
		
	var my_position = self.global_position
	var enemy_position = enemy.global_position
	var diff_vector = enemy_position - my_position
	eyes.set_eyes_from_cartesian_vector(diff_vector)
	

func _physics_process(delta: float) -> void:
	self._update_moving(delta)
	var direction: = self._get_direction()

	#### If dashing: do not look at direction, we are forcing the dash
	if self._is_dashing:
		self._current_velocity.x = self._dash_direction * DASH_SPEED
		self._current_velocity.y = 0  # make the player fly during the dash
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
	self._look_at_nearest_enemy()


# We are back on the floor, so we can dash
func _dash_allow_dash():
	self._is_dash_available = true
	

func _update_dashing(delta):
	# Look if the player asked to dash
	if Input.is_action_just_pressed("dash"):
		if not self._is_dashing and self._is_dash_available:
			print('START DASH')
			self._is_dashing = true
			self._is_dash_available = false  # only one dash until we are getting back on the floor
			self._current_dash_duration = 0.0 
			self._dash_direction = self._last_looking_direction  #1 if self._move_right_strength > self._move_left_strength else -1
			if self._dash_direction == 1:
				dash_animation.play("dash_right")
			else:
				dash_animation.play("dash_left")
			self.sound_dash.play()
	
	# Detect dash stop
	if self._is_dashing:
		# And look if finishing
		self._current_dash_duration += delta
		if self._current_dash_duration > DASH_DURATION:
			self._is_dashing = false
			self._current_dash_duration = 0.0
			dash_animation.play("no_dash")  # hide the dash animation


func _update_moving(delta):
	self._move_right_strength = Input.get_action_strength("move_right")
	self._move_left_strength = Input.get_action_strength("move_left")
	self._move_up_strength = Input.get_action_strength("move_up")
	self._move_down_strength = Input.get_action_strength("move_down")
	
	self._update_dashing(delta)
	
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
		
		
	# move inhibition check if deley
	if self._is_move_inhibition:
		self._current_move_inhibition += delta
		if self._current_move_inhibition > X_MOVE_SHOOT_INHIBITION:
			print('NO MORE MOVE INHIBITION')
			self._is_move_inhibition = false
			self._current_move_inhibition = 0.0


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


func add_to_world(obj):
	self.get_parent().add_child(obj)


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
		self._spawn_jump_dust()
		
	#when landing, add more dusts
	if is_landing:
		print('Landing')
		sound_landing.play()
		self._spawn_jump_reception_dust()
		
	if self._is_on_floor:
		self._dash_allow_dash()
	
	if self._move_right_strength == 0 and self._move_left_strength == 0 and self._move_down_strength == 0 and self._move_up_strength == 0:
		whole_body_animation.play("idle_right")
		sound_walk.stop()
		if _last_looking_direction == 1:
			#body_animation.play("idle_right")
			body.set_state("idle_right")
		else:
			#body_animation.play("idle_left")
			body.set_state("idle_left")
		self._get_weapon().set_idle_right()
		self._eyes_reset_position()
	else:
		sound_walk.play()
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
	


func _do_stomp():
	# I prefer to always have the full stomp impulse when jumping over an ennery
	#var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	self._current_velocity.y =  -speed.y
	self._dash_allow_dash()  # we did stomp an enemy, allow a new dash


func die() -> void:
	PlayerData.deaths += 1
	queue_free()






####FOR SAVING


#func _ready():
#	self.set_process(false)

var _paths = PoolVector2Array()

func _process(delta: float) -> void:
	var move_distance : = 400 * delta
	move_along_path(move_distance)

func move_along_path(distance : float) -> void:
	var last_point : = position
	for index in range(_paths.size()):
		var distance_to_next = last_point.distance_to(_paths[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = last_point.linear_interpolate(_paths[0], distance / distance_to_next)
			break
		elif _paths.size() == 1 and distance >= distance_to_next:
			position = _paths[0]
			set_process(false)
			break

		distance -= distance_to_next
		last_point = _paths[0]
		_paths.remove(0)


func set_path(value : PoolVector2Array) -> void:
	if value.size() == 0:
		return
	_paths = value
	_paths.remove(0)
	set_process(true)
