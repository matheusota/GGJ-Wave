extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var config = [[false, 0],[false, 0],[false, 0],[false, 0]]
onready var players = 0
onready var current_player = 0

func select_number(n):
	get_node("SimpleTextMenu").set_menu(false)
	players = n + 1
	current_player += 1
	get_node("players").get_child(current_player-1).show()
	get_node("players").get_child(current_player-1).set_menu(true)

func control_selected(n):
	get_node("players").get_child(current_player-1).set_menu(false)
	var control = 0
	if n == 0:
		control = 2
	elif n == 1:
		control = 1
	elif n == 2:
		control = 0
	elif n == 3:
		control = 3
	config[current_player-1][0] = true
	config[current_player-1][1] = control
	if current_player == players:
		get_node("/root/global")._player_config = [] + config
		get_node("/root/global").change_scene(get_parent(), "res://scenes/world.tscn")
	else:
		current_player += 1
		get_node("players").get_child(current_player-1).show()
		get_node("players").get_child(current_player-1).set_menu(true)

func _ready():
	hide()
	get_node("SimpleTextMenu").set_menu(false)
	for i in get_node("players").get_children():
		i.set_menu(false)
		i.hide()
		i.connect("option_selected", self, "control_selected")
	get_node("SimpleTextMenu").connect("option_selected", self, "select_number")
	pass

func enable():
	get_node("SimpleTextMenu").set_menu(true)
	show()