extends Node2D


onready var player = $player


func _on_collision_body_entered(body):
	if not body.is_in_group('player'):
		return
	print('ALGUES: body: %s' % body)
	player.play("zap")
	body.hurt(0.5)
