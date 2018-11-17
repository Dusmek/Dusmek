extends Node2D

var Level   
var TimeOut;
var Bye = false;

func _process(delta):
	if Bye :
		if TimeOut > 0:
			TimeOut -= delta;
		else:
			Bye = false;
			get_tree().quit()
	pass

func Generate(level): 
	Level = level
	pass
	 
func TurnOn():  
	if( Level ):
		get_parent().DisablePlayerInput = true;
	visible = true;
	pass

func _on_Yes_pressed():      
	if(Level):
		visible = false; 	 
		get_parent().DialogWidgetInstance.TurnOff();
		get_parent().DisablePlayerInput = false; 
		get_parent()._showMap()
	else:   
		if( !Bye ):
			get_parent().DialogWidgetInstance.TurnOn("Bye... : C");
			Bye = true;
			TimeOut = 4;
	pass 


func _on_No_pressed():    
	if( Level): 
		get_parent().DisablePlayerInput = false;
	visible = false;  
	pass
