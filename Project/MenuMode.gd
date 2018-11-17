extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var EscapeBox = load("res://EscapeYesNo.tscn")
var EscapeBoxInstance;

var DialogBox = load("res://TextBox.tscn") 
var DialogWidgetInstance;

func _ready():
	var EscapeBox_ = EscapeBox;
	EscapeBoxInstance = EscapeBox_.instance(); 
	add_child(EscapeBoxInstance);
	EscapeBoxInstance.Generate(false);
	EscapeBoxInstance.visible = false; 
	 
	var DialogWidget = DialogBox;
	DialogWidgetInstance = DialogWidget.instance();
	add_child(DialogWidgetInstance);
	DialogWidgetInstance.Generate(false);
	DialogWidgetInstance.TurnOff();
	
	pass
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.asdasd
#	# Update game logic here.
#	pass

func _on_StartGame_pressed():
	print("dzloki")
	get_parent()._showGame()
	pass # replace with function body

func _on_Credits_pressed():
	print("credits")
	get_parent()._showCredits()
	pass



func _on_Exit_pressed(): 
	EscapeBoxInstance.TurnOn();
	pass # replace with function body
