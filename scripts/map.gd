extends Node2D

@export var spawnHolder:Node2D
@export var spawnTim:Timer
@export var enemyHolder:Node2D
@onready var ENEMY=preload("res://scenes/skeleton.tscn")
var uppertime:=5.0
var spawnPoints:Array[Node2D]
func _ready() -> void:
	
	for i in spawnHolder.get_children():
		if i is Node2D:
			spawnPoints.append(i)

func spawn():
	print("spawn")
	var location=randi_range(0,spawnPoints.size()-1)
	var en=ENEMY.instantiate()
	en.global_position=spawnPoints[location].global_position
	enemyHolder.add_child(en)




func _on_timer_timeout() -> void:
	spawn()
	spawnTim.start(randf_range(3,uppertime))
	if uppertime<3.0:
		uppertime-=.1
