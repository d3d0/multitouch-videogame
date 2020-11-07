////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Flosc.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.data.flosc
{

import id.core.ApplicationGlobals;
import id.core.ITactualObject;
import id.data.IInputProvider;
import id.events.DataProviderEvent;
import id.events.OSCReceiverEvent;
import id.net.osc.OSCPacket;
import id.net.osc.OSCBundle;
import id.net.osc.OSCReceiver;
import id.system.SystemHook;
import id.tracker.ITracker;
import id.utils.Enumerable;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.TimerEvent;
import flash.errors.IllegalOperationError;
import flash.utils.Timer;

/**
 * Dispatched when a connection to the data stream has failed or closed.
 * Calling the <code>Dispose()</code> method will automatically dispatch
 * this event.
 * 
 * <p>This event is always dispatched for use by the data provider
 * management systems in GestureWorks.</p>
 * 
 * @eventType id.events.DataProviderEvent.ERROR
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
[Event(name="error", type="id.events.DataProviderEvent")]

/**
 * Dispatched when a connection to the data stream is successful by either
 * the automated reconnection, if specified through the settings object, or
 * by calling the <code>bloom()</code> method.
 * 
 * <p>This event is always dispatched for use by the data provider
 * management systems in GestureWorks.</p>
 * 
 * @eventType id.events.DataProviderEvent.ESTABLISHED
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
[Event(name="established", type="id.events.DataProviderEvent")]

/**
 * The FLOSC data receiver enables application connectivity to optical
 * tracking software such as Community Core Vision and NUITeq Snowflake.
 * 
 * <p>This class interfaces as a wrapper around the OSCReceiver and has been
 * tested against the following optical solutions:</p>
 * 
 * <ul>
 *  <li>Community Core Vision 1.2</li>
 *  <li>Community Core Vision 1.3</li>
 *  <li>NUITeq Snowflake 1.0</li>
 *  <li>NUITeq Snowflake 1.1</li>
 *  <li>NUITeq Snowflake 1.2</li>
 *  <li>NUITeq Snowflake 1.3</li>
 *  <li>NUITeq Snowflake 1.5</li>
 *  <li>NUITeq Snowflake 1.6</li>
 *  <li>NUITeq Snowflake 1.8</li>
 *  <li>NUITeq Snowflake 1.9</li>
 * </ul>
 * 
 * <p>Other tracking solutions supporting FLOSC and GestureWorks will be 
 * added as they are developed and tested again.</p>
 * 
 * @see id.net.osc.OSCReceiver
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public final class Flosc extends SystemHook implements IInputProvider
{	
	private var _settings:Enumerable;
	
	private var _oscReceiver:OSCReceiver;
	private var _reconnectionTimer:Timer;
	private var _wasConnected:Boolean;
	
	private var _width:Number;
	private var _height:Number;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	public function Flosc()
	{
		_oscReceiver = new OSCReceiver();
		
		_oscReceiver.addEventListener(Event.CONNECT, oscReceiver_connectHandler);
		_oscReceiver.addEventListener(Event.CLOSE, oscReceiver_reconnectHandler);
		_oscReceiver.addEventListener(IOErrorEvent.IO_ERROR, oscReceiver_reconnectHandler);
		
		_oscReceiver.addEventListener(OSCReceiverEvent.PACKET_RECEIVED, oscReceiver_packetReceivedHandler);
	}

    //--------------------------------------------------------------------------
    //
    //  Destructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Destructor.
     *  
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	override public function Dispose():void
	{
		_oscReceiver.removeEventListener(Event.CONNECT, oscReceiver_connectHandler);
		_oscReceiver.removeEventListener(Event.CLOSE, oscReceiver_reconnectHandler);
		_oscReceiver.removeEventListener(IOErrorEvent.IO_ERROR, oscReceiver_reconnectHandler);
		
		_oscReceiver.removeEventListener(OSCReceiverEvent.PACKET_RECEIVED, oscReceiver_packetReceivedHandler);
		_oscReceiver.Dispose();
		
		_oscReceiver = null;
        
        dispatchEvent(new DataProviderEvent(DataProviderEvent.ERROR, false, false));
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Reconnection
	////////////////////////////////////////////////////////////
	private function initializeReconnection():void
	{
		if(_reconnectionTimer && _reconnectionTimer.running)
		{
			return;
		}
			
		if(_reconnectionTimer)
		{
			_reconnectionTimer.start();
			return;
		}
		
		if(_wasConnected)
		{
			_tracker.clear();
			_wasConnected = false;
		}
		
		_reconnectionTimer = new Timer(1000);
		_reconnectionTimer.addEventListener(TimerEvent.TIMER, reconnectionTimer_timerHandler);
		
		_reconnectionTimer.start();
	}

	private function disposeReconnection():void
	{
		if(!_reconnectionTimer)
			return;
		
		_reconnectionTimer.reset();
		_reconnectionTimer.removeEventListener(TimerEvent.TIMER, reconnectionTimer_timerHandler);
		
		_reconnectionTimer = null;
	}
	
	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	public function get settings():Enumerable { return _settings; }
	public function set settings(object:Enumerable):void
	{
		if(object == _settings)
			return;
			
		_settings = object;
		
		ApplicationGlobals.application.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		stage_resizeHandler(null);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Public
    //
    //--------------------------------------------------------------------------
    
    /**
     * This method effectively connects to the FLOSC data stream specified by
     * the settings object. If not set externally, attempts are made to connect
     * to localhost:3000.
     * 
     * @throws IllegalOperationError Setting must be defined before attempting
     * to start this data module
     * 
     * @throws IllegalOperationError Tracker must first be set to push data
     * into the system.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public function bloom():void
	{
		if(!_settings)
		{
			throw new IllegalOperationError("Settings must first be defined!");
		}
		   
		if(!_tracker)
		{
			throw new IllegalOperationError("Tracker must first be defined!");
		}
				
		try
		{
			_oscReceiver.connect(_settings.Host, _settings.Port);
		}
		catch(e:Error)
		{
			// suppress
		}
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: SystemHook Overrides
    //
    //--------------------------------------------------------------------------
    
    /**
     * Starts the parsing processes for the data stream.
     * 
     * <p>Not implemented at the moment.</p>
     */
	override public function start():void
	{
	}
	
    /**
     * Stops the parsing processes for the data stream.
     * 
     * <p>Not implemented at the moment.</p>
     */
	override public function stop():void
	{
	}
	
    /**
     * Restarts the parsing processes for the data stream.
     * 
     * <p>Not implemented at the moment.</p>
     */
	override public function restart():void
	{
	}

	////////////////////////////////////////////////////////////
	// Events: OSCReceiver
	////////////////////////////////////////////////////////////
	private function oscReceiver_connectHandler(event:Event):void
	{		
		_wasConnected = true;
		disposeReconnection();
		
		dispatchEvent(new DataProviderEvent(DataProviderEvent.ESTABLISHED, false, false));
	}
	
	private function oscReceiver_reconnectHandler(event:Event):void
	{		
		if(_settings.AutoReconnect)
		{
			initializeReconnection();
		}
        
		dispatchEvent(new DataProviderEvent(DataProviderEvent.ERROR, false, false));
	}
	
	private function oscReceiver_packetReceivedHandler(event:OSCReceiverEvent):void
	{
		/*CONFIG::DEBUG
		{
		var startTime:Number = getTimer();
		}*/
		
		var idx:uint;
		var index:int;
		var packet:OSCPacket = event.packet;
		
		var aliveIDs:Array = [];
		var additionIDs:Array = [];
		var updateIDs:Array = [];
		
		var additionList:Vector.<Object> = new Vector.<Object>();
		var removalList:Vector.<Object> = new Vector.<Object>();
		var updateList:Vector.<Object> = new Vector.<Object>();
		
		// create an id list
		for(idx=0; idx<packet.alive.length; idx++)
		{
			aliveIDs.push(packet.alive[idx].values[0]);
		}
		
		// update and remove
		for each (var tO:ITactualObject in _tracker.tactualObjects)
		{
			//var tO:ITactualObject = _tracker.tactualObjects[k];

			if ((index = aliveIDs.indexOf(tO.id)) != -1)
			{
				updateIDs.push(tO.id);
				aliveIDs.splice(index, 1);
			}
			else
			{
				removalList.push({id: tO.id});
			}
		}
		
		// new
		for(idx=0; idx<aliveIDs.length; idx++)
		{
			additionIDs.push(aliveIDs[idx]);
		}
		
		// params for new and update
		for(idx=0; idx<packet.set.length; idx++)
		{
			var values:Array = packet.set[idx].values;
			
			if ((index = updateIDs.indexOf(values[0])) != -1)
			{
				updateList.push(
				{
					id: values[0],
					
					x: int(values[1] * _width),
					y: int(values[2] * _height),
					dx: values[3] * _width,
					dy: values[4] * _height,
					m: values[5]
				});
				
				//trace("u:", updateList[index].x, updateList[index].y);
			}
			else
			if((index = additionIDs.indexOf(values[0])) != -1)
			{
				additionList.push(
				{
					id: values[0],
					
					x: int(values[1] * _width),
					y: int(values[2] * _height),
					dx: values[3] * _width,
					dy: values[4] * _height,
					m: values[5]
				});
				
				//trace("a:", updateList[index].x, updateList[index].y);
			}
		}
		
		//trace(additionList.length, removalList.length, updateList.length);
		
		_tracker.queueAdditions(additionList);
		_tracker.queueRemovals(removalList);
		_tracker.queueUpdates(updateList);
		
		event.packet = null;
	}
	
	////////////////////////////////////////////////////////////
	// Events: Reconnection Timer
	////////////////////////////////////////////////////////////
	private function reconnectionTimer_timerHandler(event:TimerEvent):void
	{
		_reconnectionTimer.stop();
		
		bloom();
	}

	////////////////////////////////////////////////////////////
	// Events: Stage
	////////////////////////////////////////////////////////////
	private function stage_resizeHandler(event:Event):void
	{
		_width = _settings.EnforceSize ? _settings.Width : ApplicationGlobals.application.stage.stageWidth ;
		_height = _settings.EnforceSize ? _settings.Height : ApplicationGlobals.application.stage.stageHeight ;
	}
	
	////////////////////////////////////////////////////////////
	// Events: TrackerHook
	////////////////////////////////////////////////////////////
    
    /**
     * @private
     * 
     * @param tracker
     */
	override protected function onTrackerChanged(tracker:ITracker):void
	{
		// do stuff
	}
	
}

}