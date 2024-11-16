extends Node

var player_current_attack = false
var current_scene = "Game"
var transition_scene = false

# player variables
var player_exit_cliffside_posx = 116
var player_exit_cliffside_posy = -16
var player_start_posx = 155
var player_start_posy = 108
var game_first_loadin = true

var last_position = {
	"x": 0,
	"y": 0
}

func finish_scene_change():
	game_first_loadin = false
	if transition_scene == true:
		transition_scene = false
	if current_scene == "Game":
		current_scene = "Cliffside"
	else:
		current_scene = "Game"
