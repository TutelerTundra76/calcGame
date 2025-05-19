extends Control
@export var ques:question
@export var questionfolder:="res://questions/"
@onready var style = preload("res://theme.tres")

func _ready() -> void:
	var files:Array[question]
	for file in DirAccess.open(questionfolder).get_files():
		files.append(load(questionfolder+file))
	ques=files[randi_range(0,len(files)-1)]
	%RichTextLabel.text=ques.questionText
	for i in ques.answers:
		var check=CheckBox.new()
		check.theme=style
		check.text=i
		%VBoxContainer.add_child(check)
