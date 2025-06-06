@tool
extends Node
#for creating questions fast with AI
#make sure the names do not contain slashes

@export var run:= false :set = g ##this will run the tool
@export var seperator:String ##the seperator between values this is variable because complex seperators make it less likely for errors
@export var data:String ##data should be formated as:\n "name1,question1,corectAnswer1,wrongAnswer1,wrongAnswer1,wrongAnswer1,name2,question2,corectAnswer2,wrongAnswer2,wrongAnswer2,wrongAnswer2,..."
@export var quest:qh
var files:Array[question]

@export var questionfolder:="res://questions/"

func decypher(_b):
	data.replace("\n","")
	var dataArray:=data.split(seperator,true,0)##breaks the aray in to a packed string aray
	for i in len(dataArray)/6:#quick bad soulution that takes data and organizes it into question resources
		var ques:=question.new()
		var Rname:=dataArray[0]
		dataArray.remove_at(0)
		ques.questionText=dataArray[0]
		dataArray.remove_at(0)
		for j in 4:
			ques.answers.append(dataArray[0])
			dataArray.remove_at(0)
		#quesArray.append(ques)
		ResourceSaver.save(ques,"res://questions/%s.tres" % Rname)

func g(_b):
	quest.questions=[]
	for file in DirAccess.open(questionfolder).get_files():
		quest.questions.append(load(questionfolder+file))
