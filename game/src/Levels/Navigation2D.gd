extends Navigation2D


#TODO: we update the full nav for each polygon, maybe we can batch it

# We have the new polygon shape to add to the navigation polygon, and update the navigation
# object for it
func __update_navigation_polygon(_navigation_polygon, new_polygon):
	var original_polygon = _navigation_polygon.get_navigation_polygon()
	original_polygon.add_outline(new_polygon)
	original_polygon.make_polygons_from_outlines()
	_navigation_polygon.set_navigation_polygon(original_polygon)
	# HACK: for reload it, we must enable/disable it
	_navigation_polygon.enabled = false
	_navigation_polygon.enabled = true


func __update_light_polygon(_light_occluder, new_light_polygon):
	# Maybe the editor did move the light position, so we it back
	_light_occluder.position = Vector2.ZERO
	# IMPORTANT: we must recreate the .occluder, if not, we will have the same as other nodes
	#            and so polygon will be shared too
	_light_occluder.occluder = OccluderPolygon2D.new()
	var light_occluder_polygon = _light_occluder.get_occluder_polygon()
	var l_polygon = light_occluder_polygon.get_polygon()

	print('New light polygon: %s' % new_light_polygon)
	light_occluder_polygon.set_polygon(new_light_polygon)
	_light_occluder.set_occluder_polygon(light_occluder_polygon)
	_light_occluder.visible = false
	_light_occluder.visible = true


func _load_and_compute_collision_and_light(_collision_box, _navigation_polygon):
	var _light_occluder = _collision_box.get_node('light_occluder')

	var new_polygon = PoolVector2Array()
	var new_light_polygon = PoolVector2Array()
	var col_polygon_transform = _collision_box.get_global_transform()
	
	# Get the shape of the collision box
	var col_polygon_bp = _collision_box.get_polygon()
	for vertex in col_polygon_bp:
		new_light_polygon.append(vertex)
		new_polygon.append(col_polygon_transform.xform(vertex) - _navigation_polygon.transform.get_origin())
	print('NEW POLYGON', new_polygon)
	
	# Add the shape to the navigation polygon (so will be REMOVED from the shape)
	self.__update_navigation_polygon(_navigation_polygon, new_polygon)

	# And also update the shape of the light occluder, if not a transparent block
	if _light_occluder != null:
		self.__update_light_polygon(_light_occluder, new_light_polygon)
	return

	

func _ready():
	print('NAV POLY: %s' % self)
	var all_obstacles = get_tree().get_nodes_in_group('obstacle')
	for obstacle in all_obstacles:
		var _collision_box = obstacle.get_node('collision_box')
		self._load_and_compute_collision_and_light(_collision_box, $NavigationPolygonInstance)
	return
	
	
	
	
	
	
	
	
