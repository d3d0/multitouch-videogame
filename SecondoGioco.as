package {
	import flash.display.*;
	import flash.text.*;
	import flash.media.*; 
	import flash.net.*;
	import flash.utils.Timer; // timer
	import flash.events.Event; // ATTENZIONE
	import flash.events.TimerEvent; // timer
	import flash.events.MouseEvent;
	
	import id.core.Application;
	import id.core.TouchSprite;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;
	
	import caurina.transitions.*;
		
	public class SecondoGioco extends TouchSprite {
		
		/***********************************************************/
		/** variabili **********************************************/
		
		// sfondo
		//private var tile:Background = new Background(new Material05(0,0));
		
		// index array
		private var index:int;
		
		// this
		var thisGioco = this;
		
		// array per contenitori e musica
		private var containerArray:Array;
		private var mp3Array:Array;
		private var mp3EffettiArray:Array;
		private var funzioniArray:Array;
		private var pulsantiArray:Array;
		private var channelArray:Array;
		
		// container
		var BIG_container = new TouchSprite();
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
		
		// timer
		var timerScreen:int = 300000;
		var timer = new Timer(timerScreen, 1);
		
		/*************************************************************/
		/** costruttore **********************************************/
		
		public function SecondoGioco() {
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		private function addedHandler(event:Event):void {
			
			mp3EffettiArray = ["sceltagioco.mp3"];
			
			containerArray = [container_01, container_02, container_03, container_04, container_05, container_06, container_07,
						 container_08, container_09, container_10, container_11];
			
			mp3Array = ["chitarra.mp3", "tromba.mp3", "fagotto.mp3", "siringa.mp3", "violino.mp3",
						"tuba.mp3", "drumroll.mp3", "corno.mp3", "clarinetto.mp3", "sax.mp3","flauto.mp3"];
			
			pulsantiArray = [musicButton01, musicButton02, musicButton03, musicButton04, musicButton05,
							 musicButton06, musicButton07, musicButton08, musicButton09, musicButton10, musicButton11];
			
			channelArray = [channel01, channel02, channel03, channel04, channel05, channel06, channel07, channel08, channel09, channel10, channel11];
			
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
			container_button_home.addEventListener(TouchEvent.TOUCH_TAP,gotoHome);
			addChild(container_button_home);
			
			// ***********************************
			// pulsante --> strumenti
			
			for(var i:int = 0; i < containerArray.length; i++) {
				this.x = 0;
				//this.sfondoRiferimento.width = stage.stageWidth;
				
				containerArray[i].addChild(pulsantiArray[i]);
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, playSound);
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, screenSaver);
				
				//pulsantiArray[i].y = (this.height-pulsantiArray[i].height)/2 + 230;
				//pulsantiArray[i].x = i*150;
				//Tweener.addTween(pulsantiArray[i],{x: i*130,time:1.2,transition:"easeoutelastic"});
				//Tweener.addTween(pulsantiArray[i],{y: ((stage.stageHeight-pulsantiArray[i].height)/2),time:1,transition:"easeoutelastic"});
				addChild(containerArray[i]);
				
				trace("Container x: " + containerArray[i].x);
				trace("Stage height: " + stage.stageHeight);
				trace("Pulsanti Array height: " + pulsantiArray[i].height);
				
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame); 
 
			
			
		}
		private function removedHandler(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		// onenterframe sposto i pulsanti con la banda
		private function onEnterFrame(event:Event):void { 
		
			//trace(sfondoRiferimento.width);
			/*
			citta01.x -= 1;
			citta02.x -= 1;
			*/
			/*
			if(citta01.x < -1024){
				citta01.x = 1020;
				
			}
			if(citta02.x < -1024){
				citta02.x = 1020;
			}
			/*
			for(var i:int = 0; i < pulsantiArray.length; i++) {
				
				//trace("pulsanti y: " + pulsantiArray[i].y);
				//trace("pulsanti x: " + pulsantiArray[i].x);
				
				var x_max:Number = 150*8; // x massima contando 8 personaggi
				//trace("X MAX: " + x_max);
				
				if (pulsantiArray[i].x > x_max) {
					trace("i: " + i + " " + pulsantiArray[i].x);
					var indexSpostamento:int;
					if(i!=10) {
						indexSpostamento = i + 1;
						
					}
					else {
						indexSpostamento = i-10;
						//trace("i = 10: " + indexSpostamento);
						
					}
					//trace("INDEX: " +indexSpostamento + pulsantiArray[i]);
					pulsantiArray[i].x = Math.round(pulsantiArray[indexSpostamento].x) - 150;
					
				}
				pulsantiArray[i].x += 1.5; 
			}
			*/
		} 
		
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
		}
		
		private function onSoundComplete(event:Event):void{
			trace("prova");
			index = channelArray.indexOf(event.target);
			trace("INDEX ARRAY: " + index);
			containerArray[index].getChildAt(0).scaleX = 0.85;
			containerArray[index].getChildAt(0).scaleY = 0.85;
			containerArray[index].addEventListener(TouchEvent.TOUCH_DOWN, playSound);
		}
		
		// suona lo strumento scelto
		private function playSound(event:TouchEvent):void
        {	
			
			index = containerArray.indexOf(event.target);
			trace("INDEX ARRAY: " + index);
			/*
			Tweener.addTween(event.target.getChildAt(0),{scaleX:1.03,time:0.3,transition:"easeOutQuart", onComplete:func});
			Tweener.addTween(event.target.getChildAt(0),{scaleY:1.03,time:0.3,transition:"easeOutQuart"});
			
			function func() {
				Tweener.addTween(event.target.getChildAt(0),{scaleX:0.85,time:0.2,transition:"easeInQuart"});
				Tweener.addTween(event.target.getChildAt(0),{scaleY:0.85,time:0.2,transition:"easeInQuart"});
			}
			*/
			event.target.getChildAt(0).scaleX = 1.03;
			event.target.getChildAt(0).scaleY = 1.03;
			
			trace("Sprite CLICCATO: " + event.target.name);
			trace("Gioco CLICCATO: " + event.target.parent.name);
			
			channelArray[index].stop();
			
			var audioMp3 = mp3Array[index];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/strumenti/" + audioMp3));
			channelArray[index] = mysound.play(0);
			
			//trace(mysound.length);
			containerArray[index].removeEventListener(TouchEvent.TOUCH_DOWN, playSound);
			channelArray[index].addEventListener(Event.SOUND_COMPLETE, onSoundComplete);

			
        }
		

	}
}
