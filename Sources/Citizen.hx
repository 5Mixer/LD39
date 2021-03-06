package ;

class Citizen {
	public var pos:kha.math.Vector2;
	public var returnToLocation:kha.math.Vector2;
	public var returnToTile:kha.math.Vector2i;
	public var activity:Void->Void;
	public var fromNation:String;
	public var nation:NationGrid;
	public var tileType:NationGrid.Tile = null;
	var project:Project;
	public var frame = 0;
	public var velocity:kha.math.Vector2;
	public var health = 100.;
	var speed = 1.;
	public var returned = false;
	public function new (project:Project){
		pos = new kha.math.Vector2();
		velocity = new kha.math.Vector2();
		activity = idle;
		speed = .5+Math.random();
		this.project = project;
	}
	public function update (){
		activity();
		pos = pos.add(velocity);
		velocity = velocity.mult(.9);
		frame++;
	}
	public function render(g:kha.graphics2.Graphics){

	}
	function idle () {

	}
	function returning (){
		if (returnToLocation.sub(pos).length < 3){
			returned = true;
			velocity = velocity.mult(0);
			pos = returnToLocation;
			return;
		}
		var vector = returnToLocation.sub(pos);
		vector.normalize();
		velocity = vector.mult(speed*1);
		// returned = true;
		// pos = returnToLocation;
	}
}