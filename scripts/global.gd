extends Node

var player_current_attack = false
var current_scene = "Game"
var transition_scene = false

# player variables
var player_exit_cliffside_posx = 0
var player_exit_cliffside_posy = 0
var player_start_posx = 0
var player_start_posy = 0

func finish_scene_change():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "Game":
			current_scene = "Cliffside"
		else:
			current_scene = "Game"
