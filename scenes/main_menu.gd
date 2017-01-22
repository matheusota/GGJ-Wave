extends Control

func show_menu():
	get_node("SimpleTextMenu").show()
	get_node("SimpleTextMenu").set_menu(true)
	get_node("SamplePlayer").play("menu_ost")

func _ready():
	get_node("SimpleTextMenu").connect("option_selected", self, "_option_selected")
	pass

func _option_selected(o):
	get_node("SamplePlayer").play("splash")
	if o == 0:
		get_node("/root/global").change_scene(self, "res://scenes/world.tscn")