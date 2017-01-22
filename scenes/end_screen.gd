extends Control

onready var _global = get_node("/root/global")

func _ready():
	get_node("SimpleTextMenu").connect("option_selected", self, "_option_selected")
	get_node("SamplePlayer").play("menu_ost")
	
	# Check which player has highest high-score
	var p = 0
	for i in range(_global._players_scores.size()):
		if _global._players_scores[i] > _global._players_scores[p]:
			p = i
	
	get_node("Control/Label").set_text("Player " + str(p+1))
	
	pass

func _option_selected(o):
	_global.change_scene(self, "res://scenes/main_menu.tscn")