extends Node2D
const MOVE_MARGIN = 20
onready var building_preview = $Area2D/Building_Preview
onready var town_cent = load("res://Buildings/town_center_3.png")
onready var barracks = load("res://Buildings/barracks.png") 
onready var armoury = load("res://Buildings/armoury.png")
onready var barn = load("res://Buildings/barn_1.png")

var scale_building = Vector2((0.1),(0.1))
var building_matrix = []
var placable = false
var worker_instance
var is_visibile = false
var mouse_pos = Vector2.ZERO
var start_pos = Vector2.ZERO
var top = Vector2()
var bot = Vector2()
const box_colour = Color(0.5,1,1) # assign team_color
const box_line_width = 1
var selected = []
var box = RectangleShape2D.new()
var selectable_object
var to_build_type
#signal put_building(building_type)
signal wait_building(state)

func _ready():
	build_matrix()
	set_process(true)

func build_matrix():
	for x in range(5):
		building_matrix.append([])
		for y in range(2):
			building_matrix[x].append(0)
	building_matrix[0][0] = town_cent
	building_matrix[0][1] = "Town_Center"
	building_matrix[1][0] = armoury
	building_matrix[1][1] = "Armoury"
	building_matrix[2][0] = barracks
	building_matrix[2][1] = "Barracks"
	building_matrix[3][0] = barn
	building_matrix[3][1] = "Barn"

func _physics_process(_delta):
	position = get_global_mouse_position()
	
func _input(event):
	if Input.is_action_just_pressed("select_subject"):
		if selected.size() == 0: is_visibile = true ; start_pos = get_local_mouse_position()
	if Input.is_action_just_released("select_subject"): is_visibile = false ; update()
	if event is InputEventMouseMotion and is_visibile: update()
	if worker_instance != null && placable:
		if event.is_action_pressed("select_subject"):
			place_building(worker_instance.get_team(), to_build_type)
			worker_instance.move_to(position)
			worker_instance = null
			return # not sure yet

func _draw():if is_visibile: draw_rect(Rect2(start_pos, get_local_mouse_position()), box_colour, false)

func place_building(team_no, to_build_type):
	var building = load("res://Buildings/" + building_matrix[to_build_type][1] + ".tscn")
	var building_instance = building.instance()
	building_instance.set_position(position)
	get_node("/root/World/YSort").add_child(building_instance)
	building_preview.hide()
	emit_signal("wait_building", false)
	disconnect("wait_building", worker_instance, "waits_building")

func get_selectable_object(): return selectable_object

func _on_Received_Building(building_type, worker):
	building_preview.show()
	to_build_type = building_type
	print(building_matrix[building_type][1])
	building_preview.set_texture(building_matrix[building_type][0])
	building_preview.set_scale(scale_building)
	worker_instance = instance_from_id(int(worker))
	if self.connect("wait_building", worker_instance, "waits_building"): _on_Error(46)
	emit_signal("wait_building", true)
	disconnect("wait_building", worker_instance, "waits_building")

func _on_Error(line):
	print("Error at line :" + str(line))
	get_tree().quit()

func _on_Area2D_area_entered(area):
	print("Colliding with " + area.get_name()) # manipulate shaders
	placable = false

func _on_Area2D_area_exited(_area):
	placable = true

func _on_Area2D2_area_entered(area):
	selectable_object = area.get_parent().get_node(".").get_instance_id()

# will cause problems on clustered objects
func _on_Area2D2_area_exited(_area):
	selectable_object = null
