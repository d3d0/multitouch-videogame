////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2010 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	SplashScreen.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.ui
{
	import id.core.id_internal;
	import id.core.ApplicationGlobals;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.*;
	import flash.utils.setTimeout;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	use namespace id_internal;
	
	/**
	 * @private
	 */
	public class SplashScreen extends Sprite
	{
		include "../core/Version.as";
		
		private var grid:Sprite;
		private var logo:Sprite;
		private var title:Sprite;
		
		private var gridLoader:Loader;
		private var logoLoader:Loader;
		private var titleLoader:Loader;
		
		private var logoFilter:DropShadowFilter;
		private var gradFilter:DropShadowFilter;
		private var logoGradient:Shape;
		
		private var logoContainer:Sprite;
		private var titleContainer:Sprite;
		private var _infoContainer:Sprite;
		
		private var _colors:Array = [ 0x111111, 0x000000 ];
		private var _alphas:Array = [ 1.0, 1.0 ];
		private var _ratios:Array = [ 0x00, 0xFF ];
		private var _matrix:Matrix;
		
		private var _infoFields:Object =
		{
			version:
			{
				field: new TextField(),
				format: new TextFormat("Verdana", 13, 0xcccccc, false, false, false, null, null, TextFormatAlign.CENTER)
			},
			
			product:
			{
				field: new TextField(),
				format: new TextFormat("Verdana", 10, 0x000000, true, false, false, null, null, TextFormatAlign.RIGHT)
			},
			
			product_description:
			{
				field: new TextField(),
				format: new TextFormat("Verdana", 10, 0x333333, false, false, false, null, null, TextFormatAlign.RIGHT)
			},
			
			copyright:
			{
				field: new TextField(),
				format: new TextFormat("Verdana", 10, 0x333333, false, false, false, null, null, TextFormatAlign.RIGHT)
			}
		}
		
		public function SplashScreen()
		{
			super();
			
			alpha = 0;
			mouseChildren = false;
			mouseEnabled = false;
				
			//initialize();
						
			ApplicationGlobals.application.stage.addChild(this);
		}
		
		public function dispose():void
		{
			if(!parent) return;
				
			gridLoader.unload();
			logoLoader.unload();
			titleLoader.unload();
			
			with(_infoFields)
			{
			try
			{
			version.field.parent.removeChild(version.field);
			product.field.parent.removeChild(product.field);
			product_description.field.parent.removeChild(product_description.field);
			copyright.field.parent.removeChild(copyright.field);
			}
			catch(e:Error)
			{
			// suppress
			}
			}
			
			grid.removeChild(gridLoader);
			logo.removeChild(logoLoader);
			title.removeChild(titleLoader);
			grid.parent.removeChild(grid);
			logo.parent.removeChild(logo);
			title.parent.removeChild(title);
			removeChild(logoContainer);
			removeChild(titleContainer);
			removeChild(_infoContainer);
			
			parent.removeChild(this);
			
			_infoFields = null;
			gridLoader= null;
			logoLoader= null;
			titleLoader= null;
			grid = null;
			logo = null;
			title = null;
			
			delete this;
		}
		
		private function initialize():void
		{
			gradFilter = new DropShadowFilter(3, 22, 0x000000, 0.5, 10, 10, 1.0, BitmapFilterQuality.HIGH);
			logoFilter = new DropShadowFilter(3, 45, 0x000000, 0.5, 10, 10, 1.0, BitmapFilterQuality.HIGH);
			
			grid = new Sprite();
			logo = new Sprite();
			title = new Sprite();
			gridLoader = new Loader();
			logoLoader = new Loader();
			titleLoader = new Loader();
			logoGradient = new Shape();
			logoContainer = new Sprite();
			titleContainer = new Sprite();
			_infoContainer = new Sprite();
			
			grid.addChild(gridLoader);
			logo.addChild(logoLoader);
			title.addChild(titleLoader);
			logoContainer.addChild(logoGradient);
			logoContainer.addChild(logo);
			titleContainer.addChild(title);
			
			/*addChild(grid);
			addChild(logoContainer);
			addChild(titleContainer);
			addChild(_infoContainer);*/
			
			logoContainer.filters = [gradFilter];
			this.filters = [logoFilter];
			
			gridLoader.load(new URLRequest("http://openexhibits.org/OESplash/GradientBack.png"));
			logoLoader.load(new URLRequest("http://openexhibits.org/OESplash/OELogo.png"));
			titleLoader.load(new URLRequest("http://openexhibits.org/OESplash/OETitle.png"));
			
			gridLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			titleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			
			gridLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, gridLoader_Error);
			logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, logoLoader_Error);
			titleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, titleLoader_Error);
			
			//createFields();
		}
		
		private var loaderCount:int;
		private function loaderComplete(event:Event=null):void
		{
			loaderCount++;
			
			if(loaderCount==3)
			{
				positionElements();
				
				setTimeout(show, 0);
				setTimeout(hide, 4000);
			}
		}
		
		private function createFields():void
		{
			_matrix = new Matrix();
			_matrix.createGradientBox(119, 119, 90 / 180 * Math.PI, 0, 0);
			logoGradient.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix, SpreadMethod.PAD);
			logoGradient.graphics.drawRect(0, 0, 199, 199);
			logoGradient.graphics.endFill();
			
			for each (var v:Object in _infoFields)
			{
				v.field.defaultTextFormat = v.format;
				addChild(v.field);
			}
			
			with(_infoFields)
			{
			version.field.autoSize = TextFieldAutoSize.CENTER;
			version.field.multiline=true;
			version.field.wordWrap = true;
			version.field.text = "Open Exhibits SDK"+"\n"+"v"+id_internal::VERSION;
			
			product.field.autoSize = TextFieldAutoSize.LEFT;
			product.field.text = "openexhibits.org/support";
			
			
			product_description.field.autoSize = TextFieldAutoSize.LEFT;
			product_description.field.text = "This software is based on GestureWorks; ©2011 Ideum Inc. All Rights Reserved";
			
			copyright.field.autoSize = TextFieldAutoSize.LEFT;
			copyright.field.text = "For support questions visit: ";
			}
		}
		
		private function positionElements():void
		{
			grid.x=100;
			
			logo.x = int((logoGradient.width - 135) / 2);
			logo.y = 20;
			
			titleContainer.x = logoContainer.width;
			title.x = int((width - logoGradient.width - 403) / 2);
			title.y = 30;
			
			var rightBound:int = titleContainer.x + title.x + title.width;
	
			with(_infoFields)
			{
			version.field.width = logoGradient.width;
			version.field.height = version.field.textHeight + 2;
			version.field.y = logo.height + 36;
			
			product_description.field.x = width - product_description.field.textWidth-10;
			product_description.field.y = version.field.y+5;
			
			product.field.x = width - product.field.textWidth-10;
			
			copyright.field.x = product.field.x - copyright.field.textWidth-3;
			copyright.field.y = product_description.field.y + product_description.field.textHeight + 6;
			
			product.field.y =copyright.field.y;
			}
			
			x = int((ApplicationGlobals.application.stage.width - width) / 2);
			y = int((ApplicationGlobals.application.stage.height - height) / 2);
		}
		
		private function show():void
		{
			alpha = 1;
		}
		
		private function hide():void
		{
			alpha = 0;
			dispose();
		}
		
		private function gridLoader_Error(e:Event)
		{			
			grid.graphics.clear();
			grid.graphics.beginFill(0xcccccc, 1);
			grid.graphics.drawRect(0, 0, 568, 199);
			grid.graphics.endFill();
			
			loaderComplete();
		}
		
		private function logoLoader_Error(e:Event)
		{
			logo.graphics.clear();
			logo.graphics.beginFill(0xF79820, 1);
			logo.graphics.drawEllipse(0, 0, 135, 119);
			logo.graphics.endFill();
			
			var logoIn:Shape = new Shape();
			logo.addChild(logoIn);
			logoIn.graphics.beginFill(0x000000, 1);
			logoIn.graphics.drawEllipse(0, 0, 90, 100);
			logoIn.graphics.endFill();
			
			var logoCircle:Shape = new Shape();
			logo.addChild(logoCircle);
			logoCircle.graphics.beginFill(0xF79820, 1);
			logoCircle.graphics.drawCircle(0, 0, 15);
			logoCircle.graphics.endFill();
			
			logoIn.x = 22.5;
			logoIn.y = 9.5;
			
			logoCircle.x = (logo.width / 2)-7.5;
			logoCircle.y = (logo.height / 2) - 7.5;;
			
			loaderComplete();
		}
		
		private function titleLoader_Error(e:Event)
		{			
			var textFormat:TextFormat = new TextFormat();
			textFormat.align=TextFormatAlign.LEFT;
			textFormat.font="LucindaBoldFont";
			
			textFormat.size = 55;
			textFormat.color=0xF79820;
			textFormat.letterSpacing = 2;
			
			var openTxt:TextField = new TextField();
			openTxt.defaultTextFormat = textFormat;
			openTxt.embedFonts=true;
			openTxt.antiAliasType=AntiAliasType.ADVANCED;
			openTxt.selectable=false;
			openTxt.autoSize=TextFieldAutoSize.LEFT;
			title.addChild(openTxt);
			
			textFormat.color=0x000000;
			var exhibitsTxt:TextField = new TextField();
			exhibitsTxt.defaultTextFormat = textFormat;
			exhibitsTxt.embedFonts=true;
			exhibitsTxt.antiAliasType=AntiAliasType.ADVANCED;
			exhibitsTxt.selectable=false;
			exhibitsTxt.autoSize=TextFieldAutoSize.LEFT;
			title.addChild(exhibitsTxt);
			
			textFormat.size = 19;
			textFormat.color=0xFFFFFF;
			textFormat.letterSpacing = 1;
			textFormat.font="LucindaFont";
			var commercialText:TextField = new TextField();
			commercialText.defaultTextFormat = textFormat;
			commercialText.embedFonts=true;
			commercialText.antiAliasType=AntiAliasType.ADVANCED;
			commercialText.selectable=false;
			commercialText.autoSize=TextFieldAutoSize.LEFT;
			title.addChild(commercialText);
			
			openTxt.text = "Open";
			exhibitsTxt.text = "exhibits";
			commercialText.text = " ";
			
			openTxt.y = 10;
			exhibitsTxt.y = 10;
			exhibitsTxt.x = openTxt.x+170;
			commercialText.y = 85;
			commercialText.x = 40;
			
			var textFilter:DropShadowFilter = new DropShadowFilter(4, 45, 0x000000, .5, 4, 4, 1.0, BitmapFilterQuality.HIGH);
			openTxt.filters = [textFilter];
			exhibitsTxt.filters = [textFilter];
			commercialText.filters = [textFilter];
			
			loaderComplete();
		}
	}
}
