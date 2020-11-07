////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Aggregator.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.aggregators
{

import id.core.IDisposable;
import id.core.ITactualObject;
import id.managers.IValidationManagerHook;
import id.system.SystemHook;
import id.tracker.ITrackerHook;

import flash.events.EventDispatcher;

/**
 * The Aggregator class lets you extend it to create point clustering
 * algorithms.  It extends the <code>SystemHook</code> which provides low
 * level access to the internal mechanisms in GestureWorks.  This immediatly
 * provides access to the methods exposed by the validation system and also
 * gives access to the internal point tracking system.
 * 
 * <p>Best practices while extending this object include overriding the
 * following methods:</p>
 * 
 * <pre>
 *  addTactualObject
 *  removeTactualObject
 *  validationBeginning
 *  validationEnding
 * </pre>
 * 
 * <p>By overriding both add and remove tactual object methods, you are
 * able to directly control the creation and destruction of the clusters.
 * In doing so, you will need to ensure that there are no lingering 
 * references to the <code>ITactualObject</code>s.</p>
 * 
 * <p>By overriding both beginning and ending validation methods, you are
 * provided with a system which allows you to refresh the existing clusters
 * and provide cleanup intra frame. The validation system cycles are based
 * on the application's framerate and will provide you with a method for
 * efficently processing point information.</p>
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public class Aggregator extends SystemHook
	implements IAggregator, ITrackerHook, IValidationManagerHook, IDisposable
{
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
	protected var _tactualClusters:Vector.<ITactualObject>;
	
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
	public function Aggregator()
	{
		_tactualClusters = new Vector.<ITactualObject>();
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
		_tactualClusters = null;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public function get tactualClusters():Vector.<ITactualObject> { return _tactualClusters; }
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public function addTactualObject(tO:ITactualObject):void
    {
        // override me
    }
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public function removeTactualObject(tO:ITactualObject):void
    {
        // override me
    }
	
}
}