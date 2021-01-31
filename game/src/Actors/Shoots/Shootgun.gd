extends Area2D


var shooter : Node


func start_shoot(shooter : Node) -> void:
	self.shooter = shooter
	$AnimatedSprite/AnimationPlayer.play("shoot")


func finish():
	self.shooter.shoot_finished()
	self.queue_free()
