extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
