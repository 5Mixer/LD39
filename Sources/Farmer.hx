package ;

class Farmer extends Citizen {
	override public function new (project){
		super(project);
		tileType = NationGrid.Tile.Farmer;
		returned = true;
	}
	override public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,3*16,0,16,16);
	}
	
	override function idle () {
		
	}
}