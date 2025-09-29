extends Line2D
const ARIAL = preload("res://Images/ARIAL.TTF")

@export var n_points = 10
@export var tension = 1.0
@export var roughness = 15.0
@export var distance = 10.0
@onready var target: Node2D = $Target
var c_points = []

class point:
	var tension_mag := 1.0
	var roughness_mag := 1.0
	var damp := 1.0
	
	var line:Line2D
	var next:point
	var last:point
	var index:int
	var anchor:Node2D
	var tension:float = 0
	var target = Vector2.ZERO
	var position:Vector2 = Vector2.ZERO
	func _init(pos,index,line:Line2D,ts,rg,dp) -> void:
		self.line = line
		position = pos
		self.index = index
		line.add_point(pos)
		tension_mag = ts
		roughness_mag = rg
		damp = dp
	
	func process(delta:float):
		if not last or not next: 
			upd_anchor() 
			return
		var gravity_vector : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
		var gravity_magnitude : int = ProjectSettings.get_setting("physics/2d/default_gravity")
		var true_grav = gravity_vector*gravity_magnitude
		position+=true_grav*delta
		target = (last.position+next.position)/2
		var dir = target-position
		
		tension = clamp(lerpf(tension,dir.length()/4 * tension_mag,roughness_mag*delta),0,10)
		position += (dir)/damp * tension
		
		updatePos()
		
	func updatePos():
		line.set_point_position(index,position)
		
	func upd_anchor():
		position = line.to_local(anchor.global_position)
		updatePos()

func start() -> void:
	var last = null
	for i in range(n_points):
		var pos = Vector2.ZERO.lerp(to_local(target.position),float(i)/n_points)
		var new_p = point.new(pos,i,self,tension,roughness,distance)
		
		c_points.push_back(new_p)
		if last:
			last.next = new_p
			new_p.last = last
		else:
			new_p.anchor = self
		if i==n_points-1:
			new_p.anchor = target
		last = new_p

func _physics_process(delta: float) -> void:
	for p in c_points:
		pass
		p.process(delta)
	#target.position = get_global_mouse_position()
	
	#position+=Input.get_vector("left","right","up","down")*3

func _draw() -> void:
	for p in c_points:
		pass
		#draw_string(ARIAL,p.position,str(p.tension))
		#draw_circle(p.target,1,Color(1,0,0,0.3))
