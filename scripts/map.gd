extends Node2D

@export var spawnHolder:Node2D
@export var enemyHolder:Node2D
@onready var ENEMY=preload("res://scenes/skeleton.tscn")
var spawnPoints:Array[Node2D]
func _ready() -> void:
	for i in spawnHolder.get_children():
		if i is Node2D:
			spawnPoints.append(i)
	#while true:
		#if not get_tree().paused:
			#await get_tree().create_timer(randi_range(3,5)).timeout
			#spawn()
	
func spawn():
	print("spawn")
	var location=randi_range(0,spawnPoints.size()-1)
	var en=ENEMY.instantiate()
	en.global_position=spawnPoints[location].global_position
	enemyHolder.add_child(en)
