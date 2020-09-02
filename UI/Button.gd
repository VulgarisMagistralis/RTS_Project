extends Button


func _ready():
	var theme = Theme.new()
	theme.set_color("font_color","Button",Color(0,0,1))
	self.set_theme(theme)
func _on_Button_pressed():
	self.text = "STARTED"


func _on_Button_mouse_entered():
	self.add_color_override("font_color_hover",Color(0,0,0))
