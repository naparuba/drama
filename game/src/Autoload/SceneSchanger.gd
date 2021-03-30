extends Node


var _scene_parameters = {}
func change_scene(next_scene, parameters):
	self._scene_parameters = parameters
	get_tree().change_scene_to(next_scene)
	

func get_scene_parameters():
	var r = self._scene_parameters
	self._scene_parameters ={}
	return r
