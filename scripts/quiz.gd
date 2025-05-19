extends Control

var ques:question## active question
# the folder where the questions are 
@export var questionfolder:="res://questions/" ## the path to the questions
@onready var style = preload("res://theme.tres")  ## the style to apply to everything

var boxes :Array[CheckBox] ## the check boxes
var state:=-1## the curent button checked
func _ready() -> void:
	
	var files:Array[question]
	for file in DirAccess.open(questionfolder).get_files():
		files.append(load(questionfolder+file))
	ques=files[randi_range(0,len(files)-1)]
	%RichTextLabel.text=ques.questionText
	
	#scramble the answers
	var avalibleIndexes:Array[int]
	for i in len(ques.answers):
		avalibleIndexes.append(i)
	
	for i in len(ques.answers):
		var ind := randi_range(0,len(avalibleIndexes)-1)
		var check :=CheckBox.new()
		boxes.append(check)
		check.pressed.connect(_on_check_box_pressed)
		check.theme=style
		check.text=ques.answers[avalibleIndexes[ind]]
		avalibleIndexes.pop_at(ind)
		%VBoxContainer.add_child(check)



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


func _on_next_button_pressed() -> void:
	if state!=-1:
		if ques.answers[0]==boxes[state].text:
			print("correct")
