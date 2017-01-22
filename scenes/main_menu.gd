extends Control

func show_menu():
	get_node("SimpleTextMenu").show()
	get_node("SimpleTextMenu").set_menu(true)

func _ready():
	get_node("SimpleTextMenu").connect("option_selected", self, "_option_selected")
	pass

func _option_selected(o):
	if o == 0:
		print("start")