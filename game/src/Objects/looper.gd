extends Node2D



func _on_collisions_body_entered(body):
	print('LOOPER: BODY ENTERER: %s' % body)


func _on_collisions_area_entered(area):
	print('LOOPER: AREA Entered: %s' % area)
