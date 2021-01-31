extends Actor


export var stomp_impulse: = 600.0
export var friction = 0.1  # force against stop
export var acceleration = 0.5  #force against start


func _on_StompDetector_area_entered(area: Area2D) -> void:
	self._velocity = self._calculate_stomp_velocity(self._velocity, stomp_impulse)


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	self.die()


func _is_jumping() -> bool:
	return self._velocity.y < 0.0


func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and self._is_jumping()
	var direction: = self._get_direction()
	self._velocity = self._calculate_move_velocity(self._velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	self._velocity = move_and_slide_with_snap(
		self._velocity, snap, FLOOR_NORMAL, true
	)


func _get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)


func _calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity


func _calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)


func die() -> void:
	PlayerData.deaths += 1
	queue_free()
