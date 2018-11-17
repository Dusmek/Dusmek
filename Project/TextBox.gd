extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var CharTimer = 0;
var GoToText = "";
var ActuralText = ""; 
var CharIndex = 0; 
	
var Level;

func Generate(level):
	Level = level;  
	pass
	
func _process(delta): 
	if CharIndex < GoToText.length(): 
		if( CharTimer > 0 ):
			CharTimer -= delta;
		else:
			CharTimer = 0.05; 
			ActuralText += GoToText[CharIndex];
			find_node("Node2D").text = ActuralText; 
			CharIndex+=1;  
	pass 
	
func TurnOff():
	
	CharTimer = 0;
	GoToText = "";
	ActuralText = ""; 
	CharIndex = 0; 
	
	find_node("Node2D").text = ""; 
	if(Level):
		 get_parent().DisablePlayerInput = false;
	#visible = false;
	pass
	
	
func TurnOn(StringText): 
	
	if(Level):
		get_parent().DisablePlayerInput = true; 
	GoToText = StringText;
	CharTimer = 0;
	ActuralText = ""; 
	CharIndex = 0; 
	pass