package ;

class Menu extends Scene {
	var frame = 0;
	override public function render(fb:kha.Framebuffer){
		frame++;
		var g = fb.g2;
		g.begin(true,kha.Color.fromBytes(130,200,100));
		g.color = kha.Color.fromBytes(27,38,50);
		g.font = kha.Assets.fonts.mini;
		g.fontSize = 20*Camera.zoom;
		g.drawString("Little Nations Of Power.",30,30);
		g.fontSize = 10*Camera.zoom;
		g.drawString("A losing army turns to you as a leader, in the hope that your strategy will win the war.",30,200);
		g.drawString("You know of two forms of power, respect and gold. You have both.",30,240);
		g.drawString("Allocate your citizens to overthrow the enemy, but be careful, it is only through respect and gold that they will not overthrow you!.",30,280);
		g.end();

		if (frame == 200){
			new Project();
		}
	}
}