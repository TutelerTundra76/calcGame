extends Node

var points:=0
var correct:=0

var pause:=false : set= setPause
var quizNode:quiz
var player:Player
var gameOver:GameOver




func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func connectRewards():
	if quizNode and player:
		quizNode.correct.connect(player.add_ammo)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("question"):
		if get_tree().paused:
			pause=false
		else:
			pause=true


	if event.is_action_pressed("quit"):
		get_tree().quit()
func setPause(paused:bool):
	
	get_tree().paused=paused
	quizNode.visible=paused
	quizNode.get_question()

func game_over() -> void: #passes it on to the node
	gameOver.game_over()
