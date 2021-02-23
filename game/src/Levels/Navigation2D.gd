tool

extends Navigation2D

onready var line = $Line2D

onready var collision_box = $Staticbox/collision_box
onready var light_occluder : LightOccluder2D = $Staticbox/collision_box/light_occluder


func _ready():
	print('NAV POLY: %s' % self)
	
	var original_polygon = $NavigationPolygonInstance.get_navigation_polygon()
	var new_polygon = PoolVector2Array()
	var new_light_polygon = PoolVector2Array()
	var col_polygon_transform = collision_box.get_global_transform()
	var light_occluder_polygon = light_occluder.get_occluder_polygon()
	print('COLLISION TRANSFORM: %s' % col_polygon_transform)
	print('Original polygon transform: %s' % $NavigationPolygonInstance.transform.get_origin())
	var col_polygon_bp = collision_box.get_polygon()
	for vertex in col_polygon_bp:
		new_light_polygon.append(vertex)
		new_polygon.append(col_polygon_transform.xform(vertex) - $NavigationPolygonInstance.transform.get_origin())
		print('VErtex added', new_polygon)
	print('LINE', new_polygon[0], new_polygon[1])
	line.points = PoolVector2Array([new_polygon[0], new_polygon[1]])
	print('NEW POLYGON', new_polygon)
	original_polygon.add_outline(new_polygon)
	original_polygon.make_polygons_from_outlines()
	$NavigationPolygonInstance.set_navigation_polygon(original_polygon)
	$NavigationPolygonInstance.enabled = false
	$NavigationPolygonInstance.enabled = true
	print('NAV POLY 22 %s' % self)

	print('****** Light: *******')
	var l_polygon = light_occluder_polygon.get_polygon()
	print('Light polygon: %s' % l_polygon)
	#light_occluder_polygon.add_outline(new_polygon)
	#light_occluder_polygon.make_polygons_from_outlines()
	print('New light polygon: %s' % new_light_polygon)
	light_occluder_polygon.set_polygon(new_light_polygon)
	light_occluder.set_occluder_polygon(light_occluder_polygon)
	light_occluder.visible = false
	light_occluder.visible = true
	
	
	
	
	
	
	
