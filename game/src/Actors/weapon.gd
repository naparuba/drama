extends Node2D


export var SHOOTGUN_IMPULSE = 2000
export var MACHINEGUN_IMPULSE = 200

onready var sprite_machine_gun = $sprite_machine_gun
onready var sprite_shootgun = $sprite_shootgun
onready var animation_player_machine_gun = $sprite_machine_gun/AnimationPlayer

var _current = 'machine_gun'
var _current_animation_player = null

var _holder = null


func _ready():
	self.set_machine_gun()
	self.set_idle_right()
	
func set_holder(holder):
	self._holder = holder
	
	
func set_machine_gun():
	sprite_shootgun.visible = false
	sprite_machine_gun = true
	self._current = 'machine_gun'
	self._current_animation_player = animation_player_machine_gun	
	

func set_shootgun():
	sprite_shootgun.visible = true
	sprite_machine_gun = false
	self._current = 'shootgun'


func set_idle_right():
	self._current_animation_player.play('idle_right')



func set_walk_right():
	self._current_animation_player.play('walk_right')



func get_impulse():
	if self._current == 'shootgun':
		return SHOOTGUN_IMPULSE
	return MACHINEGUN_IMPULSE
