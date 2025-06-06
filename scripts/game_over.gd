class_name GameOver
extends CanvasLayer

func _ready():
	Global.gameOver = self
	print(Global.gameOver)
	hide()

func game_over() -> void:
	show()
	$Panel/VBoxContainer/youGotBlahBlah.text = "You got %s points, with %s correct answers"%[Global.points,Global.correct]
	Global.player.dead()

func _on_play_again_pressed():
	print("this should restart")
	get_node("/root/Main").restart()
