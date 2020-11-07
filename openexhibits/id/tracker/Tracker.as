////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Tracker.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.tracker
{

import id.core.IDisposable;
import id.core.ApplicationGlobals;
import id.core.ITactualObject;
import id.core.TactualObject;
import id.core.TactualObjectState;
import id.core.TactualObjectType;
import id.managers.ValidationManagerHook;
import id.utils.StringUtil;

import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flash.utils.getTimer;

public final class Tracker extends ValidationManagerHook implements ITracker, IDisposable
{

	include "../core/Version.as";
	
	////////////////////////////////////////////////////////////
	// Singleton data and functions
	////////////////////////////////////////////////////////////
	private static var _instance:Tracker = new Tracker();
	public static function getInstance():Tracker {
		return _instance;
	}
	
	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	public function Tracker() {
	if(!_instance)
	{
		super();
		
		_internalClock = new Timer(Math.max(1000 / _frequency, 1));
		_internalClock.addEventListener(TimerEvent.TIMER, doPhasedDeQueue);
				
		start();
	}
	else
	{
		throw new IllegalOperationError("The tracker may not be directly instanciated!");
	}
	}
	
	override public function Dispose():void
	{
		throw new IllegalOperationError("The Tracker may not be directly disposed!");
	}
	
	////////////////////////////////////////////////////////////
	// Tracker Variables
	////////////////////////////////////////////////////////////
	private var _tactualObjects:Dictionary = new Dictionary();
	
	private var _tactualObjects_added:Vector.<uint> = new Vector.<uint>();	
	private var _tactualObjects_removed:Vector.<uint> = new Vector.<uint>();
	private var _tactualObjects_updated:Vector.<uint> = new Vector.<uint>();
	
	private var _tactualObjects_dead:Vector.<ITactualObject> = new Vector.<ITactualObject>();
	
	private var _frequency:uint = 60;
	private var _ghostTolerance:uint = 10;
	
	private var _tactualObjectCount:uint = 0;
	private var _internalTime:Number = 0;
	
	private var _crippled:Boolean = false;
	
//	private var _validationPendingFlag:Boolean = false;
//	private var _additionPendingFlag:Boolean = false;
//	private var _removalPendingFlag:Boolean = false;
//	private var _updatePendingFlag:Boolean = false;
	
	////////////////////////////////////////////////////////////
	// Queue/DeQueue Variables
	////////////////////////////////////////////////////////////
	/* queue/dequeue */
	private var _additionQueue:Vector.<Object>;
	private var _additionQueueFlag:Boolean;
	
	private var _updateQueue:Vector.<Object>;
	private var _updateQueueFlag:Boolean;
	
	private var _removalQueue:Vector.<Object>;
	private var _removalQueueFlag:Boolean;
	
	/* timer */
	private var _internalClock:Timer;
	
	/*CONFIG::DEBUG
	{
	private var _messageStart:Number;
	
	private var _messageCount:Number;
	private var _messageAdditions:Number;
	private var _messageRemovals:Number;
	private var _messageUpdates:Number;

	private var _messageTimer:Timer;
	
	private var _startTime:Number;
	private var _totalTime:Number;
	}*/
	
	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	public function get tactualObjects():Dictionary { return _tactualObjects; }
	public function get tactualObjectCount():uint { return _tactualObjectCount; }
	
	public function get additionList():Vector.<uint> { return _tactualObjects_added; }
	public function get removalList():Vector.<uint> { return _tactualObjects_removed; }
	
	public function get frequency():uint { return _frequency; }
	public function set frequency(value:uint):void
	{
		if(value == 0 || value > 1000)
			return;
		
		_internalClock.delay = Math.floor(1000 / value);
		_frequency = value;
	}
	
	public function get ghostTolerance():uint { return _ghostTolerance; }
	public function set ghostTolerance(value:uint):void
	{
		if(value == 0)
			return;
			
		_ghostTolerance = value;
	}

	////////////////////////////////////////////////////////////
	// Methods: DeQueueing
	////////////////////////////////////////////////////////////
	private function doPhasedDeQueue(event:TimerEvent):void
	{
		/*CONFIG::DEBUG
		{
			_startTime = getTimer();
		}*/
		
		//trace(this, "dequeueing tactual objects on:", ApplicationGlobals.application.currentFrame);
		
		if(_additionQueueFlag)
		{
			deQueueAddition();
		}
		
		if(_updateQueueFlag)
		{
			deQueueUpdate();
		}
		
		if(_removalQueueFlag)
		{
			deQueueRemoval();
		}

		var tO:ITactualObject;
		var tOhistory:Vector.<Object>;
		
		var time:Number = getTimer();

		for(var idx:uint=0; idx<_tactualObjects_dead.length; idx++)
		{
			tO = _tactualObjects_dead[idx];
			tOhistory = tO.history;
			
			if(time - tOhistory[tOhistory.length - 1].time < 200)
			{
				continue;
			}

			_tactualObjects_dead.splice(idx, 1);							// not a bottle neck, faster then Vector.filter(), but bad practice
			
			tO.Dispose();
			tO = null;

			idx--;
		}
		
		/*CONFIG::DEBUG
		{
		_messageCount++;
		_totalTime += getTimer() - _startTime;
		}*/
	}
	
	private function deQueueAddition():void
	{
		var tO:Object;
		
		var fdx:uint;
		var fdx_t:uint;
		
		var fdy:uint;
		var fdy_t:uint;
		
		var fO:ITactualObject;
		var tempO:ITactualObject;
		
		var tactualObject:ITactualObject;
		var tactualObject_existences:uint = 1;

		for(var idx:uint=0; idx<_additionQueue.length; idx++)
		{
			tO = _additionQueue[idx];
			if(_tactualObjects.hasOwnProperty(tO.id))
			{
				continue;
			}
			
			fdx = uint.MAX_VALUE;
			fdy = uint.MAX_VALUE;
			
			for(var idk:uint=0; idk<_tactualObjects_dead.length; idk++)
			{
				tempO = _tactualObjects_dead[idk];
				
				fdx_t = tempO.x - tempO.x < 0 ? (tempO.x - tempO.x) * -1 : tempO.x - tempO.x ;
				fdy_t = tempO.y - tempO.y < 0 ? (tempO.y - tempO.y) * -1 : tempO.y - tempO.y ;

				if(fdx_t + fdy_t < fdx + fdy)
				{
					fdx = fdx_t;
					fdy = fdy_t;
					
					fO = tempO;
				}
			}
			
			if(fdx < _ghostTolerance && fdy < _ghostTolerance)
			{
				tactualObject_existences += fO.existences;
			}
			
			tactualObject = new TactualObject(TactualObjectType.POINT);
			tactualObject.existences = tactualObject_existences;
			for(var k:String in tO)
			{
				tactualObject[k] = tO[k];
			}

			_tactualObjects[tO.id] = tactualObject;
			_tactualObjects[tO.id].state = TactualObjectState.ADDED;
			
			_tactualObjects_added.push(tO.id);
			
			_tactualObjectCount++;
			
			/*CONFIG::DEBUG
			{
			_messageAdditions++;
			}*/
		}
		
		_additionQueue = null;
		_additionQueueFlag = false;
	}
	
	private function deQueueRemoval():void
	{
		var tO:Object;
		
		var index:int;
		var state:int;
		
		for(var idx:uint=0; idx<_removalQueue.length; idx++)
		{
			tO = _removalQueue[idx];
			if(!_tactualObjects.hasOwnProperty(tO.id))
			{
				continue;
			}
			
			index = _tactualObjects_removed.indexOf(tO.id);
			if(index != -1)
			{
				continue;
			}
			
			state = _tactualObjects[tO.id].state;
			
			if(_tactualObjects[tO.id].state == TactualObjectState.ADDED)
			{
				//trace("destroying tactual object");
				
				_tactualObjects[tO.id].Dispose();
				_tactualObjects[tO.id] = null;
				
				_tactualObjectCount--;
				delete _tactualObjects[tO.id];
			}
			else
			{
				_tactualObjects[tO.id].state = TactualObjectState.REMOVED;
				_tactualObjects_removed.push(tO.id);
			}

			/*CONFIG::DEBUG
			{
			_messageRemovals++;
			}*/

		}
		
		_removalQueue = null;
		_removalQueueFlag = false;
	}
	
	private function deQueueUpdate():void
	{
		var tO:Object;

		for(var idx:uint=0; idx<_updateQueue.length; idx++)
		{
			tO = _updateQueue[idx];
			if(!_tactualObjects.hasOwnProperty(tO.id))
			{
				continue;
			}
			
			for(var k:String in tO)
			{
				_tactualObjects[tO.id][k] = tO[k];
			}

			/*CONFIG::DEBUG
			{
			_messageUpdates++;
			}*/

			if(_tactualObjects[tO.id].state & TactualObjectState.ADDED)
			{
				continue;
			}
			
			/*if(!_updatePendingFlag)
			{
				_tactualObjects[tO.id].pushSnapshot();
			}*/
			
			_tactualObjects[tO.id].state = TactualObjectState.UPDATED;
			
			/*
			if(_tactualObjects_updated.indexOf(tO.id) != -1)
				continue;
				
			_tactualObjects_updated.push(tO.id);
			*/
		}
		
		_updateQueue = null;
		_updateQueueFlag = false;
		
		//_updatePendingFlag = true;
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Queueing
	////////////////////////////////////////////////////////////
	public function queueAddition(object:Object):void
	{
		if(_crippled)
		{
			return;
		}
		
		/*CONFIG::DEBUG
		{
			_startTime = getTimer();
		}*/

		if(!object)
		{
			return;
		}

		if(!_additionQueue)
		{
			_additionQueue = new Vector.<Object>();
		}
		
		_additionQueue.push(object);
		_additionQueueFlag = true;
		
		/*CONFIG::DEBUG
		{
			_totalTime += getTimer() - _startTime ;
		}*/
	}
	
	public function queueAdditions(collection:Vector.<Object>):void
	{
		if(_crippled)
		{
			return;
		}
			
		/*CONFIG::DEBUG
		{
			_startTime = getTimer();
		}*/
		
		if(!collection.length)
		{
			return;
		}

		if(!_additionQueue)
		{
			_additionQueue = new Vector.<Object>();
		}

		// non-integrated data copy is slow, this is the quickest method of data transfer
		_additionQueue = _additionQueue.concat(collection);
		_additionQueueFlag = true;
		
		/*CONFIG::DEBUG
		{
			_totalTime += getTimer() - _startTime ;
		}*/
	}
	
	public function queueRemoval(object:Object):void
	{
		if(_crippled)
		{
			return;
		}
		
		/*CONFIG::DEBUG
		{
			_startTime = getTimer();
		}*/
		
		if(!object)
		{
			return;
		}
		
		if(!_removalQueue)
		{
			_removalQueue = new Vector.<Object>();
		}

		_removalQueue.push(object);
		_removalQueueFlag = true;
		
		/*CONFIG::DEBUG
		{
			_totalTime += getTimer() - _startTime ;
		}*/
	}
	
	public function queueRemovals(collection:Vector.<Object>):void
	{
		if(_crippled)
		{
			return;
		}
		
		/*CONFIG::DEBUG
		{
			_startTime = getTimer();
		}*/
		
		if(!collection.length)
		{
			return;
		}
		
		if(!_removalQueue)
		{
			_removalQueue = new Vector.<Object>();
		}

		// non-integrated data copy is slow, this is the quickest method of data transfer
		_removalQueue = _removalQueue.concat(collection);
		_removalQueueFlag = true;
		
		/*CONFIG::DEBUG
		{
			_totalTime += getTimer() - _startTime ;
		}*/
	}
	
	public function queueUpdate(object:Object):void
	{
		if(_crippled)
		{
			return;
		}
		
		/*CONFIG::DEBUG
		{
			_startTime = getTimer();
		}*/
		
		if(!object)
		{
			return;
		}
		
		if(!_updateQueue)
		{
			_updateQueue = new Vector.<Object>();
		}
		
		// non-integrated data copy is slow, this is the quickest method of data transfer
		_updateQueue.push(object);
		_updateQueueFlag = true;
		
		/*CONFIG::DEBUG
		{
			_totalTime += getTimer() - _startTime ;
		}*/		
	}
	
	public function queueUpdates(collection:Vector.<Object>):void
	{
		if(_crippled)
		{
			return;
		}
		
		/*CONFIG::DEBUG
		{
			_startTime = getTimer();
		}*/
		
		if(!collection.length)
		{
			return;
		}
		
		if(!_updateQueue)
		{
			_updateQueue = new Vector.<Object>();
		}
		
		// non-integrated data copy is slow, this is the quickest method of data transfer
		_updateQueue = _updateQueue.concat(collection);
		_updateQueueFlag = true;
		
		/*CONFIG::DEBUG
		{
			_totalTime += getTimer() - _startTime ;
		}*/
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Validation Cycles
	////////////////////////////////////////////////////////////
	override public function validationComplete():void
	{
		/*CONFIG::DEBUG
		{
			_startTime = getTimer();
		}*/
		
		//trace("tracker::cleaning up on:", ApplicationGlobals.application.currentFrame);
		
		processAdded();
		processRemoved();
		
		for each (var tO:ITactualObject in _tactualObjects)
		{
			tO.pushSnapshot();
		}
		
		/*CONFIG::DEBUG
		{
			_totalTime += getTimer() - _startTime ;
		}*/
	}
	
	private function processAdded(/*id:Number = NaN*/):void
	{
		var id:uint;
		
		for(var idx:uint=0; idx<_tactualObjects_added.length; idx++)
		{			
			id = _tactualObjects_added[idx];
			
			if(!_tactualObjects.hasOwnProperty(id))
			{
				continue;
			}
			
			_tactualObjects[id].state = TactualObjectState.NONE;
		}
		
		_tactualObjects_added = null;
		_tactualObjects_added = new Vector.<uint>();
	}
	
	private function processRemoved(/*id:Number = NaN*/):void
	{
		var id:uint;
		var tO:ITactualObject;
		
		for(var idx:uint=0; idx<_tactualObjects_removed.length; idx++)
		{
			id = _tactualObjects_removed[idx];
			
			if(!_tactualObjects.hasOwnProperty(id))
			{
				continue;
			}
	
			tO = _tactualObjects[id];
	
			tO.disposeAggregator();
			tO.disposeChild();
			tO.pushSnapshot();
			
			_tactualObjects_dead.push(tO);
			_tactualObjectCount--;
			
			delete _tactualObjects[id];
		}
		
		_tactualObjects_removed = null;
		_tactualObjects_removed = new Vector.<uint>();
	}
	
	private function processUpdated(/*id:Number = NaN*/):void
	{
		var id:Number;
		
		for(var idx:uint=0; idx<_tactualObjects_updated.length; idx++)
		{
			id = _tactualObjects_updated[idx];
			
			if(!_tactualObjects.hasOwnProperty(id))
			{
				continue;
			}
			
			_tactualObjects[id].pushSnapshot();
		}
		
		_tactualObjects_updated = null;
		_tactualObjects_updated = new Vector.<uint>();
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Clustering
	////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////
	// Methods: Control
	////////////////////////////////////////////////////////////
	public function cripple():void
	{
		_crippled = true;
	}
	
	public function start():void
	{
		if(_crippled)
			return;
			
		_internalClock.start();
	}
	
	public function stop():void
	{
		if(_crippled)
			return;
			
		_internalClock.stop();
	}
	
	public function reset():void
	{
		if(_crippled)
			return;
	}
	
	public function clear():void
	{
		if(!_tactualObjectCount)
			return;
		
		var removalQueue:Vector.<Object> = new Vector.<Object>();
		var tO:ITactualObject;
		
		for each (tO in _tactualObjects)
		{
			removalQueue.push({id: tO.id});
		}
		
		queueRemoval(removalQueue);
	}
	
}

}