extends Control

func show_menu():
	get_node("SimpleTextMenu").show()
	get_node("SimpleTextMenu").set_menu(true)
	get_node("SamplePlayer").play("menu_ost")

func _ready():
	get_node("SimpleTextMenu").connect("option_selected", self, "_option_selected")
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if Input.is_key_pressed(KEY_G):
		if get_node("God").is_hidden():
			get_node("God").show()
		else:
			get_node("God").hide()

func enable():
	get_node("SimpleTextMenu").set_menu(true)

func _option_selected(o):
	if o == 0:
		get_node("control_menu").enable()
	elif o == 1:
		get_node("credits").enable()
	elif o == 2:
		get_tree().quit()
	get_node("SimpleTextMenu").set_menu(false)