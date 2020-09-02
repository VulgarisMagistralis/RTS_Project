extends CanvasLayer
#
#var is_visibile = false
#var mouse_pos = Vector2()
#var start_pos = Vector2()
#var top = Vector2()
#var bot = Vector2()
#const box_colour = Color(0.5,1,1) # assign team_color
#const box_line_width = 1
##BOX
#
#func _input(event):
#	if event is InputEventMouseMotion: mouse_pos = event.position
##	if worker_instance != null || placable:
##		if event.is_action_just_pressed("select_subject"):
##			place_building(worker_instance.get_team())
##			worker_instance.move_to(position)
##			worker_instance = null
##			return # not sure yet
#	if Input.is_action_just_pressed("select_subject"): # called once
#		start_pos = mouse_pos
#	if Input.is_action_pressed("select_subject"): 
#		is_visibile = true 
#		#mouse_pos = get_local_mouse_position()
#	if Input.is_action_just_released("select_subject"): 
#
#		is_visibile = false
#
#func _draw():
#	if is_visibile:
#		bot = Vector2(start_pos.x, mouse_pos.y)
#		top = Vector2(mouse_pos.x, start_pos.y)
#		draw_line(start_pos, mouse_pos, box_colour, box_line_width, false)
#		#draw_line(start_pos, bot, box_colour, box_line_width, false)
#		#draw_line(mouse_pos, top, box_colour, box_line_width, false)
#		#draw_line(mouse_pos, bot, box_colour, box_line_width, false)
