tool
extends Node2D


class_name TurtleTopDown, "res://assets/player/turtles/top-down/icon.png"

onready var blood_mask_scene = load("res://src/Objects/blood_mask.tscn")
onready var sound_kill = $sound_kill

export var create_color: String

export var _hat = 'none'

export var with_gun = false

func _get_configuration_warning() -> String:
	return "The property create_color can't be empty" if not create_color else ""



var _color = 'leo'

var _current_state = ''

onready var animation_player = $whole_animation
onready var hit_animation = $hit_animation
onready var hat_sprite = $hat
onready var weapon = $weapon

var SPRITE_LIGHT_COLOR = Color('bc00bc')
var SPRITE_DARK_COLOR = Color('333333')

var COLORS = {
	#             light              dark
	'don' : [Color('bc00bc'), Color('000000')],
	'leo' : [Color('2038ec'), Color('000000')],
	'raph' : [Color('d82800'), Color('000000')],
	'miche' : [Color('fc9838'), Color('000000')],
	
}

onready var shader_material = $sprite.material


func _ready():
	print('human::_ready. Weapon is %s' % self.weapon)
	# IMPORTANT: in human_sprite we did duplicate the shader_material of this sprite
	if self.create_color != '':
		self._color = create_color
	shader_material.set_shader_param('sprite_light_color', SPRITE_LIGHT_COLOR)
	shader_material.set_shader_param('sprite_dark_color', SPRITE_DARK_COLOR)
	self.set_color(self._color)
	
	# Now set hat
	self.set_hat(self._hat)
	
	self.weapon.visible = self.with_gun
	
	
func get_weapon():
	return self.weapon
	


func add_to_world(obj):
	self.get_parent().add_to_world(obj)

	
func set_color(color_name):
	self._color = color_name
	var color_entry = COLORS.get(self._color)
	shader_material.set_shader_param('light_color', color_entry[0])
	shader_material.set_shader_param('dark_color', color_entry[1])
	#print('shader color: %s' % shader_material)
	#print('SHADER SET COLOR with %s' % self._color)
	
	
func set_state(state):
	if state !='idle_left' and state != 'idle_right' and state != 'walk_left' and state != 'walk_right':
		print('ERROR: %s is not managed' % state)
		return
		
	if state == self._current_state:
		return
	self._current_state = state
	#print('HUMAN: launch %s' % state)
	animation_player.play(state)
	

func set_hat(hat_name):
	return
	#self.hat_sprite.play(hat_name)


func get_hit():
	hit_animation.play("hit")


func die():
	var blood_mask = blood_mask_scene.instance()
	blood_mask.position = self.position
	self.get_parent().add_child(blood_mask)
	print('HUMAN: go die')
	animation_player.play("die_right")
	sound_kill.play()
	yield( animation_player, "animation_finished")
	yield(sound_kill, "finished")
	print('ANIM FINISHED')
	
	
