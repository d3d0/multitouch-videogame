////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	DataManager.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.managers
{

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.system.Security;

/**
 * Loads a configuration file and provides access to the underlying XML.
 * 
 * <p>This singleton can be referenced via <code>ApplicationGlobals.dataManager</code></p>
 * 
 * @see id.core.Application#initialize() id.core.Application.initialize() -- an example using the DataManager.
 */
public class DataManager extends EventDispatcher implements IDataManager
{
	
	include "../core/Version.as";
	
	////////////////////////////////////////////////////////////
	// Singleton data and functions
	////////////////////////////////////////////////////////////
	private static var _instance:DataManager = new DataManager();
	/**
	 * @return The DataManager singleton.
	 */
	public static function getInstance():DataManager {
		return _instance;
	}
	
	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	/**
	 * @private
	 */
	public function DataManager() {
		super();
		
		_dataLoader = new URLLoader();
		
		_dataLoader.addEventListener(Event.COMPLETE, dataLoader_completeHandler);
		_dataLoader.addEventListener(IOErrorEvent.IO_ERROR, dataLoader_errorHandler);
		_dataLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dataLoader_errorHandler);
		
		//Security.allowDomain("*");
	}
	
	////////////////////////////////////////////////////////////
	// Singleton State Data
	////////////////////////////////////////////////////////////
	
	
	////////////////////////////////////////////////////////////
	// Singleton Variables
	////////////////////////////////////////////////////////////
	private var _data:XML;
	private var _dataPath:String;
	private var _dataLoader:URLLoader;
	
	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	/**
	 * Returns the XML object corresponding to the data loaded with the
	 * <code>dataPath</code> method.
	 * 
	 * @see dataPath
	 */
	public function get data():XML { return _data; }
	public function set data(value:XML):void
	{
		if(value == _data)
			return;
			
		_data = value;
	}
	
	/**
	 * Shortcut to the <code>components</code> configuration options.
	 */
	public function get components():XMLList { return _data.Components; }
	
	/**
	 * Shortcut to the <code>touchCore</code> configuration options.
	 */
	public function get touchCore():XMLList { return _data.TouchCore; }
	
	/**
	 * Shortcut to the <code>touchPhysics</code> configuration options.
	 */
	public function get touchPhysics():XMLList { return _data.TouchPhysics; }
	
	/**
	 * Shortcut to the <code>touchLib</code> configuration options.
	 */
	public function get touchLib():XMLList { return _data.TouchLib; }
	
	/**
	 * Establishes the path to the application settings xml file.  When defined,
	 * the DataManager automatically creates a loader and attempts to open
	 * the specified location.
	 * 
	 * @return The URL of the configuration file currently loaded.
	 */
	public function get dataPath():String { return _dataPath; }
	public function set dataPath(value:String):void {
		if(_dataPath == value) return;
		
		_dataPath = value;
		_dataLoader.load(new URLRequest(_dataPath));
	}

	////////////////////////////////////////////////////////////
	// Methods: dataLoader Event Handlers
	////////////////////////////////////////////////////////////
	
	/**
	 * Dispatches IOErrorEvent/SecurityErrorEvent in the case that
	 * the dataPath URL fails to load.
	 */
	private function dataLoader_errorHandler(event:IOErrorEvent):void
	{
		dispatchEvent(event);
	}
	
	/**
	 * Dispatches a COMPLETE event when the <code>dataPath</code> value loads
	 * successfully. 
	 */
	private function dataLoader_completeHandler(event:Event):void
	{
		_data = new XML(_dataLoader.data);
		dispatchEvent(event);
	}
	
}
	
}