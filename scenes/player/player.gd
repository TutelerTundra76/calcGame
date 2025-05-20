extends RigidBody2D
@export var speed:=100
@export var deceleration:=.25
@export var arm:Node2D
@export var hand:Node2D
var bullet :=preload("res://scenes/player/bullet.tscn")
func _physics_process(delta: float) -> void:
	var dir:=Input.get_vector("left","right","forward","back")
	apply_central_force(dir* speed)
	
	arm.look_at(get_global_mouse_position())
	if dir==Vector2.ZERO:
		linear_velocity=lerp(linear_velocity,Vector2.ZERO,deceleration)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var bull:RigidBody2D= bullet.instantiate()
		bull.global_position= hand.global_position
		bull.rotation=arm.rotation
		get_tree().root.add_child(bull)
		
		
