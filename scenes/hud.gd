extends Control

onready var _global = get_node("/root/global")
onready var _time = 60

func reset():
	for i in range(_global._player_config.size()):
		if _global._player_config[i][0] == false:
			get_node("players").get_child(i).hide()

func _ready():
	set_fixed_process(true)
	_global.connect("score_update", self, "_score_updated")
	_global.connect("player_died", self, "_player_died")
	pass

func _score_updated(player):
	get_node("players").get_child(player).get_node("ScoreLabel").set_text("x " + str(_global._players_scores[player]))

func _player_died(player):
	get_node("players").get_child(player).get_node("ScoreLabel").set_text("x " + str(_global._players_scores[player]))

func _fixed_process(delta):
	var c_time = ceil(float(_global._match_timer))
	if c_time != _time:
		_time = c_time
		get_node("timer/Label").set_text(str(_time))
	pass