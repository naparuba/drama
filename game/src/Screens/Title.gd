extends Control


export(String, FILE) var next_scene_path: = ""

onready var player = $AnimationPlayer
onready var mask = $mask
onready var press_start_animation = $"push-start/push-start-animation"
onready var title_music = $title_music

func _ready():
	pass #self._start_animation()
	
	
func _start_animation():
	title_music.play()
	player.play('intro')


func _input(event):
	print('INPUT %s' % event)
	if Input.is_action_just_pressed("ui_accept"):
		player.stop()
		press_start_animation.play("push-start")
		yield(press_start_animation, 'animation_finished')
		get_tree().change_scene(next_scene_path)


func _on_start_timer_timeout():
	self._start_animation()
