extends Control

func _ready():
	hide()
	get_node("SimpleTextMenu").set_menu(false)
	get_node("SimpleTextMenu").connect("option_selected", self, "option_selected")
	pass

func enable():
	show()
	get_node("SimpleTextMenu").set_menu(true)

func option_selected(o):
	get_node("SimpleTextMenu").set_menu(false)
	get_parent().enable()
	hide()