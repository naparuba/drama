extends Actor



export var STOMP_IMPULSE: = 1000.0

var _is_shooting = false  # flag to block new shoot
# TODO var _current_direction : Vector2 = Vector2(1, 0)  # Looking at right
onready var Shootgun = load("res://src/Actors/Shoots/Shootgun.tscn")
onready var mouth_animation = $"body_display/body/mouth/mouth-animation"

onready var Bullet = load('res://src/Actors/Shoots/bullet.tscn')
onready var weapon = $"body/weapon"


######################## Shooting
func shoot_finished():
	self.weapon.shoot_finished()
	


func is_shooting():
	return self.weapon.is_shooting()
	


func _apply_reverse_shootgun_force():
	var reverse_force = polar2cartesian(self._aim_vector[0]  ,  self._aim_vector[1] )
	var _impulse = weapon.get_impulse()
	reverse_force[0] *=  -_impulse  # -1 = >opposite force
	reverse_force[1] *= _impulse  #-1 but as the y is inversed, it's +1
	print ('REVERSE FORCE  X=', reverse_force[0], 'Y=', reverse_force[1])
	self._current_velocity += reverse_force
	
	self._is_move_inhibition = true  # don't allow X move during a time


func do_shoot():
	if self.is_shooting():
		return
	# We can shoot, add the shootgun
	mouth_animation.play("firing_right")
	self.weapon.shoot(self._aim_vector)
	# we did shoot, so apply an oposite force (... lol ...)
	self._apply_reverse_shootgun_force()
	
	

func did_kill_enemy(enemy):
	print('DID KILL %s' % enemy)
	# Slow a bit each time an enemy is killed
	SlowTime.start()
	self.camera_shake.start()
