package {
	import flash.display.*;
	import flash.text.*;
	import flash.media.*; 
	import flash.net.*;
	import flash.utils.Timer; // timer
	import flash.events.Event; // ATTENZIONE
	import flash.events.MouseEvent;
	import flash.events.TimerEvent; // timer
	
	import id.core.Application;
	import id.core.TouchSprite;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;
	
	import caurina.transitions.*;
	import fl.transitions.Tween;
		
	public class QuartoGioco extends TouchSprite {
		
		/***********************************************************/
		/** variabili **********************************************/
		
		// sfondo
		//private var tile:Background = new Background(new Material05(0,0));
		
		// index array
		private var index:int;
		
		// array per contenitori e musica
		private var containerArray:Array;
		private var mp3Array:Array;
		private var mp3EffettiArray:Array;
		private var pulsantiArray:Array;
		private var channelArray:Array;
		
		// container
		var container_button_home = new TouchSprite();
		var container_screen_saver = new TouchSprite();
		
		var container_01 = new TouchSprite();
		var container_02 = new TouchSprite();
		var container_03 = new TouchSprite();
		var container_04 = new TouchSprite();
		var container_05 = new TouchSprite();
		var container_06 = new TouchSprite();
		var container_07 = new TouchSprite();
		var container_08 = new TouchSprite();
		var container_09 = new TouchSprite();
		var container_10 = new TouchSprite();
		var container_11 = new TouchSprite();
		var container_12 = new TouchSprite();
		var container_13 = new TouchSprite();
		var container_14 = new TouchSprite();
		
		// suoni		
		var channel01:SoundChannel = new SoundChannel();
		var channel02:SoundChannel = new SoundChannel();
		var channel03:SoundChannel = new SoundChannel();
		var channel04:SoundChannel = new SoundChannel();
		var channel05:SoundChannel = new SoundChannel();
		var channel06:SoundChannel = new SoundChannel();
		var channel07:SoundChannel = new SoundChannel();
		var channel08:SoundChannel = new SoundChannel();
		var channel09:SoundChannel = new SoundChannel();
		var channel10:SoundChannel = new SoundChannel();
		var channel11:SoundChannel = new SoundChannel();
		var channel12:SoundChannel = new SoundChannel();
		var channel13:SoundChannel = new SoundChannel();
		var channel14:SoundChannel = new SoundChannel();
		
		var timerScreen:int = 300000;
		var timer = new Timer(timerScreen, 1);
		
		/*************************************************************/
		/** costruttore **********************************************/
		
		public function QuartoGioco() {
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		private function addedHandler(event:Event):void {
			
			mp3EffettiArray = ["sceltagioco.mp3"];
			
			containerArray = [container_01, container_02, container_03, container_04, container_05, container_06, container_07,
						 container_08, container_09, container_10, container_11, container_12, container_13, container_14];
			
			mp3Array = ["cane.mp3", "gatto.mp3", "cavallo.mp3", "leone.mp3", "mucca.mp3", "gallina.mp3", "oche.mp3",
						 "maiale.mp3", "tigre.mp3", "elefante.mp3", "gallo.mp3", "uccellino.mp3", "pecora.mp3" ,"asino.mp3"];
			
			pulsantiArray = [animalButton01, animalButton02, animalButton03, animalButton04, animalButton05, animalButton06, animalButton07,
							 animalButton08, animalButton09, animalButton10, animalButton11, animalButton12, animalButton13, animalButton14];
			
			channelArray = [channel01, channel02, channel03, channel04, channel05, channel06, channel07,
							channel08, channel09, channel10, channel11, channel12, channel13, channel14];
			
			trace("### Schermata --> Secondo Gioco aggiunta");
			//this.x = (stage.stageWidth - this.width) ;
			//this.y = (stage.stageHeight - this.height) ;
			
			// ***********************************
			// pulsanti --> screen
			
				container_screen_saver.addChild(screensaver);
				container_screen_saver.addEventListener(TouchEvent.TOUCH_DOWN,screenSaver);
			addChild(container_screen_saver);
			
			timer.addEventListener(TimerEvent.TIMER, onTimerFacce );
			
			function onTimerFacce(evt:TimerEvent):void
			{
				var e:Event = new Event('gotoHome');
				dispatchEvent(e);
			}
			timer.start();
			
			// ***********************************
			// pulsante --> home
			
			container_button_home.addChild(button_Home);
			container_button_home.addEventListener(TouchEvent.TOUCH_DOWN,gotoHome);
			addChild(container_button_home);
			
			// ***********************************
			// pulsante --> strumenti
			
			for(var i:int = 0; i < containerArray.length; i++) {
				
				containerArray[i].addChild(pulsantiArray[i]);
				containerArray[i].x = 0;
				containerArray[i].y = 0;
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, playSound)
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN,screenSaver);
				addChild(containerArray[i]);
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame); 
 
			function onEnterFrame(event:Event):void { 
				
			} 
			
		}
		private function removedHandler(event:Event):void {
			
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		// torna a home
		private function gotoHome(event:TouchEvent):void {
			trace("# Evento --> Attivazione Home");
			
			// fermo tutti i suoni
			for(var i:int = 0; i < pulsantiArray.length; i++) {
				channelArray[i].stop();
			}
			
			var e:Event = new Event('gotoHome');
			dispatchEvent(e);
			
			var channel:SoundChannel = new SoundChannel();
			var audioMp3 = mp3EffettiArray[0];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
			channel = mysound.play(0);
			
			timer.stop();
		}
		
		private function screenSaver(e:TouchEvent):void {
			timer.reset();
			timer.start();
			trace("SCREENSAVER RESET");
		}
		
		
		private function onSoundComplete(event:Event):void{
			trace("prova");
			index = channelArray.indexOf(event.target);
			trace("INDEX ARRAY: " + index);
			containerArray[index].getChildAt(0).scaleX = 1;
			containerArray[index].getChildAt(0).scaleY = 1;
			containerArray[index].addEventListener(TouchEvent.TOUCH_DOWN, playSound)
		}
		
		// suona lo strumento scelto
		private function playSound(event:TouchEvent):void
        {	
			
			index = containerArray.indexOf(event.target);
			trace("INDEX ARRAY: " + index);
			
			/*
			// ANIMAZIONE SUL CLICK
			Tweener.addTween(event.target.getChildAt(0),{rotation:10,time:0.2,transition:"easeOutQuart", onComplete:func});
			
			function func() {
				Tweener.addTween(event.target.getChildAt(0),{rotation:-10,time:0.2,transition:"easeOutQuart", onComplete:func2});
			}
			function func2() {
				Tweener.addTween(event.target.getChildAt(0),{rotation:0,time:0.5,transition:"easeoutelastic"});
			}
			*/
			event.target.getChildAt(0).scaleX = 1.1;
			event.target.getChildAt(0).scaleY = 1.1;
			
			trace("Sprite CLICCATO: " + event.target.name);
			trace("Gioco CLICCATO: " + event.target.parent.name);
			
			var infoCorrente = event.target.parent.name;
			
			channelArray[index].stop();
			
			var audioMp3 = mp3Array[index];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/animali/" + audioMp3));
			channelArray[index] = mysound.play(0);
			
			containerArray[index].removeEventListener(TouchEvent.TOUCH_DOWN, playSound);
			channelArray[index].addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        }
		

	}
}
