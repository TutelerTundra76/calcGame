extends Node

func restart() -> void:
	Global.points = 0
	Global.correct = 0
	get_tree().reload_current_scene()
