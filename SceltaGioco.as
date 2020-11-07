package {
	import flash.display.*;
	import flash.text.*;
	import flash.media.*; 
	import flash.net.*;
	import flash.events.Event; // ATTENZIONE
	import flash.events.MouseEvent;
	
	import id.core.Application;
	import id.core.TouchSprite;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;
	//import gl.events.GestureEvent;
	
	import caurina.transitions.*;
	
	public class SceltaGioco extends Application {
		
		/********************************************************/
		/** metodi **********************************************/
		
		// sfondo
		//private var tile:Background = new Background(new Material05(0,0));

		private var playsound:Boolean;
		
		var mysound2:Sound = new Sound();
		var channel2:SoundChannel = new SoundChannel();
		
		var mysound:Sound = new Sound();
		var channel:SoundChannel = new SoundChannel();
		
		
		// contenitori --> TouchSprite
		var container_button01 = new TouchSprite();
		var container_button02 = new TouchSprite();	
		var container_button03 = new TouchSprite();	
		var container_button04 = new TouchSprite();	
		var container_button05 = new TouchSprite();	
		var container_button06 = new TouchSprite();
		
		// variabili per le schermate
		var container:TouchSprite = new TouchSprite();
		var currentScreen:TouchSprite = new TouchSprite();
		
		var home = new Home();
		var primo = new PrimoGioco();
		var secondo = new SecondoGioco();
		var terzo = new TerzoGioco();
		var quarto = new QuartoGioco();
		var quinto = new QuintoGioco();
		var sesto = new SestoGioco();
		var screensaver = new Screensaver();
		
		public function SceltaGioco() {		
			settingsPath="application.xml";
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		override protected function initialize():void {
				
				//stage.scaleMode = StageScaleMode.SHOW_ALL; // ATTENZIONE
				
				// ***********************************
				// pulsanti --> scelta giochi
				
				addChild(home);
				currentScreen = home;
				
				currentScreen.addEventListener('gotoScreenSaver', screenSaver);
				currentScreen.addEventListener('gotoPrimoGioco', primoGioco);
				currentScreen.addEventListener('gotoSecondoGioco', secondoGioco);
				currentScreen.addEventListener('gotoTerzoGioco', terzoGioco);
				currentScreen.addEventListener('gotoQuartoGioco', quartoGioco);
				currentScreen.addEventListener('gotoQuintoGioco', quintoGioco);
				currentScreen.addEventListener('gotoSestoGioco', sestoGioco);
				
				// ***********************************
				// eventuale sfondo per il gioco
				//addChild(tile);				
		}
		
		
		/********************************************************/
		/** metodi **********************************************/
		
		public function tornaHome(e:Event):void {
			trace("# Evento --> Home in caricamento");
			
			Tweener.addTween(e.target, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				removeChild(this); // rimuovo il gioco che chiama la funzione
				this.x = 0; // lo posizione al centro
				var home = new Home();
				//home.sfondoRiferimento.width = stage.stageWidth;
				//home.sfondoRiferimento.height = stage.stageHeight;
				currentScreen = home;
				currentScreen.x = -2000;
				Tweener.addTween(currentScreen, {x:0, time:1.5, transition:"easeoutelastic"});
				// RIMETTO TUTTI I LISTENER A HOME
				currentScreen.addEventListener('gotoScreenSaver', screenSaver);
				currentScreen.addEventListener('gotoPrimoGioco', primoGioco);
				currentScreen.addEventListener('gotoSecondoGioco', secondoGioco);
				currentScreen.addEventListener('gotoTerzoGioco', terzoGioco);
				currentScreen.addEventListener('gotoQuartoGioco', quartoGioco);
				currentScreen.addEventListener('gotoQuintoGioco', quintoGioco);
				currentScreen.addEventListener('gotoSestoGioco', sestoGioco);
				
				addChild(home);
				
				
			}
		}
		// ricarica quinto gioco
		public function ricaricaQuinto(e:Event):void {
			trace("# Evento --> Quinto gioco ricarica");
			
			Tweener.addTween(e.target, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				//home.alpha = 0.5;
				removeChild(this);
				this.x = 0;
				var quinto = new QuintoGioco();
				addChild(quinto);
								quinto.x = -2000;
								Tweener.addTween(quinto, {x:0, time:0.5, transition:"easeOutQuart"});
				quinto.addEventListener('gotoHome', tornaHome);
				quinto.addEventListener('ricaricaQuintoGioco', ricaricaQuinto);
			}
		}
		
		// ricarica quinto gioco
		public function ricaricaSesto(e:Event):void {
			trace("# Evento --> Quinto gioco ricarica");
			
			Tweener.addTween(e.target, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				//home.alpha = 0.5;
				removeChild(this);
				this.x = 0;
				var sesto = new SestoGioco();
				addChild(sesto);
								sesto.x = -2000;
								Tweener.addTween(sesto, {x:0, time:0.5, transition:"easeOutQuart"});
				sesto.addEventListener('gotoHome', tornaHome);
				sesto.addEventListener('ricaricaSestoGioco', ricaricaSesto);
			}
		}
		
		// SCREEN SAVER
		public function screenSaver(e:Event):void {
			trace("# Evento --> Screen Saver in caricamento");
			
			Tweener.addTween(currentScreen, {x:0, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				//home.alpha = 0.5;
				removeChild(currentScreen);
				home.x = 0;
				var screensaver = new Screensaver();
				addChild(screensaver);
								//screensaver.x = -2000;
								Tweener.addTween(screensaver, {x:0, time:0.5, transition:"easeOutQuart"});
				screensaver.addEventListener('gotoHome', tornaHome);
			}
		}
		
		// PRIMO
		public function primoGioco(e:Event):void {
			trace("# Evento --> Primo gioco in caricamento");
			
			Tweener.addTween(currentScreen, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				//home.alpha = 0.5;
				removeChild(currentScreen);
				home.x = 0;
				var primo = new PrimoGioco();
				addChild(primo);
								primo.x = -2000;
								Tweener.addTween(primo, {x:0, time:0.5, transition:"easeOutQuart"});
				primo.addEventListener('gotoHome', tornaHome);
			}
		}
		// SECONDO
		public function secondoGioco(e:Event):void {
			trace("# Evento --> Secondo gioco in caricamento");
			
			Tweener.addTween(currentScreen, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				removeChild(currentScreen);
				home.x = 0;
				var secondo = new SecondoGioco();
				addChild(secondo);
								secondo.x = -2000;
								Tweener.addTween(secondo, {x:0, time:0.5, transition:"easeOutQuart"});
				secondo.addEventListener('gotoHome', tornaHome);
			}
		}
		public function terzoGioco(e:Event):void {
			trace("# Evento --> Terzo gioco in caricamento");
			
			Tweener.addTween(currentScreen, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				removeChild(currentScreen);
				home.x = 0;
				var terzo = new TerzoGioco();
				addChild(terzo);
								terzo.x = -2000;
								Tweener.addTween(terzo, {x:0, time:0.5, transition:"easeOutQuart"});
				terzo.addEventListener('gotoHome', tornaHome);
			}
		}
		public function quartoGioco(e:Event):void {
			trace("# Evento --> Quarto gioco in caricamento");
			
			//MovieClip(parent).prova();
			//removeChild(container_button02);
			Tweener.addTween(currentScreen, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				removeChild(currentScreen);
				home.x = 0;
				var quarto = new QuartoGioco();
				addChild(quarto);
								quarto.x = -2000;
								Tweener.addTween(quarto, {x:0, time:0.5, transition:"easeOutQuart"});
				quarto.addEventListener('gotoHome', tornaHome);
			}
		}
		public function quintoGioco(e:Event):void {
			trace("# Evento --> Quinto gioco in caricamento");
			
			//MovieClip(parent).prova();
			//removeChild(container_button02);
			Tweener.addTween(currentScreen, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				removeChild(currentScreen);
				home.x = 0;
				var quinto = new QuintoGioco();
				addChild(quinto);
								quinto.x = -2000;
								Tweener.addTween(quinto, {x:0, time:0.5, transition:"easeOutQuart"});
				quinto.addEventListener('gotoHome', tornaHome);
				quinto.addEventListener('ricaricaQuintoGioco', ricaricaQuinto);
			}
		}
		public function sestoGioco(e:Event):void {
			trace("# Evento --> Sesto gioco in caricamento");
			
			//MovieClip(parent).prova();
			//removeChild(container_button02);
			Tweener.addTween(currentScreen, {x:2000, time:0.5, transition:"easeInQuart", onComplete:func});
 
			function func() {
				removeChild(currentScreen);
				home.x = 0;
				var sesto = new SestoGioco();
				addChild(sesto);
								sesto.x = -2000;
								Tweener.addTween(sesto, {x:0, time:0.5, transition:"easeOutQuart"});
				sesto.addEventListener('gotoHome', tornaHome);
				sesto.addEventListener('ricaricaSestoGioco', ricaricaSesto);
			}
		}
		
		
		/*
		private function gestureRotateHandler(e:GestureEvent):void {
			e.target.rotation += e.value;
			trace(e.value);
		}
		
		private function gestureScaleHandler(e:GestureEvent):void {
			e.target.scaleX += e.value;
			e.target.scaleY += e.value;
		}
		
		private function gestureDragHandler(e:GestureEvent):void {
			e.target.x = e.value;
			e.target.y = e.value;
			
		}
		
		private function startDrag_Press(e:TouchEvent):void {
            e.target.startTouchDrag(-1);
				
			
        }
        private function stopDrag_Release(e:TouchEvent):void {
            e.target.stopTouchDrag(-1);
        }
		*/
		

	}
}
