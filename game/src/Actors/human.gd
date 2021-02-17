tool
extends Node2D


export var create_color: String

export var _hat = 'none'

func _get_configuration_warning() -> String:
	return "The property create_color can't be empty" if not create_color else ""



var _color = 'yellow'

var _current_state = ''

onready var animation_player = $whole_animation
onready var hat_sprite = $hat

var SPRITE_LIGHT_COLOR = Color('ff0000')
var SPRITE_DARK_COLOR = Color('0000ff')

var COLORS = {
	#             light              dark
	'yellow' : [Color('f3ec5f'), Color('c3882b')],
	'blue' : [Color('384da1'), Color('2b3081')],
	'brown' : [Color('714a1e'), Color('5e2615')],
	'cyan' : [Color('75cbc2'), Color('22a9bf')],
	'orange' : [Color('ef7e22'), Color('b54025')],
	'light_green' : [Color('77c143'), Color('18a84a')],
	'dark_green' : [Color('168140'), Color('0a4e2e')],
	'black' : [Color('3f474f'), Color('1d1e25')],
	'pink' : [Color('d95ca2'), Color('9f3f98')],
	'purple' : [Color('66479c'), Color('3e2b79')],
	'white' : [Color('d8e2f1'), Color('8495c0')],
	'red' : [Color('c42126'), Color('7a1239')],
}

onready var shader_material = $sprite.material


func _ready():
	# IMPORTANT: in human_sprite we did duplicate the shader_material of this sprite
	if self.create_color != '':
		self._color = create_color
	shader_material.set_shader_param('sprite_light_color', SPRITE_LIGHT_COLOR)
	shader_material.set_shader_param('sprite_dark_color', SPRITE_DARK_COLOR)
	self.set_color(self._color)
	
	# Now set hat
	self.set_hat(self._hat)
	
	
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
	self.hat_sprite.play(hat_name)
