package ;

class BloodParticle extends Particle {
	override public function new (pos){
		super(pos);
		velocity = new kha.math.Vector2((Math.random()*4)-2,Math.random()*.5);
		life = 3 + Math.floor(Math.random() * 5);
	}
	override public function render(g:kha.graphics2.Graphics){
		g.color = kha.Color.Red;
		g.pushTransformation(g.transformation);
		g.transformation._00 = 1;
		g.transformation._11 = 1;
		g.drawLine(pos.x*4,pos.y*4,(pos.x-velocity.x)*4,(pos.y-velocity.y)*4);
		g.popTransformation();
	}
	override public function update (){
		super.update();
		velocity.y += 1;
	}
}