extends Area2D

onready var sound_shoot = $sounds/shoot
onready var sound_reload = $sounds/reload
var shooter : Node


func start_shoot(shooter : Node) -> void:
	self.shooter = shooter
	$AnimatedSprite/AnimationPlayer.play("shoot")
	$sounds/shoot.play()


func finish():
	$AnimatedSprite.visible = false
	self.sound_reload.play()
	yield(self.sound_reload, 'finished')
	self.shooter.shoot_finished()
	self.queue_free()


func _on_body_entered(other):
	print("BODY ENTERED %s" % (other))
	print("BODY ENTERED %s" % (str(other.get_groups ( ))))
	if other.is_in_group(Groups.ENEMY):
		print('ENNEMY DETECTED')
		other.take_damage(3)
		self.shooter.did_kill_enemy(other)
		
