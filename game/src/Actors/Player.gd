extends Actor


export var stomp_impulse: = 600.0
export var friction = 0.1  # force against stop
export var acceleration = 0.5  #force against start


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


func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and self._is_jumping()
	var direction: = self._get_direction()

	# Apply X speed
	self._current_velocity.x = speed.x * direction.x
	
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


func _get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)


func _do_stomp():
	# I prefer to always have the full stomp impulse when jumping over an ennery
	#var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	self._current_velocity.y =  -stomp_impulse


func die() -> void:
	PlayerData.deaths += 1
	queue_free()
