extends Node2D

onready var animation_player = $sprite/AnimationPlayer

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

var _color = 'yellow'


func _ready():
	shader_material.set_shader_param('sprite_light_color', SPRITE_LIGHT_COLOR)
	shader_material.set_shader_param('sprite_dark_color', SPRITE_DARK_COLOR)
	self.set_color('yellow')
	
	
func set_color(color_name):
	self._color = color_name
	var color_entry = COLORS.get(self._color)
	shader_material.set_shader_param('light_color', color_entry[0])
	shader_material.set_shader_param('dark_color', color_entry[1])
	
	
func set_state(state):
	animation_player.play(state)
	

	
