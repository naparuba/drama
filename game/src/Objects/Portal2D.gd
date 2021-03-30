tool
extends Area2D

class_name Portal2d, "res://assets/portal.png"


onready var anim_player: AnimationPlayer = $AnimationPlayer

export var next_scene: PackedScene
export var teleport_point = 'a'


func _on_body_entered(body: PhysicsBody2D):
	teleport()


func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if not next_scene else ""


func teleport() -> void:
	get_tree().paused = true
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	get_tree().paused = false
	ScenesChanger.change_scene(next_scene, {'teleport_point': self.teleport_point})
	
