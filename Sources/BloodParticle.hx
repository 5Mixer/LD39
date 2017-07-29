package ;

class BloodParticle extends Particle {
	var size = 1;
	override public function new (pos){
		super(pos);
		velocity = new kha.math.Vector2((Math.random()*4)-2,Math.random()*.5);
		life = 2 + Math.floor(Math.random() * 5);
		size = 1+Math.floor(Math.random()*3);
	}
	override public function render(g:kha.graphics2.Graphics){
		g.color = kha.Color.Red;
		g.fillRect(pos.x,pos.y,size,size);
		g.color = kha.Color.White;
	}
	override public function update (){
		super.update();
		velocity.y += .3;
	}
}