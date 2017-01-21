extends Node

onready var _players_scores = [0, 0, 0, 0]
onready var _match_timer = 60

onready var _player_config = [] # [{"playing": true/false, "control": 0-3}]

func set_player_config(conf):
	_player_config = conf

func add_score(player, score):
	_players_scores[player] += score
	emit_signal("score_update", player)

func _ready():
	add_user_signal("score_update")
	pass
