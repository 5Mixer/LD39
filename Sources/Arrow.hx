package ;

import kha.math.FastMatrix3;

class Arrow extends Projectile{
	public var angle = 0.;
	override public function render(g:kha.graphics2.Graphics){
		if (angle != 0) g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(pos.x + 8, pos.y + 8)).multmat(FastMatrix3.rotation(angle)).multmat(FastMatrix3.translation(-pos.x - 8, -pos.y - 8)));
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,0,16,16,16);
		if (angle != 0) g.popTransformation();
	}
}