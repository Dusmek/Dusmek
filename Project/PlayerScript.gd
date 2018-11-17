extends KinematicBody2D

# class member variables go here, for example:
	   
	
	
var Dead = false;
var DeadTimer = 0;

var InputTime = 0;
	
var MirrorCharacter = false;    
var currentDirection = Vector2(0,0);

var Reverted = false;

var LastPos

func _ready(): 
	LastPos = get_position()
	pass

func _process(delta): 
	
	if Dead: 
		if DeadTimer > 0:
			DeadTimer -= delta; 
		else:
			get_parent()._reloadLevel();
			
	
	_Overlaping(); 
	
	if (LastPos!=get_position()):
		var angle = get_position().angle_to_point(LastPos)
		var sp = find_node("Sprite")
		var l = 0.45
		if (angle - sp.get_rotation() > PI):
			sp.set_rotation((l*(angle - 2*PI)+(1-l)*sp.get_rotation()))
		elif (angle - sp.get_rotation() < -PI):
			sp.set_rotation(l*angle+(1-l)*(sp.get_rotation()-2*PI))
		else:
			sp.set_rotation((l*angle+(1-l)*sp.get_rotation()))
		LastPos = get_position();
	
	if InputTime > 0:
		InputTime -= delta;
		
	if( !Dead):
		if( InputTime <= 0 ):
			if( MirrorCharacter ):
				if( find_node("Sprite").animation != "IdleMirror"):
					find_node("Sprite").animation = "IdleMirror";
			else:
				if( find_node("Sprite").animation != "IdleNormal"):
					find_node("Sprite").animation = "IdleNormal";
	pass 

func _addInput(Direction, Mirror = false):
	
	if( !Dead):
		InputTime = 0.2;
		var speed = 40000;  
		if( Mirror && MirrorCharacter):
			currentDirection = Direction*get_parent().MirrorMovement*get_parent().StopMovement;
			move_and_slide(Direction*speed*get_parent().MirrorMovement*get_parent().StopMovement);  
		else:  
			if MirrorCharacter:
				currentDirection = Direction*get_parent().StopMovement;
				move_and_slide(Direction*speed*get_parent().StopMovement); 
			else: 	
				currentDirection = Direction;
				move_and_slide(Direction*speed); 
		 
	if( !Dead):
		if( MirrorCharacter ):
			if( find_node("Sprite").animation != "Mirror"):
				find_node("Sprite").animation = "Mirror";
		else:
			if( find_node("Sprite").animation != "Normal"):
				find_node("Sprite").animation = "Normal";
	  
	pass 
	
func _Generate(Mirror):
	Dead = false;
	MirrorCharacter = Mirror;
	if MirrorCharacter: 
		find_node("Sprite").animation = "Mirror";
		#find_node("Sprite").frame = randf() * 15;
	else: 
		find_node("Sprite").animation = "Normal";
	pass
	
func _Overlaping():
	var overlaps = find_node("Area2D").get_overlapping_areas();
	var noFlag = false;  
	var Revert = false;
	for overlap in overlaps: 
		match overlap.OverlapName:
			"flag": 
				noFlag = true;
				get_parent().SetFlag(MirrorCharacter, true); 
			"revert":
				Revert = true; 
				if( !Reverted ): 
					Reverted = true; 
					get_parent().MirrorMovement = -get_parent().MirrorMovement; 
			"kill":
				if( MirrorCharacter ):
					if( find_node("Sprite").animation != "DeathMirror"):
						find_node("Sprite").animation = "DeathMirror";
						Dead = true;
						DeadTimer = 4;
				else:
					if( find_node("Sprite").animation != "DeathNormal"):
						find_node("Sprite").animation = "DeathNormal";
						Dead = true;
						DeadTimer = 4; 
			 
	if( !noFlag && get_parent() != null):
		get_parent().SetFlag(MirrorCharacter, false); 
	if( !Revert ):
		Reverted = false;
	pass