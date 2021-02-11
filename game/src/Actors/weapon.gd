extends Node2D


export var SHOOTGUN_IMPULSE = 2000
export var MACHINEGUN_IMPULSE = 200

onready var sprite_machine_gun = $sprite_machine_gun
onready var sprite_shootgun = $sprite_shootgun
onready var animation_player_machine_gun = $sprite_machine_gun/AnimationPlayer
onready var animation_player_shootgun_gun = $sprite_shootgun/AnimationPlayer

onready var Shootgun_shoot = load("res://src/Actors/Shoots/Shootgun.tscn")
onready var Shootgun = load("res://src/Actors/Shoots/Shootgun.tscn")

var _current = 'shootgun'
var _current_animation_player = null
var _is_shooting = false
var _holder = null


func _ready():
	self.set_shootgun()
	self.set_idle_right()
	

func set_holder(holder):
	self._holder = holder
	
func is_shooting():
	return self._is_shooting

	
func set_machine_gun():
	sprite_shootgun.visible = false
	sprite_machine_gun.visible = true
	self._current = 'machine_gun'
	self._current_animation_player = animation_player_machine_gun	
	

func set_shootgun():
	sprite_shootgun.visible = true
	sprite_machine_gun.visible = false
	self._current = 'shootgun'
	self._current_animation_player = animation_player_shootgun_gun


func set_idle_right():
	self._current_animation_player.play('idle_right')


func set_idle_left():
	self._current_animation_player.play('idle_right')


func set_walk_right():
	self._current_animation_player.play('walk_right')


func set_walk_left():
	self._current_animation_player.play('walk_right')


func get_impulse():
	if self._current == 'shootgun':
		return SHOOTGUN_IMPULSE
	return MACHINEGUN_IMPULSE


func shoot(aim_vetor):
	if self._is_shooting:
		return
	self._is_shooting = true
	var shootgun = Shootgun.instance()
	shootgun.start_shoot(self._holder)
	shootgun.position.y = -50  # by default it's high to match player arms
	shootgun.position += polar2cartesian(aim_vetor[0] * 50 , -1 * aim_vetor[1] )
	shootgun.scale = Vector2(4, 4)  # TODO: adjust with real sprite
	shootgun.rotation_degrees = -1 * rad2deg(aim_vetor[1] )
	self._holder.add_child(shootgun)
	Input.start_joy_vibration(0, 0.1, 1, 0.2)
	
	#Bullet base code
	#var bullet = Bullet.instance()
	#bullet.set_shooter(self)
	#get_parent().add_child(bullet)
	#bullet.global_position = self.global_position +  polar2cartesian(self._aim_vector[0] * 200 , -1 * self._aim_vector[1] )
	#bullet.global_position.y -= 100
	#bullet.rotation_degrees = -1 * rad2deg(self._aim_vector[1] )
	
func shoot_finished():
	self._is_shooting = false
