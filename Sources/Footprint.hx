package ;

class Footprint extends Particle {
	var size = 1;
	public var toPos:kha.math.Vector2;
	override public function new (pos){
		super(pos);
		life = 50 + Math.floor(Math.random() * 10);
	}
	override public function render(g:kha.graphics2.Graphics){
		g.color = kha.Color.fromBytes(70,100,70);
		g.drawLine(pos.x,pos.y,toPos.x,toPos.y);
		g.color = kha.Color.White;
	}
	override public function update (){
		super.update();
	}
}