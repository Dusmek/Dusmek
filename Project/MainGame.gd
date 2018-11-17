extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var MenuModeClass = load("res://MenuMode.tscn")
var GameModeClass = load("res://GameMode.tscn")
var CredModeClass = load("res://Credits.tscn")
var MenuMode
var GameMode
var CredMode
#to game mode będzie odpowiedzialny za odpalanie odpowiedniej mapy: będzie je sobie wczytywał odpowiednio

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	_showMenu()
	pass


func _showMenu():
	if (MenuMode == null):
		if (GameMode != null):
			remove_child(GameMode)
			GameMode = null
		if (CredMode != null):
			remove_child(CredMode)
			CredMode = null
		MenuMode = MenuModeClass.instance()
		add_child(MenuMode)
	pass
	
func _showGame():
	if (GameMode == null):
		remove_child(MenuMode)
		MenuMode = null
		GameMode = GameModeClass.instance()
		add_child(GameMode)
	pass

func _showCredits():
	if (CredMode == null):
		remove_child(MenuMode)
		MenuMode = null
		CredMode = CredModeClass.instance()
		add_child(CredMode)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
