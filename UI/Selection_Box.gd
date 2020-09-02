extends Control

#var is_visibile = false
#var mouse_pos = Vector2()
#var start_pos = Vector2()
#var top = Vector2()
#var bot = Vector2()
#const box_colour = Color(0.5,1,1) # assign team_color
#const box_line_width = 1
#
#func _input(event):
#	if event is InputEventMouseMotion: mouse_pos = event.global_position
#	if Input.is_action_just_pressed("select_subject"): start_pos = mouse_pos
#	if Input.is_action_pressed("select_subject"): 
#		mouse_pos = mouse_pos
#		is_visibile = true 
#	else: is_visibile = false
#	if Input.is_action_just_released("select_subject"):pass
#
#func _draw():
#	if is_visibile and start_pos != mouse_pos:
#		bot = Vector2(start_pos.x, mouse_pos.y)
#		top = Vector2(mouse_pos.x, start_pos.y)
#		draw_line(start_pos, top, box_colour, box_line_width, false)
#		draw_line(start_pos, bot, box_colour, box_line_width, false)
#		draw_line(mouse_pos, top, box_colour, box_line_width, false)
#		draw_line(mouse_pos, bot, box_colour, box_line_width, false)
#
#func _physics_process(_delta):
#	update()
