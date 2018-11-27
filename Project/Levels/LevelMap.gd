extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var Buttons;
var sizeOn = Vector2(1.5,1.5);
var sizeOff = Vector2(1.2,1.2);


func _ready():   
	Buttons = get_children();
	for i in range(1, Buttons.size()):  
		Buttons[i].get_child(0).modulate = Color(0,0,0,255); 
		Buttons[i].get_child(0).scale = sizeOff;
	pass

func _process(delta):  
	for i in range(1, Buttons.size()):  
		Buttons[i].visible = CanPlay(i-1);  
	pass

func CanPlay(id): 
	return true;#get_parent().ActualLevelCompleted >= id;
	pass

func _on_Level1_1_pressed():
	var id = 0;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level1_2_pressed():
	var id = 1;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level1_3_pressed():
	var id = 2;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level3_5_pressed():
	var id = 14;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level3_4_pressed():
	var id = 13;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level3_2_pressed():
	var id = 11;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level3_3_pressed():
	var id = 12;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level3_1_pressed():
	var id = 10;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level2_5_pressed():
	var id = 9;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level2_4_pressed():
	var id = 8;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level2_2_pressed():
	var id = 6;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level2_3_pressed():
	var id = 7;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level1_5_pressed():
	var id = 4;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level2_1_pressed():
	var id = 5;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level1_4_pressed():
	var id = 3;
	if(CanPlay(id)):
		get_parent()._loadLevel(id)
	pass # replace with function body


func _on_Level1_1_mouse_entered():
	find_node("Level1_1").get_child(0).scale = sizeOn;
	pass # replace with function body


func _on_Level1_1_mouse_exited(): 
	find_node("Level1_1").get_child(0).scale = sizeOff;
	pass # replace with function body
