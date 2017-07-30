package ;

class Particle {
	public var pos:kha.math.Vector2;
	var velocity:kha.math.Vector2;
	public var life = 30;
	var friction = .8;
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
}