extends Node2D

func _ready(): 
	pass

func _process(delta):
	find_node("Sprite").rotation_degrees += 120 * delta;
	pass
