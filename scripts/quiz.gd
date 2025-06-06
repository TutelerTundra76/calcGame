class_name quiz
extends Control


var frame := 0.0 ## used for the background visuals
var minCorn = 4.0 ## also for visuals
var maxCorn = 20.0 ## also also for visuals
var visualConstant = 1 ## I dont know why this exists but I need it


var ques:question## active question
# the folder where the questions are 
@export var questionfolder:="res://questions/" ## the path to the questions
@export var anim:AnimationPlayer
@onready var style = preload("res://tres/theme.tres")  ## the style to apply to everything
@onready var qStyle = preload("res://tres/questionBackground.tres") ## stylebox specifically for the background

var boxes :Array[CheckBox] ## the check boxes
var state:=-1## the curent button checked
var files:Array[question]

signal correct

func _ready() -> void:
	
	#print("set")
	Global.quizNode=self
	Global.connectRewards()
	print(Global.quizNode)
	for file in DirAccess.open(questionfolder).get_files():
		files.append(load(questionfolder+file))
		

func get_question():
	ques=files[randi_range(0,len(files)-1)]
	%questionLabel.text=ques.questionText
	
	#scramble the answers
	var avalibleIndexes:Array[int]
	for i in len(ques.answers):
		avalibleIndexes.append(i)
	for i in %questionVContainer.get_children():
		i.queue_free()
	boxes=[]
	for i in len(ques.answers):
		var ind := randi_range(0,len(avalibleIndexes)-1)
		var check :=CheckBox.new()
		boxes.append(check)
		check.pressed.connect(_on_check_box_pressed)
		check.theme=style
		check.text=ques.answers[avalibleIndexes[ind]]
		avalibleIndexes.pop_at(ind)
		%questionVContainer.add_child(check)


func _process(delta):
	question_background_visuals(delta)


#make sure only one button is pressed


func _on_check_box_pressed() -> void:
	var found:bool
	#check every box to see if is checked and if it is the last answer or the new one
	#if it is the new answer it sets that as selected and turns the rest to false
	for i in range(len(boxes)):
		if boxes[i].button_pressed:
			if i!=state and !found:
				state=i
				found=true
			else:
				boxes[i].button_pressed=false


func question_background_visuals(delta: float) -> void:
	frame += delta
	var gumbus = 0.5 + (sin(frame * visualConstant) / 2)
	var smunk = 0.5 + (cos(frame * visualConstant * 3) / 2)
	qStyle.corner_radius_top_left = lerp(minCorn, maxCorn, gumbus)
	qStyle.corner_radius_top_right = lerp(maxCorn, minCorn, gumbus)
	qStyle.corner_radius_bottom_left = lerp(maxCorn, minCorn, gumbus)
	qStyle.corner_radius_bottom_right = lerp(minCorn, maxCorn, gumbus)
	qStyle.expand_margin_left = lerp(10, 20, smunk)
	qStyle.expand_margin_right = lerp(10, 20, smunk)
	qStyle.skew.x = lerp(0.10, 0.15, gumbus)
	
	add_theme_stylebox_override("the", qStyle)


func _on_exitbutton_pressed() -> void:
	%nextButton.text="submit"
	%exitbutton.visible=false
	Global.pause=false


func _on_next_button_pressed() -> void:
	print("clicked")
	if %nextButton.text=="submit":
		if state!=-1:
			if ques.answers[0]==boxes[state].text:
				anim.play("correct")
				Global.correct+=1
				correct.emit()
				%nextButton.text="next"
				%exitbutton.visible=true
			else:
				anim.play("wrong")
	elif %nextButton.text=="next":
		get_question()
		%nextButton.text="submit"
		%exitbutton.visible=false
