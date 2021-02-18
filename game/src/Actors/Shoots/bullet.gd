extends Area2D

class_name bullet

var speed = Vector2(1000, 0)

var _shooter = null

	
	
func set_shooter(shooter):
	self._shooter = shooter
	

func _on_body_entered(other):
	print('bullet did touch something %s' % other)
	if other.is_in_group('enemy'):
		other.take_damage(1)
	self.queue_free()
	

# useless now
func _on_area_entered(area):
	return



func _process(delta):
	#print('SHYSICS PROCESS FOR BULLET')
	position += transform.x * speed.x * delta


func _onarea_shape_entered(area_id, area, area_shape, self_shape):
	return

