////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ModuleManager.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.modules
{

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

public class ModuleManager
{
	
	include "../core/Version.as" ;
	
	private static var _instance = new ModuleManager();
	public static function get instance():ModuleManager
	{
		return _instance;
	}
	
	public static function getModule(url:String):IModule
	{
		return _instance.getModule(url);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var moduleDictionary:Dictionary = new Dictionary(true);
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion GestureWorks 1.6
     */
	public function ModuleManager()
	{
		super();
	}
	
	public function getModule(url:String):IModule
	{
		var module:Module;
		var m:Object;
		
		for(m in moduleDictionary)
		{
			if(moduleDictionary[m] != url)
			{
				continue;
			}
			
			module = m as Module;
			break;
		}
		
		if(!module)
		{
			module = new Module(url);
			moduleDictionary[module] = url;
		}
		
		return new ModuleProxy(module);
	}
	
}

}

import id.events.ModuleEvent;
import id.modules.IModule;
import id.modules.IModuleFactory;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: Module
//
////////////////////////////////////////////////////////////////////////////////

/*
	TODO:
	Support multiple application domains, concurrent loading into each domain.
	- If multiple calls for the same swf exist, multiple loaders are attempted
	regardless of the domain specified. => Create multi-domain, multi-loader
	support and a _loading flag, or _loadingIncomplete => error pathway.
*/

class Module extends EventDispatcher implements IModule
{
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	public var factoryInfo:Object;

    //----------------------------------
    //  Loader
    //----------------------------------

	private var _loader:Loader;
	public var _url:String;
	
    //----------------------------------
    //  States
    //----------------------------------
	
	private var _error:Boolean;
	private var _loaded:Boolean;
	private var _ready:Boolean;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion GestureWorks 1.6
     */
	public function Module(url:String)
	{
		super();
		
		_url = url;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	public function get factory():IModuleFactory
	{
		return factoryInfo.factory;
	}
	
	public function get error():Boolean
	{
		return _error;
	}
	
	public function get loaded():Boolean
	{
		return _loaded;
	}
	
	public function get ready():Boolean
	{
		return _ready;
	}
	
	public function get url():String
	{
		return _url;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Loading
    //
    //--------------------------------------------------------------------------
	
	public function load
	(
		applicationDomain:ApplicationDomain = null,
		securityDomain:SecurityDomain = null,
		bytes:ByteArray = null/*,
		moduleFactory:IModuleFactory = null*/
	)
	:void
	{
		if (loaded)
		{
			return;
		}
		
		_loaded = true;
		
		if (bytes)
		{
			loadBytes(applicationDomain, bytes);
			return;
		}
		
		var request:URLRequest = new URLRequest(_url);
		var context:LoaderContext = new LoaderContext();
		
		context.applicationDomain = applicationDomain ? 
			applicationDomain :
			new ApplicationDomain(ApplicationDomain.currentDomain)
		;
		
		context.securityDomain = securityDomain ?
			securityDomain :
			Security.sandboxType == Security.REMOTE ?
				SecurityDomain.currentDomain :
			null
		;
		
		createLoader();
		
		_loader.load(request, context);
	}
	
	private function loadBytes(applicationDomain:ApplicationDomain, bytes:ByteArray):void
	{
		if (loaded)
		{
			return;
		}
		
		var context:LoaderContext = new LoaderContext();
		context.applicationDomain = applicationDomain ? 
			applicationDomain :
			new ApplicationDomain(ApplicationDomain.currentDomain)
		;
		
		createLoader(true);

		_loader.loadBytes(bytes, context);
		
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Unloading
    //
    //--------------------------------------------------------------------------
	
	public function reanimate():void
	{
		if(!_ready || factoryInfo)
		{
			return;
		}

		unload();
	}
	
	public function release():void
	{
		if(!_ready)
		{
			unload();
		}
	}
	
	public function unload():void
	{
		clearLoader();
		destroyLoader();
		
		if(_loaded)
		{
			dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
		}
		
		_loaded = false;
		_ready = false;
		_error = false;
		
		factoryInfo = null;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Utility
    //
    //--------------------------------------------------------------------------
	
	private function createLoader(isByteLoader:Boolean = false):void
	{
		if(_loader)
		{
			throw new Error("Module -- Loader already exists!");
		}
		
		_loader = new Loader();
		
		_loader.contentLoaderInfo.addEventListener(Event.INIT, loader_initHandler);
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
		_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
		
		if(isByteLoader)
		{
			return;
		}
		
		_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
	}

	private function clearLoader():void
	{
		if(!_loader)
		{
			return;
		}
		
		_loader.contentLoaderInfo.removeEventListener(Event.INIT, loader_initHandler);
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
		_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
		_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
		
		removeContentListeners();
	}

	private function destroyLoader():void
	{
		clearLoader();
		
		if(_loaded)
		try
		{
			_loader.close()
		}
		catch(e:Error)
		{
			// suppress exception
		}
		
		try
		{
			_loader.unload();
		}
		catch(e:Error)
		{
			// suppress exception
		}
		
		_loader = null;
	}
	
	private function attachContentListeners():void
	{
		if(!_loader.content)
		{
			throw new Error("I should NEVER be here!");
		}
		
		_loader.content.addEventListener("ready", loaderContent_readyHandler);
		_loader.content.addEventListener("error", loaderContent_errorHandler);
	}
	
	private function removeContentListeners():void
	{
		if(!_loader)
		{
			return;
		}
		
		if(!_loader.content)
		{
			return;
		}
		
		_loader.content.removeEventListener("ready", loaderContent_readyHandler);
		_loader.content.removeEventListener("error", loaderContent_errorHandler);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Loader
    //
    //--------------------------------------------------------------------------
	
	public function loader_initHandler(event:Event):void
	{
		factoryInfo =
		{
			factory: _loader.content as IModuleFactory,
			
			bytesLoaded: 0,
			bytesTotal: 0
		};
		
		var e:ModuleEvent;
		
		if(!factoryInfo.factory)
		{
			e = new ModuleEvent(ModuleEvent.ERROR);
			e.bytesLoaded = 0;
			e.bytesTotal = 0;
			e.message = "Object specified for load does not define a factory!";

			dispatchEvent(e);
			
			return;
		}
		
		attachContentListeners();
		
		//dispatch
	}
	
	public function loader_progressHandler(event:ProgressEvent):void
	{
		//factoryInfo.bytesLoaded = event.bytesLoaded;
		//factoryInfo.bytesTotal = event.bytesTotal;
		
		var e:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS);
		e.bytesLoaded = event.bytesLoaded;
		e.bytesTotal = event.bytesTotal;
		
		dispatchEvent(e);
	}
	
	public function loader_completeHandler(event:Event):void
	{
		factoryInfo.bytesLoaded = _loader.contentLoaderInfo.bytesLoaded;
		factoryInfo.bytesTotal = _loader.contentLoaderInfo.bytesTotal;
		
		var e:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS);
		e.bytesLoaded = factoryInfo.bytesLoaded;
		e.bytesTotal = factoryInfo.bytesTotal;
		
		dispatchEvent(e);
	}
	
	public function loader_errorHandler(event:ErrorEvent):void
	{
		_error = true;
		
		var e:ModuleEvent = new ModuleEvent(ModuleEvent.ERROR);
		e.message = event.text;
		
		dispatchEvent(e);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Content
    //
    //--------------------------------------------------------------------------
	
	public function loaderContent_readyHandler(event:Event):void
	{
		_ready = true;
		
		var e:ModuleEvent = new ModuleEvent(ModuleEvent.READY);
		e.bytesLoaded = factoryInfo.bytesLoaded;
		e.bytesTotal = factoryInfo.bytesTotal;
		
		clearLoader();
		
		dispatchEvent(e);
	}
	
	public function loaderContent_errorHandler(event:Event):void
	{
		_ready = true;
		
		var e:ModuleEvent =
			event as ModuleEvent ||
			new ModuleEvent(ModuleEvent.ERROR)
		;
		
		clearLoader();
		
		dispatchEvent(e);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Primitives: Overrides
    //
    //--------------------------------------------------------------------------
	
	override public function toString():String
	{
		return super.toString() + "\tready: " + _ready + "\tloaded: " + _loaded ;
	}
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ModuleProxy
//
////////////////////////////////////////////////////////////////////////////////

class ModuleProxy extends EventDispatcher implements IModule
{
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	private var _module:Module;
	private var _url:String;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion GestureWorks 1.6
     */
	public function ModuleProxy(module:Module)
	{
		super();
		
		if(!module)
		{
			throw new Error("Module passed for proxification cannot be null!");
		}
		
		_module = module;
		_url = module.url;
		
		_module.addEventListener(ModuleEvent.PROGRESS, moduleEventHandler, false, 0, true);
		_module.addEventListener(ModuleEvent.READY, moduleEventHandler, false, 0, true);
		_module.addEventListener(ModuleEvent.ERROR, moduleEventHandler, false, 0, true);
		_module.addEventListener(ModuleEvent.UNLOAD, moduleEventHandler, false, 0, true);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	public function get factory():IModuleFactory
	{
		return _module ? _module.factory : null ;
	}
	
	public function get error():Boolean
	{
		return _module ? _module.error : null ;
	}
	
	public function get loaded():Boolean
	{
		return _module ? _module.loaded : null ;
	}
	
	public function get ready():Boolean
	{
		return _module ? _module.ready : null ;
	}
	
	public function get url():String
	{
		return _url;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Loading
    //
    //--------------------------------------------------------------------------
	
	public function load
	(
		applicationDomain:ApplicationDomain = null,
		securityDomain:SecurityDomain = null,
		bytes:ByteArray = null/*,
		moduleFactory:IModuleFactory = null*/
	)
	:void
	{
		_module.reanimate();

		if(_module.error)
		{
			dispatchEvent(new ModuleEvent(ModuleEvent.ERROR));
		}
		else
		if(_module.loaded && _module.ready)
		{
			dispatchEvent(new ModuleEvent
			(
				ModuleEvent.PROGRESS,
				false,
				false,
				_module.factoryInfo.bytesTotal,
				_module.factoryInfo.bytesTotal
			));
			
			dispatchEvent(new ModuleEvent(ModuleEvent.READY));
		}
		else
		{
			_module.load(applicationDomain, securityDomain, bytes);
		}
	}

    //--------------------------------------------------------------------------
    //
    //  Methods: Unloading
    //
    //--------------------------------------------------------------------------
	
	public function release():void
	{
		
	}
	
	public function unload():void
	{
		_module.unload();
		
        _module.removeEventListener(ModuleEvent.PROGRESS, moduleEventHandler);
        _module.removeEventListener(ModuleEvent.READY, moduleEventHandler);
        _module.removeEventListener(ModuleEvent.ERROR, moduleEventHandler);
        _module.removeEventListener(ModuleEvent.UNLOAD, moduleEventHandler);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
	
    private function moduleEventHandler(event:ModuleEvent):void
    {
        dispatchEvent(event);
    }

}