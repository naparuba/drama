extends Position2D


func _ready():
	play()


func play():
	$AnimationPlayer.play("impact")


func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()


func _on_AnimationPlayer_tree_exiting():
	return
