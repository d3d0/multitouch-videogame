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
		
	public class Home extends TouchSprite {
		
		/********************************************************/
		/** variabili **********************************************/
		
		// sfondo
		//private var tile:Background = new Background(new Material05(0,0));
				
		// contenitori --> TouchSprite
		var container_screen_saver = new TouchSprite();
		
		var container_button01 = new TouchSprite();
		var container_button02 = new TouchSprite();	
		var container_button03 = new TouchSprite();	
		var container_button04 = new TouchSprite();	
		var container_button05 = new TouchSprite();	
		var container_button06 = new TouchSprite();
		
		public var containerArray:Array = new Array;
		public var mp3Array:Array = new Array;
		
		
		// timer
		var timerScreen:int = 420000;
		var timer = new Timer(timerScreen, 1);
		
		/********************************************************/
		/** metodi **********************************************/
		public function Home() {
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		/** metodi **********************************************/
		private function addedHandler(event:Event):void {
			
			mp3Array = ["sceltagioco.mp3"];
			
			containerArray = [container_button01, container_button02, container_button03, container_button04, container_button05, container_button06];
			
			for(var i:int = 0; i < containerArray.length; i++) {
				
			}
			
			trace("### Schermata --> Home aggiunta");
			//this.x = (stage.stageWidth - this.width) ;
			//this.y = (stage.stageHeight - this.height) ;
			
			// ***********************************
			// pulsanti --> screen
			
				/*container_screen_saver.addChild(screensaver);
				container_screen_saver.addEventListener(TouchEvent.TOUCH_DOWN,screenSaver);
			addChild(container_screen_saver);*/
			
			timer.addEventListener(TimerEvent.TIMER, onTimerFacce );
			
			function onTimerFacce(evt:TimerEvent):void
			{
				/*var e:Event = new Event('gotoHome');
				dispatchEvent(e);*/
				trace("PROVA");
				gotoScreenSaver();
			}
			timer.start();
			
			
			// ***********************************
			// pulsanti --> scelta giochi
			
				container_button01.addChild(button_gioco01);
				container_button01.addEventListener(TouchEvent.TOUCH_DOWN,gotoGioco01);
			addChild(container_button01);
			
				container_button02.addChild(button_gioco02);
				container_button02.addEventListener(TouchEvent.TOUCH_TAP,gotoGioco02);
			addChild(container_button02);
			
				container_button03.addChild(button_gioco03);
				container_button03.addEventListener(TouchEvent.TOUCH_TAP,gotoGioco03);
			addChild(container_button03);
			
				container_button04.addChild(button_gioco04);
				container_button04.addEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			addChild(container_button04);
			
				container_button05.addChild(button_gioco05);
				container_button05.addEventListener(TouchEvent.TOUCH_TAP,gotoGioco05);
			addChild(container_button05);
			
				container_button06.addChild(button_gioco06);
				container_button06.addEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			addChild(container_button06);
			
		}
		
		private function removedHandler(event:Event):void {
			
		}
		
		/********************************************************/
		/** metodi **********************************************/
		private function playSoundGame(){
			var channel:SoundChannel = new SoundChannel();
			var audioMp3 = mp3Array[0];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
			channel = mysound.play(0);
		}
		
		private function gotoScreenSaver():void {
			trace("# Evento --> Attivazione Screen Saver");
			
			var e:Event = new Event('gotoScreenSaver');
			dispatchEvent(e);
			
			// rimuovo tutti i listener
			container_button01.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco01);
			container_button02.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco02);
			container_button03.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco03);
			container_button04.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			container_button05.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco05);
			container_button06.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			timer.stop();
		}
		
		private function gotoGioco01(event:TouchEvent):void {
			trace("# Evento --> Attivazione Primo gioco");
			
			var e:Event = new Event('gotoPrimoGioco');
			dispatchEvent(e);
			
			//suono
			playSoundGame();
			
			// rimuovo tutti i listener
			event.target.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco01);
			container_button02.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco02);
			container_button03.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco03);
			container_button04.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			container_button05.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco05);
			container_button06.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			timer.stop();
		}
		private function gotoGioco02(event:TouchEvent):void {
			trace("# Evento --> Attivazione Secondo gioco");
			
			var e:Event = new Event('gotoSecondoGioco');
			dispatchEvent(e);
			
			//suono
			playSoundGame();
			
			event.target.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco02);
			container_button01.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco01);
			container_button03.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco03);
			container_button04.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			container_button05.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco05);
			container_button06.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			timer.stop();
		}
		private function gotoGioco03(event:TouchEvent):void {
			trace("# Evento --> Attivazione Terzo gioco");
			
			var e:Event = new Event('gotoTerzoGioco');
			dispatchEvent(e);
			
			//suono
			playSoundGame();
			
			event.target.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco03);
			container_button01.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco01);
			container_button03.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco02);
			container_button04.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			container_button05.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco05);
			container_button06.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			timer.stop();
		}
		private function gotoGioco04(event:TouchEvent):void {
			trace("# Evento --> Attivazione Quarto gioco");
			
			var e:Event = new Event('gotoQuartoGioco');
			dispatchEvent(e);
			
			//suono
			playSoundGame();
			
			event.target.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			container_button01.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco01);
			container_button03.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco02);
			container_button04.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			container_button05.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco05);
			container_button06.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			timer.stop();
		}
		private function gotoGioco05(event:TouchEvent):void {
			trace("# Evento --> Attivazione Quinto gioco");
			
			var e:Event = new Event('gotoQuintoGioco');
			dispatchEvent(e);
			
			//suono
			playSoundGame();
			
			event.target.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco05);
			container_button01.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco01);
			container_button03.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco02);
			container_button04.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco03);
			container_button05.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			container_button06.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			timer.stop();
		}
		private function gotoGioco06(event:TouchEvent):void {
			trace("# Evento --> Attivazione Sesto gioco");
			
			var e:Event = new Event('gotoSestoGioco');
			dispatchEvent(e);
			
			//suono
			playSoundGame();
			
			event.target.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			container_button01.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco01);
			container_button03.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco03);
			container_button04.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco04);
			container_button05.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco05);
			container_button06.removeEventListener(TouchEvent.TOUCH_TAP,gotoGioco06);
			timer.stop();
		}
		

	}
}
