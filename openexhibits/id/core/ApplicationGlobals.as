////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ApplicationGlobals.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.core
{

import id.aggregators.IAggregator;
import id.data.IInputProvider;
import id.debug.TactualObjectDebugger;
import id.managers.IDataManager;
import id.managers.IValidationManager;
import id.modules.IModuleFactory;
import id.structs.DescriptorPriorityQueue;
import id.tracker.ITracker;

use namespace id_internal;

/**
 * A class that contains variables that are global to all appliations within the
 * same ApplicationDomain.
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public class ApplicationGlobals
{
    
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
	
	/**
	 * A reference to the top level application in the current ApplicationDomain.
     * The first application to register against this property within the current
     * domain is considered the top-most.  Each ApplicationDomain will have its
     * own top-most <code>application</code>.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public static var application:Object;
	
	/**
     * A reference to the data manager wich contains application default settings
     * or external params from the specified xml.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public static var dataManager:IDataManager;
	
	/**
	 * A reference to the descriptor class supplied by the
     * <code>application</code>.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public static var descriptorClass:Class;
	
	/**
	 * A reference to the descriptor module supplied by the
     * <code>application</code>.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public static var descriptorModule:IModuleFactory;
	//public static var descriptorModule:IModule;
	
	

	/**
	 * @private
	 */
	id_internal static var descriptorAssembly:Object;

	/**
	 * @private
	 */
	id_internal static var descriptorList:Object;
	
	/**
	 * @private
	 */
	id_internal static var descriptorMap:Object;
	
	/**
	 * @private
	 */
	id_internal static var descriptorPriorityQueue:DescriptorPriorityQueue;
	
	
	
	
	/**
	 * @private
	 */
	id_internal static var aggregator:IAggregator;

	/**
	 * @private
	 */
	id_internal static var simulator:IInputProvider;
	
	/**
	 * @private
	 */
	id_internal static var tracker:ITracker;
	
	/**
	 * @private
	 */
	id_internal static var trackerInputProvider:IInputProvider;
	
	/**
	 * @private
	 */
	id_internal static var validationManager:IValidationManager; 
	
	
	
	/**
	 * A reference to the debugger.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public /*id_internal*/ static var tactualObjectDebugger:TactualObjectDebugger;
	
}

}