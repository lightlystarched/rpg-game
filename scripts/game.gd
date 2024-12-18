extends Node2D
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.game_first_loadin == true:
		player.position.x = global.player_start_posx
		player.position.y = global.player_start_posy
	else:
		player.position.x = global.player_exit_cliffside_posx
		player.position.y = global.player_exit_cliffside_posy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()


func _on_cliffside_transition_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_cliffside_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "Game":
			get_tree().change_scene_to_file("res://scenes/cliffside.tscn")
			global.finish_scene_change()
