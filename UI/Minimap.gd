extends MarginContainer
#exports

export var zoom = 1.5
#instances
onready var grid = $MarginContainer/Grid
onready var settlement_marker = $MarginContainer/Grid/Settlement_Marker
onready var worker_marker = $MarginContainer/Grid/Worker_Marker
onready var alert_marker = $MarginContainer/Grid/Alert_Marker
onready var gold_marker = $MarginContainer/Grid/Gold_Marker
onready var wood_marker = $MarginContainer/Grid/Wood_Marker
onready var path_marker = $MarginContainer/Grid/Path_marker
onready var icons = {"Worker" : worker_marker , "alert":alert_marker,"Town Center":settlement_marker,"Wood":wood_marker,"Gold Mine":gold_marker,"TileMap":path_marker}
#params
var grid_scale
var markers = {}

func _ready():
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker  = icons[item.get_name()].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
#tile map not working
func _process(_delta):
	for item in markers:
		var obj_pos = item.position * grid_scale 
		markers[item].position = obj_pos





