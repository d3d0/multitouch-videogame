////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TactualObjectManager.as
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

import id.aggregators.IAggregator;
import id.core.ApplicationGlobals;
import id.core.ICluster;
import id.core.id_internal;
import id.core.IDisposable;
import id.core.ITactualObject;
import id.core.TouchObjectGlobals;

import flash.display.DisplayObject;

use namespace id_internal;

public class TactualObjectManager implements ITactualObjectManager, IValidationManagerClient, IDisposable
{

	private var _tactualObjects:Vector.<ITactualObject> = new Vector.<ITactualObject>();

	private var topLevel:Boolean;
	
	public function TactualObjectManager()
	{
	}
	
	public function Dispose():void
	{
	}


	public function get tactualClusters():Vector.<ITactualObject> { return gatherClusters(); }
	public function get tactualObjects():Vector.<ITactualObject> { return _tactualObjects; }
	public function get tactualObjectCount():int { return _tactualObjects.length; }


	private function gatherClusters():Vector.<ITactualObject>
	{
		var ret:Vector.<ITactualObject> = new Vector.<ITactualObject>();
		
		if(!_tactualObjects.length)
			return ret;
		
		var aggregator:IAggregator = ApplicationGlobals.aggregator;
		if(!aggregator)
			return ret;
			
		var tactualClusters:Vector.<ITactualObject> = aggregator.tactualClusters;
		
		var idx:uint;
		var found:Boolean;
		
		var tC:ICluster;
		var tO:ITactualObject;
		
		for each (tO in _tactualObjects)
		{
			found = false;
			for(idx=0; idx<tactualClusters.length; idx++)
			{
				tC = tactualClusters[idx] as ICluster;
				if(tC.hasTactualObject(tO))
				{
					found = true;
					break;
				}
			}
			
			if(found && ret.indexOf(tC) == -1)
			{
				ret.push(tC);
			}
		}
		
		return ret;
	}
	
	private function generateClusters():Vector.<ITactualObject>
	{
		var ret:Vector.<ITactualObject> = new Vector.<ITactualObject>();
		
		var tC:ITactualObject;
		var tO:ITactualObject;
		
		if(!_tactualObjects.length)
			return ret;
		
		var aggregator:IAggregator = ApplicationGlobals.aggregator;
		if(!aggregator)
			return ret;
		
		for each (tO in _tactualObjects)
		{
		}
		
		return ret;
	}


	public function addTactualObject(tO:ITactualObject):void
	{
		var index:int = _tactualObjects.indexOf(tO);
		if (index != -1)
			return;
		
		_tactualObjects.push(tO);
	}
	
	public function removeTactualObject(tO:ITactualObject):void
	{
		var index:int = _tactualObjects.indexOf(tO);
		if (index == -1)
			return;
		
		_tactualObjects.splice(index, 1);
	}
	
	public function validateTactualObjects():void
	{
	}
	
	
	

	
	
	
	/*
	public function getTactualObjectsAtPosition(x:Number, y:Number):Vector.<ITactualObject>
	{
		var tO:ITactualObject;
		var tOs:Vector.<ITactualObject> = new Vector.<ITactualObject>();

		for each(tO in _tactualObjects)
		{
			if(tO.x != x || tO.y != y)
			{
				continue;
			}
			
			tOs.push(tO);
		}
		
		return tOs;
	}
	
	public function getTactualObjectsByTarget(target:DisplayObject):Vector.<ITactualObject>
	{
		var tO:ITactualObject;
		var tOs:Vector.<ITactualObject> = new Vector.<ITactualObject>();
		
		for each(tO in _tactualObjects)
		{
			if(tO.target != target)
			{
				continue;
			}
			
			tOs.push(tO);
		}
		
		return tOs;
	}
	*/
	
	
}

}