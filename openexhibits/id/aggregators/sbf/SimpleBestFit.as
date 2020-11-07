////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	SimpleBestFit.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.aggregators.sbf
{

import id.core.id_internal;
import id.aggregators.Aggregator;
import id.aggregators.IAggregator;
import id.core.ApplicationGlobals;
import id.core.Cluster;
import id.core.ICluster;
import id.core.ITactualObject;
import id.core.TactualObjectType;

import flash.display.Graphics;
import flash.geom.Point;
import flash.system.Capabilities;

use namespace id_internal;

/**
 * Best described by its class name, this Aggregator performs a best fit
 * calculation with regards to creating application clusters. Modified
 * from its original found in GestureWorks Alpha, it now supports internal
 * cluster rearrangement and point reassociation in the form of dynamic seed
 * alocation and optomization.
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public class SimpleBestFit extends Aggregator
{

    //--------------------------------------------------------------------------
    //
    //  Config: Debug
    //
    //--------------------------------------------------------------------------
    	
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
	private static var TEMPORAL_MAX:Number = 0.5;
	private static var SPATIAL_MAX:Number = 7 * Capabilities.screenDPI;
	private static var VALIDITY_TOLERANCE:Number = 0.4;
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
	private var _tactualClusterDebugColor:Vector.<uint>;
	private var _tactualObjectQueue:Vector.<ITactualObject>;
	
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
	public function SimpleBestFit()
	{
		super();
				
		_tactualClusterDebugColor = new Vector.<uint>();
		_tactualObjectQueue = new Vector.<ITactualObject>();
		ApplicationGlobals.tactualObjectDebugger.registerCallback(draw);
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
	}

    //--------------------------------------------------------------------------
    //
    //  Methods: Private
    //
    //--------------------------------------------------------------------------
    
    /**
     * Compares two tactual objects and returns a number between 0 and 1 that
     * represents the relationship of tO_2 to tO_1 as a weighted value, 30%
     * temporal and 70% spacial.
     */
	private function compareTactualObjects(tO_1:ITactualObject, tO_2:ITactualObject):Number
	{
		var temporal:Number;
		var spatial:Number;
		
		var tC_1:ICluster;
		var tC_2:ICluster;		
		
		if(tO_1.type == TactualObjectType.CLUSTER && tO_2.type == TactualObjectType.CLUSTER)
		{
			tC_1 = tO_1 as ICluster;
			tC_2 = tO_2 as ICluster;

			temporal = (tC_1.tactualObjectCount + tC_2.tactualObjectCount <= 5) ? (1 - Math.min( TEMPORAL_MAX, Math.abs(tO_1.creationTime - tO_2.creationTime) ) / TEMPORAL_MAX) : 0 ;
			spatial = (tC_1.tactualObjectCount + tC_2.tactualObjectCount <= 5) ? (1 - Math.min( SPATIAL_MAX, Point.distance(new Point(tO_1.x, tO_1.y), new Point(tO_2.x, tO_2.y)) ) / SPATIAL_MAX) : 0 ;
		}
		else
		if(tO_1.type == TactualObjectType.CLUSTER)
		{
			temporal = (tO_1 as ICluster).tactualObjectCount < 5 ? (1 - Math.min( TEMPORAL_MAX, Math.abs(tO_1.creationTime - tO_2.creationTime) ) / TEMPORAL_MAX) : 0 ;
			spatial = (tO_1 as ICluster).tactualObjectCount < 5 ? (1 - Math.min( SPATIAL_MAX, Point.distance(new Point(tO_1.x, tO_1.y), new Point(tO_2.x, tO_2.y)) ) / SPATIAL_MAX) : 0 ;
		}
		else
		{
			temporal = 1 - Math.min( TEMPORAL_MAX, Math.abs(tO_1.creationTime - tO_2.creationTime) ) / TEMPORAL_MAX ;
			spatial = 1 - Math.min( SPATIAL_MAX, Point.distance(new Point(tO_1.x, tO_1.y), new Point(tO_2.x, tO_2.y)) ) / SPATIAL_MAX ;
		}

		return temporal * 0.3 + spatial * 0.7 ;
	}
    
    /**
     * Places the determined relationship of tO based on its validity into the 
     * aggregate collection at its respective position in the validity heirarchy.
     * 
     */
	private function manageTactualObjectValidity(tO:ITactualObject, validity:Number, aggregate_tO:Vector.<ITactualObject>, aggregate_value:Vector.<Number>):void
	{
		var idx:uint;
		
		var tO:ITactualObject;
		var tO_validity:Number;
		
		if(validity < VALIDITY_TOLERANCE)
			return;

		for(idx=0; idx<aggregate_value.length; idx++)
		{
			tO_validity = aggregate_value[idx];
			if(validity < tO_validity)
				continue;
			
			aggregate_tO.splice(idx, 0, tO);
			aggregate_value.splice(idx, 0, validity);
			
			return;
		}
		
		aggregate_tO.push(tO);
		aggregate_value.push(validity);
	}
	
    /**
     * Generates a random color used for identifing clusters.
     */
	private function generateRandomColor():uint
	{
		return Math.random() * 0xFFFFFF;
	}
	
    /**
     * This method is passed to the <code>TactualObjectDebugger</code> and
     * registered as a draw method.  This executes at the application's
     * framerate.
     */
	private function draw(target:Graphics):void
	{
		var idx:uint;
		var idk:uint;
		
		var tC:ICluster;
		var tO:ITactualObject;
		var tO_seed:Boolean;

        /*
		if(_tactualClusters.length > ApplicationGlobals.tracker.tactualObjectCount)
		{
			trace("NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
		}
        */

		for(idx=0; idx<_tactualClusters.length; idx++)
		{
			tC = _tactualClusters[idx] as ICluster;
			tO_seed = true;
			
			target.lineStyle(4, _tactualClusterDebugColor[idx], 0.75);
			for each(tO in tC.tactualObjects)
			{
				if( tO_seed)
				{
					target.drawRect(tO.x - 6, tO.y - 6, 12, 12);
					tO_seed = false;
				}
				
				target.drawCircle(tO.x, tO.y, 6);
			}
		}
		
		target.lineStyle(4, 0xffffff, 0.75);
		for(idx=0; idx<_tactualObjectQueue.length; idx++)
		{
			tO = _tactualObjectQueue[idx];
			target.drawCircle(tO.x, tO.y, 15);
		}
	}
    
    /**
     * Math.abs without having to incur the overhead.
     */
	private function math_abs(value:Number):Number
	{
		return value < 0 ? value * -1 : value ;
	}
    
    /**
     * Math.min without having to incur the overhead.
     */
	private function math_min(value1:Number, value2:Number):Number
	{
		return value1 < value2 ? value1 : value2 ;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Method Overrides: Aggregator
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
	override public function addTactualObject(tO:ITactualObject):void
	{		
		_tactualObjectQueue.push(tO);
	}
    
    /**
     * @private
     */
	override public function removeTactualObject(tO:ITactualObject):void
	{		
		var cO:ICluster;
		var idx:uint;
		
		var index:int = _tactualObjectQueue.indexOf(tO);
		if (index != -1)
		{
			_tactualObjectQueue.splice(index, 1);
		}
		
		for(idx=0; idx<_tactualClusters.length; idx++)
		{
			cO = _tactualClusters[idx] as ICluster;
			cO.removeTactualObject(tO);

			//if(cO.tactualObjects.length)
			if(cO.tactualObjects.length > 1)
				continue;
			
			if(cO.tactualObjects.length)
				_tactualObjectQueue.push(cO.tactualObjects[0]);
			
			cO.Dispose();
			cO = null;
			
			_tactualClusters.splice(idx, 1);
			_tactualClusterDebugColor.splice(idx, 1);
			
			//if(!idx)
			//	continue;
			
			idx--;
		}
	}
	
    /**
     * @private
     */
	override public function validationBeginning():void
	{		
		var aggregate_tO:Vector.<ITactualObject>;
		var aggregate_value:Vector.<Number>;
		var aggregate_total:Number = 0;
		
		var idx:uint;
		var idk:uint;
		var index:int;
		
		var tC:ICluster;//ITactualObject;
		var tC_seed:ICluster;
		var tC_seedPair:ICluster;
		var tC_seedPair_validity:Number;
		
		var tO:ITactualObject;
		var tO_seed:ITactualObject;
		
		var validity:Number;
		
		/*
		// destroy similar cluster-clusters
		for(idx=0; idx<_tactualClusters.length; idx++)
		{
			tC_seed = _tactualClusters[idx] as ICluster;
			tC_seedPair_validity = 0;
			
			for(idk=0; idk<_tactualClusters.length; idk++)
			{
				tC = _tactualClusters[idk] as ICluster;
				
				if(tC_seed == tC)
				{
					continue;
				}
				
				validity = compareTactualObjects(tC, tC_seed);
				if(validity < VALIDITY_TOLERANCE)
				{
					continue;
				}
				
				if(validity > tC_seedPair_validity)
				{
					tC_seedPair_validity = validity;
					tC_seedPair = tC;
				}
			}
			
			if(!tC_seedPair)
			{
				continue;
			}
						
			// break apart both? or just one?
			// both
			//if(tC_seed.tactualObjectCount < tC_seedPair.tactualObjectCount)
			//{
				while(tC_seed.tactualObjectCount)
				{
					_tactualObjectQueue.push(tC_seed.tactualObjects[0])
					tC_seed.tactualObjects.splice(0, 1);
				}
				
				index = _tactualClusters.indexOf(tC_seed);
				if(index == -1)
				{
					throw new Error("tC_seed not found!");
				}
				
				_tactualClusters.splice(index, 1);
				_tactualClusterDebugColor.splice(index, 1);
				
				tC_seed.Dispose();
				tC_seed = null;
			//}
			//else
			//{
				while(tC_seedPair.tactualObjectCount)
				{
					_tactualObjectQueue.push(tC_seedPair.tactualObjects[0])
					tC_seedPair.tactualObjects.splice(0, 1);
				}
				
				index = _tactualClusters.indexOf(tC_seedPair);
				if(index == -1)
				{
					throw new Error("tC_seedPair not found!");
				}
				
				_tactualClusters.splice(index, 1);
				_tactualClusterDebugColor.splice(index, 1);
				
				tC_seedPair.Dispose();
				tC_seedPair = null;
			//}
		}
		*/
		
		// rearrange internal cluster points
		for(idx=0; idx<_tactualClusters.length; idx++)
		{
			tC = _tactualClusters[idx] as ICluster;
			
			for(idk=0; idk<tC.tactualObjectCount; idk++)
			{
				if(!idk)
				{
					tO_seed = tC.tactualObjects[idk];
					continue;
				}
				
				tO = tC.tactualObjects[idk];
				validity = compareTactualObjects(tO_seed, tO);
				if(validity >= VALIDITY_TOLERANCE)
				{
					continue;
				}
				
				tC.removeTactualObject(tO);
				if(!tC.tactualObjectCount)
				{
					throw Error("I Should be doing something about this");
				}
				idk--;
				
				index = _tactualObjectQueue.indexOf(tO);
				//trace("index:", index, ApplicationGlobals.tracker.tactualObjects.hasOwnProperty(tO.id));
				//if(index != -1)
				//	continue;
				
				_tactualObjectQueue.push(tO);
			}
		}
		
		// determine existing additions
		for(idx=0; idx<_tactualClusters.length; idx++)
		{
			tC = _tactualClusters[idx] as ICluster;
			for(idk=0; idk<_tactualObjectQueue.length; idk++)
			{
				tO = _tactualObjectQueue[idk];
				validity = compareTactualObjects(tC, tO);
				
				if(validity < VALIDITY_TOLERANCE)
				{
					continue;
				}
				
				//(tC as ICluster).addTactualObject(tO);
				tC.addTactualObject(tO);
				_tactualObjectQueue.splice(idk, 1);
				
				/*if(!idk)
				{
					continue;
				}*/
				
				idk--;
			}
		}
		
		// destroy clusters with tactual objects of 1 or less
		for(idx=0; idx<_tactualClusters.length; idx++)
		{
			tC = _tactualClusters[idx] as ICluster;
			
			if(tC.tactualObjects.length > 1)
			{
				continue;
			}
			
			_tactualClusters.splice(idx, 1);
			_tactualClusterDebugColor.splice(idx, 1);
			
			_tactualObjectQueue.push(tC.tactualObjects.pop());
			
			tC.Dispose();
			tC = null;

			idx--;
		}

		// determine new clusters
		while(_tactualObjectQueue.length)
		{
			for(idx=0; idx<_tactualObjectQueue.length; idx++)
			{
				var a_tO:Vector.<ITactualObject> = new Vector.<ITactualObject>();
				var a_value:Vector.<Number> = new Vector.<Number>();
				
				tO_seed = _tactualObjectQueue[idx];
				
				for each(tO in _tactualObjectQueue)
				{
					/*if(tO == tO_seed)
					{
						continue;
					}*/
					
					manageTactualObjectValidity(tO, compareTactualObjects(tO_seed, tO), a_tO, a_value);
				}
				
				if(a_tO.length == 1)
				{
					continue;
				}
				
				var a_total:Number = 0;
				for each(validity in a_value)
				{
					a_total += validity;
				}
				
				if(a_total >= aggregate_total)
				{
					aggregate_tO = a_tO;
					aggregate_value = a_value;
					aggregate_total = a_total;
				}
			}
			
			if(!aggregate_tO)
				break;
			
			// create a cluster
			_tactualClusters.push(new Cluster(a_tO));
			_tactualClusterDebugColor.push(generateRandomColor());

			for each(tO in a_tO)
			{
				_tactualObjectQueue.splice(_tactualObjectQueue.indexOf(tO), 1);
			}

			a_tO = null;
			a_value = null;
		}
		
		// calculate cluster params
		for each(tC in _tactualClusters)
		{
			tC.updateParams();
		}
	}
	
    /**
     * @private
     */
	override public function validationComplete():void
	{
		var tC:ICluster;
		
		// push cluster histories
		for each(tC in _tactualClusters)
		{
			tC.pushSnapshot();
		}
	}
    
}

}