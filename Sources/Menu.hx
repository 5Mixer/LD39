package ;

class Menu extends Scene {
	var frame = 0;
	override public function render(fb:kha.Framebuffer){
		frame++;
		var g = fb.g2;
		g.begin(true,kha.Color.fromBytes(130,200,100));
		g.color = kha.Color.Black;
		g.font = kha.Assets.fonts.OpenSans;
		g.fontSize = 80;
		g.drawString("Little Nations Of Power.",30,30);
		g.fontSize = 40;
		g.drawString("Win the war before you run out of power - respect and gold.",30,200);
		g.end();

		if (frame == 200){
			new Project();
		}
	}
}