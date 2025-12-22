extends Camera2D

var defaultX=1
var defaultY=1

func zoom_out():
	#.625
	if(zoom.x>.4&&zoom.y>.4):
		zoom.x+=-.002
		zoom.y+=-.002

func zoom_in1():
	if(zoom.x<=1&&zoom.y<=1):
		zoom.x+=.0042
		zoom.y+=.0042

func zoom_in2():
	if(zoom.x<=1&&zoom.y<=1):
		zoom.x+=.006
		zoom.y+=.006

func zoom_in3():
	if(zoom.x<=1&&zoom.y<=1):
		zoom.x+=.008
		zoom.y+=.008

func reset():
	zoom.x=defaultX
	zoom.y=defaultY

func stop():
	zoom.x=zoom.x
	zoom.y=zoom.y
