extends Area2D


var shooter : Node


func start_shoot(shooter : Node) -> void:
	self.shooter = shooter
	$AnimatedSprite/AnimationPlayer.play("shoot")


func finish():
	self.shooter.shoot_finished()
	self.queue_free()


func _on_body_entered(other):
	print("BODY ENTERED %s" % (other))
	print("BODY ENTERED %s" % (str(other.get_groups ( ))))
	if other.is_in_group(Groups.ENEMY):
		print('ENNEMY DETECTED')
		other.die()
		self.shooter.did_kill_enemy(other)
		
