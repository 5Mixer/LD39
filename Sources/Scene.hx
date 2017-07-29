package ;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Scene {
	public function new (){
		
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}
	public function update () {

	}
	public function render(fb:kha.Framebuffer){

	}
}