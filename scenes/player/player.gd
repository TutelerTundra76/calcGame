class_name Player
extends RigidBody2D
@export_category("movement")
@export var speed:=100
@export var deceleration:=.25
@export var acceleration:=1.0
@export var maxSpeed:=500.0
@export var sprite:AnimatedSprite2D
var direction:=1

@export_category("wepon")
@export var ammoDisplay:Label
@export var arm:Node2D
@export var hand:Node2D
@onready var shootAnim := $armPivot/hand/shootAnimation
@onready var reload := $armPivot/hand/reload
@export var arrows:=20
var bullet :=preload("res://scenes/player/bullet.tscn")
var canShoot := true ## stops you from shooting a zillion arrows at once


@export_category('health')
@export var healthBar:ProgressBar
@export var maxHealth:=10
var health:=10


func _ready() -> void:
	Global.player=self
	Global.connectRewards()
	hit(0)#set health bar
func add_ammo():
	arrows+=5
	print(arrows)
func _physics_process(delta: float) -> void:
	var dir:=Input.get_vector("left","right","forward","back").normalized()
	checkAnimations(dir)
	%ProgressBar.value=100*(health/maxHealth)
	linear_velocity=lerp(linear_velocity,dir*maxSpeed,acceleration)
	
	arm.look_at(get_global_mouse_position())

	if dir==Vector2.ZERO:
		linear_velocity=lerp(linear_velocity,Vector2.ZERO,deceleration)
func _input(event: InputEvent) -> void:
	ammoDisplay.text="Arrows: %s"%arrows
	if event.is_action_pressed("shoot") and canShoot:
		arrows-=1
		shootAnim.stop()
		shootAnim.play("shoot")
		reload.start()
		canShoot = false
		var bull:RigidBody2D= bullet.instantiate()
		
		
		await reload.timeout #instead of waiting for the timer it just uses time
		bull.global_transform = hand.global_transform
		canShoot = true
		get_tree().root.add_child(bull)
		bull.fire(self, hand)
func checkAnimations(dir:Vector2):
	if dir.x<0 and direction==1:
		direction=-1
		sprite.flip_h=true
	elif dir.x>0 and direction==-1:
		direction=1
		sprite.flip_h=false
		
	if linear_velocity.length()>20 and sprite.animation!="run":
		sprite.play("run")
	elif linear_velocity.length()<=20 and sprite.animation!="idle":
		sprite.play("idle")
func hit(damage:int):
	health-damage
	healthBar.value=100*(health/maxHealth)
	healthBar.setHealthColor()
