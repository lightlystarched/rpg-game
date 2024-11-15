extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scene_change()


func _on_cliffside_exit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func _on_cliffside_exit_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false

func scene_change():
	if global.transition_scene == true:
		if global.current_scene == "Cliffside":
			get_tree().change_scene_to_file("res://scenes/game.tscn")
			global.finish_scene_change()
