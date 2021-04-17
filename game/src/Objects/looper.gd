extends Node2D



func _on_collisions_body_entered(body):
	if not body.is_in_group('player'):
		return
	print('LOOPER: BODY ENTERER: %s' % body)
	body.hurt(0.5)


func _on_collisions_area_entered(area):
	print('LOOPER: AREA Entered: %s' % area)
