extends ProgressBar
var health:StyleBox=preload("res://tres/health.tres")
func setHealthColor() -> void:
	health.bg_color=Color(1-value/100,value/100,0,1)
