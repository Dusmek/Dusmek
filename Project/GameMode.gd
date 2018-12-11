extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var NextLevelTimer = 0;
var CanNextLevel = false;

var ActualLevelCompleted = 1;
  
var FadeScreen = load("res://FadeScreen.tscn")
var FadeScreenInstance;

var EscapeBox = load("res://EscapeYesNo.tscn")
var EscapeBoxInstance;

var PlayerScene = load("res://Player.tscn")
var PlayerInst
var AntiPlayerInst
var Player
var AntiPlayer
var currLevelId = 0
var Level
var MapClass = load("res://Levels/LevelMap.tscn")
var MapInst

var DropScene = load("res://Drop.tscn")
var Drops = []

var MirrorMovement = -1.0;
var flagMirror = false;
var flagBase = false;
var StopMovement = 1;
var MaxSpeedDistance = 24000;
var Dead = false; 
var DeadTimer = 0; 
 
 
var DisablePlayerInput = false;

var Dialogs = ["","",""];
var DialogBox = load("res://TextBox.tscn") 
var DialogWidgetInstance;

var Levels = ["res://Levels/Level1_1.tscn", 
"res://Levels/Level1_2.tscn",  
"res://Levels/Level1_3.tscn",
"res://Levels/Level1_4.tscn",
"res://Levels/Level1_5.tscn",    
"res://Levels/Level2_1.tscn",  
"res://Levels/Level2_2.tscn",
"res://Levels/Level2_3.tscn",
"res://Levels/Level2_4.tscn",
"res://Levels/Level2_5.tscn",
"res://Levels/Level3_1.tscn",
"res://Levels/Level3_2.tscn",
"res://Levels/Level3_3.tscn",
"res://Levels/Level3_4.tscn",  
"res://Levels/Level3_5.tscn",
"res://Levels/LevelLevelEnd.tscn"]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#PlayerInst = PlayerScene.instance()
	#PlayerInst.set_name("Player")

	#AntiPlayerInst = PlayerScene.instance()
	#AntiPlayerInst.set_name("AntiPlayer") 
	 
	FadeScreenInstance = FadeScreen.instance(); 
	add_child(EscapeBoxInstance);
	 
	EscapeBoxInstance = EscapeBox.instance(); 
	add_child(EscapeBoxInstance);
	EscapeBoxInstance.Generate(true);
	EscapeBoxInstance.visible = false; 
	 
	DialogWidgetInstance = DialogBox.instance();
	add_child(DialogWidgetInstance);
	DialogWidgetInstance.Generate(true);
	DialogWidgetInstance.TurnOff();
	
	_showMap()
	#_spawnPlayers()
	pass 
	
	

func _spawnPlayers():
	 
	var PlayerStart = Vector2(100,100);
	var MirrorStart = Vector2(100,700);  
	
	match currLevelId:
		0: 
			PlayerStart = Vector2(100,400) 
		1, 2, 3:
			PlayerStart = Vector2(100,700) 
		4: 
			PlayerStart = Vector2(100,100) 
			
	match currLevelId:
		0,1,2,3,4: 
			MirrorStart = Vector2(-100,-100); 
		
	StopMovement = 1;
	match currLevelId: 
		0,1,2,3,4:
			StopMovement = 0;
	 
	MirrorMovement = -1.0;
	
	Dead = false;
	PlayerInst = PlayerScene.instance()
	AntiPlayerInst = PlayerScene.instance()
	add_child(PlayerInst)
	PlayerInst._Generate(false);  
	PlayerInst.set_global_position(PlayerStart)
	add_child(AntiPlayerInst)
	AntiPlayerInst._Generate(true);
	AntiPlayerInst.set_global_position(MirrorStart)
	
	
	#for i in range(100):
	#	Drops.push_back(DropScene.instance())
	#	Drops[i].set_global_position(PlayerStart)
	#	add_child(Drops[i])
	#	pass

func _despawnPlayers():
	remove_child(PlayerInst)
	remove_child(AntiPlayerInst)
	PlayerInst.queue_free()
	AntiPlayerInst.queue_free()
	PlayerInst = null
	AntiPlayerInst = null

func _nextLevel():
	_unloadLevel();
	ActualLevelCompleted+=1;
	currLevelId += 1
	_loadLevel(currLevelId)
	pass
	

#to moze byz zrobione bezpośrednio tylko z poziomu mapy: 
#więc istnieje mapa, możemy ją wyrzucic
#
func _loadLevel(id):
	currLevelId = id;
	if (MapInst != null):
		remove_child(MapInst)
		MapInst = null
	 
	#WYLACZAM NA RAZIE DIALOGI 
	#if( currLevelId == 0 || currLevelId == 1 || currLevelId == 2 ):
	#	DialogWidgetInstance.TurnOn(Dialogs[currLevelId]); 
	
	FadeScreenInstance.CallFade();
	
	#dodajemy nasz level
	var LevelClass = load(Levels[id])
	Level = LevelClass.instance()
	Level.set_name(Levels[id])
	add_child(Level)
	_spawnPlayers()
	pass

func _reloadLevel():
	_unloadLevel();
	_loadLevel(currLevelId);
	pass

#to jest metoda dodana po to żeby potem mogło się pojawić znikanie levelu ppłynnie
func _unloadLevel():
	#to poniżej zawsze się udaje
	if (Level != null):
		_despawnPlayers()
		remove_child(Level)
		Level = null
	pass

#metoda odpalana:
#albo na początku gamemode'a
#albo na wciśnięciu esc podaczas levelu
func _showMap():
	#sprawdzenie żeby było na 100%
	if (MapInst == null):
		if (Level == null):
			#jesteśmy tu z Menu
			print("weszliśmy do mapy z poziomu funkcji ready na poczatku gamemode")
		else:
			#jesteśmy z Levelu_
			_unloadLevel()
			
		MapInst = MapClass.instance()
		MapInst.set_name("LevelMap")
		add_child(MapInst)
	pass

func _process(delta):
	#Called every frame. Delta is time since last frame.
	#Update game logic here.
	
	if(Dead):
	 	if DeadTimer > 0:
				DeadTimer -= delta; 
			else:
				_reloadLevel();
	
	if CanNextLevel:
		if NextLevelTimer > 0: 
			NextLevelTimer -= delta; 
		else:
			CanNextLevel = false;
			_nextLevel(); 
	
	if( Input.is_action_just_pressed("SkipDialog")):
		DialogWidgetInstance.TurnOff();
	
	if Input.is_action_just_pressed("Escape"):
		if( Level != null ):
			EscapeBoxInstance.TurnOn();
		elif (MapInst != null):
			print("wyjdzmy")
			get_parent()._showMenu()
		else:
			_showMap()
			
	if (MapInst == null && !DisablePlayerInput):
		
		if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
			var inputVector = Vector2(0,0);
			#tu ponizej bardzo brzydki trik ze skalą
			var v = get_viewport().get_mouse_position() * get_parent().GameScale-PlayerInst.get_position()
			if (v.length_squared() > 1000): 	 
				var output = (v.length_squared())/ (MaxSpeedDistance);
				if( output > 1 ):
					output = 1;  
				elif(v.length_squared() > MaxSpeedDistance/2 && output < 0.5 ):
					output = 0.5;
				inputVector = v.normalized() * output * delta; 
				PlayerInst._addInput(inputVector);
				AntiPlayerInst._addInput(Vector2(inputVector.x, inputVector.y*MirrorMovement));
			 
				
		if Input.is_key_pressed(87): #w
			PlayerInst._addInput(Vector2(0,-1)*delta)
			AntiPlayerInst._addInput(Vector2(0,-1)*delta, true)
		if Input.is_key_pressed(83): #s
			PlayerInst._addInput(Vector2(0,1)*delta)
			AntiPlayerInst._addInput(Vector2(0,1)*delta, true)
		if Input.is_key_pressed(65): #a
			PlayerInst._addInput(Vector2(-1,0)*delta)
			AntiPlayerInst._addInput(Vector2(-1,0)*delta)
		if Input.is_key_pressed(68): #d
			PlayerInst._addInput(Vector2(1,0)*delta)
			AntiPlayerInst._addInput(Vector2(1,0)*delta)
		
		#for i in Drops.size():
		#	var dist = PlayerInst.get_position() - Drops[i].get_position()
		#	var vel = Drops[i].get_linear_velocity()
		#	Drops[i].add_force(Vector2(0,0), - vel*vel.length()/100)
		#	Drops[i].add_force(Vector2(0,0),rand_range(0.1,1.2) * 10000 * min(5, dist.length()/200) * dist.normalized());
#	else:
#		print("sterowanie dla mapy?")
	pass
	
func SetFlag(Index, State):
	if(Index):
		flagMirror = State;
	else:
		flagBase = State;
	
	if(flagMirror && flagBase):
		flagMirror = false;
		flagBase = false;    
		if( !CanNextLevel ): 
			CanNextLevel = true;
			NextLevelTimer = 0;
	pass
	
func SetDead():  
	if(!Dead):
		AntiPlayerInst.find_node("Sprite").animation = "DeathMirror"; 
		PlayerInst.find_node("Sprite").animation = "DeathNormal"; 
		Dead = true;
		DeadTimer = 4;   
	pass