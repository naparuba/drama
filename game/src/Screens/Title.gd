extends Control


export(String, FILE) var next_scene_path: = ""

onready var player = $AnimationPlayer
onready var mask = $mask

func _ready():
	self._start_animation()
	
	
func _start_animation():
	player.play('intro')


func _input(event):
	print('INPUT %s' % event)
	if Input.is_action_just_pressed("ui_accept"):
		print('IS PRESSED')
		get_tree().change_scene(next_scene_path)
