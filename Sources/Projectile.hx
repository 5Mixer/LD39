package ;

class Projectile {
	public var pos:kha.math.Vector2;
	var velocity:kha.math.Vector2;
	public var life = 180;
	var friction = .9999;
	public var fromNation:String;
	public function new (pos:kha.math.Vector2){
		this.pos = pos;
		velocity = new kha.math.Vector2();
	}
	public function update (){
		life--;
		pos = pos.add(velocity);
		velocity = velocity.mult(friction);
	}
	public function render(g:kha.graphics2.Graphics){
		g.drawRect(pos.x,pos.y,1,1);
	}
	public function setVelocityFromAngle (angle:Float,speed:Float){
		velocity.x = Math.cos(angle)*speed;
		velocity.y = Math.sin(angle)*speed;
	}
}