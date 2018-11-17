extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready(): 
	pass
	
func _process(delta):
	if(frame==39):
		visible = false;
		playing = false; 
	pass

func CallFade(): 
	frame = 0;	 
	visible = true; 
	playing = true;
	pass