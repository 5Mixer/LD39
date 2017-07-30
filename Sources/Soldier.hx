package ;

class Soldier extends Citizen {
	var closest:Citizen = null;
	var dist = Math.POSITIVE_INFINITY;
	var attacking:Citizen;
	var damage = .25;
	var maxKills = 1;
	var kills = 0;
	override public function new (project){
		super(project);
		tileType = NationGrid.Tile.Soldier;
		activity = idle;
		maxKills = Math.floor(Math.random() * 2);
		damage = .7+Math.random();
		speed = 1+Math.random();
	}
	override public function render(g:kha.graphics2.Graphics){
		// if (activity == returning || returned) g.color = kha.Color.Red;
		//-Math.abs(Math.sin(frame/3)*5)
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,16,0,16,16);
		g.color = kha.Color.White;
	}
	override public function update (){
		super.update();
		if (frame % 5 == 0 && velocity.length > .7 && !returned){
			var footPos = pos.add(new kha.math.Vector2(Math.floor(Math.sin(frame/2.5)*4)+4,7));
			var foot = new Footprint(footPos);
			var vfoot = velocity.mult(1);
			vfoot.normalize();
			vfoot = vfoot.mult(2);
			foot.toPos = foot.pos.add(vfoot);
			project.particles.push(foot);
			
		}
	}
	function attack(){
		if (attacking == null || attacking.health < 1){
			attacking = null;
			kills ++;
			if (kills >= maxKills){
				activity = returning;
				nation.weapons--;
			}else{
				activity = idle;
			}
		}else{
			velocity = velocity.mult(.6);
			attacking.health -= damage;
			project.particles.push(new BloodParticle(new kha.math.Vector2(4+Math.random()*4+(pos.x+attacking.pos.x)/2,4+Math.random()*4+(pos.y+attacking.pos.y)/2)));
			
			if (frame%10==0){
				var s = kha.audio1.Audio.play(kha.Assets.sounds.Hurt);
				if (s != null)
					s.volume = .01;
			}
		}
		
		if (nation.weapons < 1){
			activity = returning;
			return;
		}
		
		if (health < 10)
			activity = returning;
	}
	override function idle () {
		if (nation.weapons < 1 || health < 10){
			activity = returning;
			return;
		}

		dist = Math.POSITIVE_INFINITY;
		closest = null;
		for (citizen in project.citizens){
			if (citizen != this && citizen.fromNation != fromNation){
				var d = Math.sqrt(Math.pow(citizen.pos.x - pos.x,2) + Math.pow(citizen.pos.y - pos.y,2));
				if (d < dist){
					closest = citizen;
					dist = d;
				}
			}
		}

		if (dist < 30){
			attacking = closest;
			activity = attack;
			return;
		}
		if (dist > 200){
			activity = returning;
			return;
		}else{
			if (closest != null){
				var angle = Math.atan2(closest.pos.y - pos.y,closest.pos.x - pos.x);
				velocity.x = Math.cos(angle)*speed;
				velocity.y = Math.sin(angle)*speed;
			}
		}
	}
}