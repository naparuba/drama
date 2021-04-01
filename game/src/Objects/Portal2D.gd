tool
extends Area2D

class_name Portal2d, "res://assets/portal.png"


onready var anim_player: AnimationPlayer = $AnimationPlayer

export var next_scene = '' #: PackedScene
export var next_scene_path = '__NOT_SET__'
export var teleport_point = 'a'


func _on_body_entered(body: PhysicsBody2D):
	teleport()


func _get_configuration_warning() -> String:
	return "The property Next Level Path can't be empty" if next_scene_path == '__NOT_SET__' else ""


func teleport() -> void:
	get_tree().paused = true
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	get_tree().paused = false
	print('Try to change scene to %s' % next_scene_path)
	var next_scene_resource = load("res:/%s" % self.next_scene_path)
	print('Next scene ressource: %s' % next_scene_resource)
	print('Next scene teleport point: %s' % self.teleport_point)
	
	ScenesChanger.change_scene(next_scene_resource, {'teleport_point': self.teleport_point})
	
