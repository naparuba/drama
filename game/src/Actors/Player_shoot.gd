extends Actor



export var STOMP_IMPULSE: = 1000.0

var _is_shooting = false  # flag to block new shoot
# TODO var _current_direction : Vector2 = Vector2(1, 0)  # Looking at right
onready var Shootgun = load("res://src/Actors/Shoots/Shootgun.tscn")
onready var mouth_animation = $"body_display/body/mouth/mouth-animation"

onready var Bullet = load('res://src/Actors/Shoots/bullet.tscn')
onready var weapon = $"body_display/body/weapon"


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
	#self._is_shooting = true
	mouth_animation.play("firing_right")
	shootgun.start_shoot(self)
	#shootgun.position = Vector2(50, -45)  # TODO: adjust with real sprite
	shootgun.position.y = -50  # by default it's high to match player arms
	shootgun.position += polar2cartesian(self._move_vec[0] * 50 , -1 * self._move_vec[1] )
	shootgun.scale = Vector2(4, 4)  # TODO: adjust with real sprite
	shootgun.rotation_degrees = -1 * rad2deg(self._move_vec[1] )
	#self.add_child(shootgun)
	
	var bullet = Bullet.instance()
	
	bullet.set_shooter(self)
	get_parent().add_child(bullet)
	bullet.global_position = self.global_position +  polar2cartesian(self._move_vec[0] * 200 , -1 * self._move_vec[1] )
	bullet.global_position.y -= 100
	bullet.rotation_degrees = -1 * rad2deg(self._move_vec[1] )
	#bullet.transform = self.transform


func _apply_reverse_shootgun_force():
	var reverse_force = polar2cartesian(self._move_vec[0]  ,  self._move_vec[1] )
	var _impulse = weapon.get_impulse()
	reverse_force[0] *=  -_impulse  # -1 = >oposite force
	reverse_force[1] *= _impulse  #-1 but as the y is inversed, it's +1
	print ('REVERSE FORCE  X=', reverse_force[0], 'Y=', reverse_force[1])
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
