extends KinematicBody2D

# class member variables go here, for example:
	   
#movement
var speedMax = 40000;
var speed = 0;
var Direction;
var InputTime = 0;
var InputMaxTime = 0.0001;
var AccelerationTime = 0;
var SlowingTime = 0;
var velocity = Vector2(0,0);
var direction = Vector2(0,0); 

var BodyPartPath = load("res://PlayerBodyPart.tscn");
var BodyParts = [];

var MirrorCharacter = false;    
var currentDirection = Vector2(0,0);

var Reverted = false;

var LastPos

func _ready():
	#for i in 20:
		#var part = BodyPartPath.instance() 
		#add_child(part) 

	LastPos = get_position()
	pass

func _process(delta): 
	  
	_Movement(delta);
	
	_Overlaping(); 
	
	if (LastPos!=get_position()):
		var angle = get_position().angle_to_point(LastPos)
		var sp = find_node("Sprite")
		var rot = sp.get_rotation()
		var l = 0.45
		if (angle - rot > PI):
			if (angle > 0):
				angle -= 2*PI;
			else:
				rot += 2*PI
		if (rot - angle > PI):
			if (rot > 0):
				rot -= 2*PI
			else:
				angle += 2*PI
		sp.set_rotation(l*angle+(1-l)*rot);
		LastPos = get_position();
	
		
	if(!get_parent().Dead):
		if( velocity.length_squared() <= 0 ):
			if( MirrorCharacter ):
				if( find_node("Sprite").animation != "IdleMirror"):
					find_node("Sprite").animation = "IdleMirror";
			else:
				if( find_node("Sprite").animation != "IdleNormal"):
					find_node("Sprite").animation = "IdleNormal";
	pass 

func _addInput(Direction, Mirror = false):
	
	if( !get_parent().Dead): 
		InputTime = InputMaxTime;
		speed = speedMax * AccelerationTime;    
		if MirrorCharacter:
			direction = (Direction+direction)/2;
			velocity = (direction*speed*get_parent().StopMovement); 
		else:
			direction = (Direction+direction)/2;
			velocity = (direction*speed); 
		  
		if( MirrorCharacter ):
			if( find_node("Sprite").animation != "Mirror"):
				find_node("Sprite").animation = "Mirror";
		else:
			if( find_node("Sprite").animation != "Normal"):
				find_node("Sprite").animation = "Normal";
	pass 
	
func _Generate(Mirror): 
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
				get_parent().SetDead(); 
		 
	if( !noFlag && get_parent() != null):
		get_parent().SetFlag(MirrorCharacter, false); 
	if( !Revert ):
		Reverted = false;
	pass
	
	
	
func _Movement(var delta):
	#timers
	if( InputTime >= InputMaxTime ):
		if( AccelerationTime < 1 ):
			AccelerationTime += delta * 4;
		else: 
			AccelerationTime = 1;
	else: 
		AccelerationTime = 0;
	
	#SlowingDown
	if InputTime > 0:
		InputTime -= delta;
	else:  
		if( velocity.length_squared() > 0):
			var velocityReduction = (velocity.normalized()*delta*(abs(velocity.length())))*5;
			if( velocity.length_squared() < 100):
				velocity = Vector2(0,0);
			else:
				velocity -= velocityReduction;
				
	#AnimationFPS base on speed 			
	if(velocity.length_squared() > 0):
		var animationSpeed = (velocity.length_squared()/(speedMax/20))*12;
		if( animationSpeed < 4 ):
			animationSpeed = 4;
		if( animationSpeed > 12 ):
			animationSpeed = 12; 
		if( MirrorCharacter ):		
			find_node("Sprite").get_sprite_frames().set_animation_speed("Mirror", animationSpeed);
		else:
			find_node("Sprite").get_sprite_frames().set_animation_speed("Normal", animationSpeed);
 
	if( !get_parent().Dead ):
		 move_and_slide(velocity); 
	pass
	 