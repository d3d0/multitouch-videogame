package {
	import flash.display.*;
	import flash.text.*;
	import flash.media.*; 
	import flash.net.*;
	import flash.utils.Timer; // timer
	import flash.events.Event; // ATTENZIONE
	import flash.events.MouseEvent;
	import flash.events.TimerEvent; // timer
	import flash.geom.Point;
	
	import id.core.Application;
	import id.core.TouchSprite;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;
	
	import caurina.transitions.*;
		
	public class Screensaver extends TouchSprite {
		
		var container_screen_saver = new TouchSprite();
		
		/*************************************************************/
		/** costruttore **********************************************/
		
		public function Screensaver() {
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		private function addedHandler(event:Event):void {
			// ***********************************
			// pulsanti --> screen
			
				container_screen_saver.addChild(screensaver);
				container_screen_saver.addEventListener(TouchEvent.TOUCH_DOWN,gotoHome);
			addChild(container_screen_saver);
			
		}
		private function removedHandler(event:Event):void {
			
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		private function gotoHome(event:TouchEvent):void {
			trace("# Evento --> Attivazione Home");
			
			var e:Event = new Event('gotoHome');
			dispatchEvent(e);
			
		}
	}
	
}
