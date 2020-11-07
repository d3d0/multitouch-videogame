package id.utils
{  
     import flash.display.Loader;  
     import flash.display.Sprite;  
     import flash.events.Event;
     import flash.net.URLRequest;
	 import flash.text.Font;
  
     public class FontLoader extends Sprite 
	 {  
		 private static var _url:String = "";
		 public static function get url():String {return _url;}
		 public static function set url(value:String):void
		 {
			 if (url == value) return;
			 
			 _url = value;
			 loadFont();
		 }
  
		 private static function loadFont():void 
		  {  
               var loader:Loader = new Loader();  
               loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fontLoaded);  
               loader.load(new URLRequest(url));  
          }  
  
          private static function fontLoaded(event:Event):void 
		  {  
               var Arial_Font:Class = event.target.applicationDomain.getDefinition("ArialFont") as Class;  
               Font.registerFont(Arial_Font.ArialFont);
			   
			   var Georgia_Font:Class = event.target.applicationDomain.getDefinition("GeorgiaFont") as Class;  
               Font.registerFont(Georgia_Font.GeorgiaFont);
			   
			   var Georgia_Italic_Font:Class = event.target.applicationDomain.getDefinition("GeorgiaItalicFont") as Class;  
               Font.registerFont(Georgia_Italic_Font.GeorgiaItalicFont);
			   
			   var Verdana_Bold_Font:Class = event.target.applicationDomain.getDefinition("VerdanaBoldFont") as Class;  
               Font.registerFont(Verdana_Bold_Font.VerdanaBoldFont);
			   
			   var Verdana_Font:Class = event.target.applicationDomain.getDefinition("VerdanaFont") as Class;
               Font.registerFont(Verdana_Font.VerdanaFont);
			   
			   var Lucinda_Bold_Font:Class = event.target.applicationDomain.getDefinition("LucindaBoldFont") as Class;  
               Font.registerFont(Lucinda_Bold_Font.LucindaBoldFont);
			   
			   var Lucinda_Font:Class = event.target.applicationDomain.getDefinition("LucindaFont") as Class;
               Font.registerFont(Lucinda_Font.LucindaFont);
			   
			   
          }    
     }  
}  