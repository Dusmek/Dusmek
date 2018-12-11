extends KinematicBody2D
#NOTE
#Sprite Offset was -40, 0
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


var RaycastContact = [0,0,0,0];

func _ready():
	#for i in 20:
		#var part = BodyPartPath.instance() 
		#add_child(part) 
	var rayLength = Vector2(0,36);
	find_node("RayCastUp").cast_to = (rayLength);
	find_node("RayCastRight").cast_to = (rayLength);
	find_node("RayCastDown").cast_to = (rayLength);
	find_node("RayCastLeft").cast_to = (rayLength);
	LastPos = get_position()
	pass

func _process(delta): 
	     
	var FirstPosition;
	if(MirrorCharacter):
		FirstPosition = get_parent().AntiPlayerInst.get_position();
	else:
		FirstPosition = get_parent().PlayerInst.get_position();
		
		
	_Movement(delta);
	_Overlaping(); 
	
	if find_node("RayCastUp").is_colliding(): 
		RaycastContact[0] = 1;
	else:
		RaycastContact[0] = 0;	
		
	if find_node("RayCastRight").is_colliding(): 
		RaycastContact[1] = 10;
	else:
		RaycastContact[1] = 0;	
		
	if find_node("RayCastDown").is_colliding(): 
		RaycastContact[2] = 100;
	else:
		RaycastContact[2] = 0;	
		
	if find_node("RayCastLeft").is_colliding(): 
		RaycastContact[3] = 1000;
	else:
		RaycastContact[3] = 0;	
		 
	
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
	
	var SecondPosition;
	if(MirrorCharacter):
		SecondPosition = get_parent().AntiPlayerInst.get_position();
	else:
		SecondPosition = get_parent().PlayerInst.get_position();
		
	var MovedDistance = (SecondPosition - FirstPosition).length();
	
	if(!get_parent().Dead):
		if( velocity.length_squared() <= 0 ):
			if( MirrorCharacter ):
				if( find_node("Sprite").animation != "IdleMirror"):
					find_node("Sprite").animation = "IdleMirror";
			else: 
				if( find_node("Sprite").animation != "IdleNormal"):
					find_node("Sprite").animation = "IdleNormal"; 
		if( MovedDistance <= 0.05 ): 
			var ContactType = 0;
			for i in range(0, RaycastContact.size()):
				ContactType += RaycastContact[i]; 
			match ContactType:
				11:
					find_node("Sprite").set_rotation(PI/2);
					_setAnimationIdleCorner();
				110:
					find_node("Sprite").set_rotation(PI);
					_setAnimationIdleCorner();
				1100:
					find_node("Sprite").set_rotation(PI*3/2);
					_setAnimationIdleCorner();
				1001:
					find_node("Sprite").set_rotation(0);
					_setAnimationIdleCorner();
				1:
					find_node("Sprite").set_rotation(PI);
					_setAnimationIdleWall();
				10:
					find_node("Sprite").set_rotation(PI*3/2);
					_setAnimationIdleWall();
				100:
					find_node("Sprite").set_rotation(0);
					_setAnimationIdleWall();
				1000:
					find_node("Sprite").set_rotation(PI/2);
					_setAnimationIdleWall();
		if(velocity.length_squared() > 0):
			var ContactType = 0;
			for i in range(0, RaycastContact.size()):
				ContactType += RaycastContact[i]; 
			match ContactType:  
				1:
					find_node("Sprite").set_rotation(PI);
					_setAnimationIdleWall();
				10:
					find_node("Sprite").set_rotation(PI*3/2);
					_setAnimationIdleWall();
				100:
					find_node("Sprite").set_rotation(0);
					_setAnimationIdleWall();
				1000:
					find_node("Sprite").set_rotation(PI/2);
					_setAnimationIdleWall(); 
	pass 

func _setAnimationIdleWall():
	if( velocity.length_squared() > 0 ):
		if( MirrorCharacter ):
			if( find_node("Sprite").animation != "IdleWallMirror"):
				find_node("Sprite").animation = "IdleWallMirror"; 
		else: 
			if( find_node("Sprite").animation != "IdleWall"):
				find_node("Sprite").animation = "IdleWall"; 
	else:
		if( MirrorCharacter ):
			if( find_node("Sprite").animation != "MoveWallMirror"):
				find_node("Sprite").animation = "MoveWallMirror"; 
		else: 
			if( find_node("Sprite").animation != "MoveWall"):
				find_node("Sprite").animation = "MoveWall"; 
	pass
	
func _setAnimationMoveWall():
	if( MirrorCharacter ):
		if( find_node("Sprite").animation != "MoveWallMirror"):
			find_node("Sprite").animation = "MoveWallMirror"; 
	else: 
		if( find_node("Sprite").animation != "MoveWall"):
			find_node("Sprite").animation = "MoveWall"; 
	pass
func _setAnimationIdleCorner():
	if( MirrorCharacter ):
		if( find_node("Sprite").animation != "IdleCornerMirror"):
			find_node("Sprite").animation = "IdleCornerMirror"; 
	else: 
		if( find_node("Sprite").animation != "IdleCorner"):
			find_node("Sprite").animation = "IdleCorner"; 
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
	 