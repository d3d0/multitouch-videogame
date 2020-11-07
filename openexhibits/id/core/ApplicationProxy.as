////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ApplicationProxy.as
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

// first frame imports
import id.data.flosc.Flosc; Flosc;
import id.data.flosc.FloscSettings; FloscSettings;
import id.data.simulator.Simulator; Simulator;
import id.data.simulator.SimulatorSettings; SimulatorSettings;

CONFIG::FLASH_10_1
{
import id.data.native.Native; Native;
import id.data.native.NativeSettings; NativeSettings;
}

CONFIG::DEBUG
{
import id.events.LoggerEvent;
import id.logging.Logger;
};

CONFIG::GESTURE_LIB
{
import gl.GestureLibrary;
};

CONFIG::LICENSE_MANAGER
{
import id.managers.LicenseManager;
import id.ui.SplashScreen;
import id.ui.SplashScreenOE;
};

import id.aggregators.sbf.SimpleBestFit;
import id.configuration.XmlConfigurator;
import id.core.id_internal;
import id.data.InputTypes;
import id.debug.TactualObjectDebugger;
import id.events.DataProviderEvent;
import id.events.LicenseManagerEvent;
import id.managers.DataManager;
import id.managers.ValidationManager;
import id.modules.IModuleFactory;
import id.structs.DescriptorPriorityQueue;
import id.system.SystemHook;
import id.system.SystemRegister;
import id.system.SystemRegisterType;
import id.tracker.Tracker;
import id.ui.CountdownTimer;
import id.utils.StringUtil;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;

use namespace id_internal;


/**
 * The ApplicationProxy class provides methods which allow objects that
 * inherit the <code>ITouchObject</code> interface to mimic an 
 * <code>Appliation</code>.
 * 
 * <p>This class provides three static methods that should be called in the 
 * following order from the caller's default constructor:</p>
 * 
 * <listing version="3.0">
 * ApplicationProxy.registerApplication(this);
 * ApplicationProxy.registerApplicationObjects();
 * 
 * super();
 * 
 * ApplicationProxy.initializeApplicationSettings();
 * </listing>
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public class ApplicationProxy
{
	
	include "../core/Version.as"
	
    //--------------------------------------------------------------------------
    //
    //  Config: License Manager
    //
    //--------------------------------------------------------------------------
	
	CONFIG::LICENSE_MANAGER
	{
	private static var _countdownTimer:CountdownTimer;
	}
	
    //--------------------------------------------------------------------------
    //
    //  SystemRegister: GestureWorks
    //
    //--------------------------------------------------------------------------
	
	public static var register:SystemRegister = new SystemRegister
	(
		"GestureWorks",
		id_internal::VERSION,
		SystemRegisterType.LIBRARY
	);
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	//public static var settingsPath:String;
	//public static var licenseKey:String;
    
	private static var _defferedInitialization:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Class Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * This method registers the desired object as an application and establishs
     * the initial stage dependant pathways. Upon stage availability, data
     * pathways will execute and load or establish default internal settings.
     * 
     * @throws Error An Application has already been registered.
     *
     * @throws ArgumentError Application objects must at minimum inherit the
     * <code>ITouchObject</code> interface and be a <code>DisplayObject</code>.
     * 
     * @param application An object being constructed.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public static function registerApplication(application:Object):void
	{
		if(ApplicationGlobals.application)
		{
			throw new Error("Application Proxy -- an application has already been registered!");
		}
		
		var dO:DisplayObject = application as DisplayObject;
		if(!dO)
		{
			throw new ArgumentError("Application Proxy -- application must be a DisplayObject!");
		}
		
		var tO:ITouchObject = application as ITouchObject;
		if(!tO)
		{
			throw new ArgumentError("Application Proxy -- application must inherit the ITouchObject interface!");
		}
		
		ApplicationGlobals.application = application;
		
		if(dO.stage)
		{
			_defferedInitialization = true;
			
			application.stage.addEventListener(Event.RESIZE, application_resizeHandler, false, 0, true);
			application_resizeHandler(null);
		}
		else
		{
			application.addEventListener(Event.ADDED_TO_STAGE, application_addedToStageHandler);
			application.addEventListener(Event.RESIZE, application_resizeHandler, false, 0, true);
		}
	}
	
    /**
     * This method registers params against the <code>ApplicationGlobals</code>
     * object and initializes the gesture library.  If the library is not
     * specified, it defaults down to the library compiled into the 
     * ApplicationDomain.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public static function registerApplicationObjects():void
	{
		CONFIG::GESTURE_LIB
		{
		ApplicationGlobals.descriptorClass = GestureLibrary;
		}
		
		var lib:Class = ApplicationGlobals.descriptorClass;
		
		var descriptorModule:IModuleFactory = new lib();
		var descriptorAssembly:Object = descriptorModule.create();
		var descriptorList:Object = { };
		
		descriptorList[DescriptorAssembly.ACTIVATORS] = 
			descriptorAssembly[DescriptorAssembly.ACTIVATORS] || {} ;
		
		descriptorList[DescriptorAssembly.GESTURES] = 
			descriptorAssembly[DescriptorAssembly.GESTURES] || {} ;
		
		descriptorList[DescriptorAssembly.TOUCHES] =
			descriptorAssembly[DescriptorAssembly.TOUCHES] || {} ;
		
		ApplicationGlobals.descriptorModule = descriptorModule;
		ApplicationGlobals.descriptorAssembly = descriptorAssembly;
		ApplicationGlobals.descriptorList = descriptorList;
		ApplicationGlobals.descriptorPriorityQueue = createPrimitiveQueue(descriptorAssembly);
		
		var activatorEvent:Class = descriptorAssembly[DescriptorAssembly.ACTIVATOR_EVENT];
		TouchObjectGlobals.activatorEvent = activatorEvent;
		
		var gestureEvent:Class = descriptorAssembly[DescriptorAssembly.GESTURE_EVENT];
		TouchObjectGlobals.gestureEvent = gestureEvent;

		TouchObjectGlobals.affineTransform_release_event = gestureEvent
		[
			TouchObjectGlobals.affineTransform_release
		];
		
		TouchObjectGlobals.affineTransform_rotate_event = gestureEvent
		[
			TouchObjectGlobals.affineTransform_rotate
		];
		
		TouchObjectGlobals.affineTransform_scale_event = gestureEvent
		[
			TouchObjectGlobals.affineTransform_scale
		];
		
		TouchObjectGlobals.affineTransformations = true;
		
		//var descriptor:IDescriptor;
		var descriptor:Object;
		var descriptorCast:IDescriptor;
		var descriptorMap:Object = {};
		for(var k:String in ApplicationGlobals.descriptorList)
		{
			for(var j:String in ApplicationGlobals.descriptorList[k])
			{
				descriptor = ApplicationGlobals.descriptorList[k][j] as IDescriptor;
				
				/*
				if(!descriptor)
					continue;
				*/
				
				descriptorCast = descriptor as IDescriptor;
				if (descriptorCast)
				{
					descriptorCast.tracker = Tracker.getInstance();
				}

				descriptorMap[descriptor.name] = j
			}
		}
		
		ApplicationGlobals.descriptorMap = descriptorMap;
	}
	
    /**
     * This method establishes default params on the <code>Application</code>
     * object such that it exhibits similar behavior.
     * 
     * @see id.core.Application
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public static function initializeApplicationSettings():void
	{
		ApplicationGlobals.application.blobContainerEnabled = true;
		ApplicationGlobals.application.topLevel = true;
		
		if(_defferedInitialization)
		{
			initializeStageDependantPathways();
		}
		
		_defferedInitialization = false;
	}
	
    /**
     * @private
     */
	private static function createPrimitiveQueue(assembly:Object):DescriptorPriorityQueue
	{
		var queue:DescriptorPriorityQueue = new DescriptorPriorityQueue();
		
		var descriptor:IDescriptor;
		for each (descriptor in assembly[DescriptorAssembly.TOUCHES])
		{
			queue.addDescriptor(descriptor);
		}
		
		return queue;
	}
	
    /**
     * @private
     */
	private static function initializeStageDependantPathways(/*settingsPath:String*/):void
	{
		ApplicationGlobals.dataManager = DataManager.getInstance();
		
		ApplicationGlobals.dataManager.addEventListener(Event.COMPLETE, dataManager_completeHandler);
		ApplicationGlobals.dataManager.addEventListener(IOErrorEvent.IO_ERROR, dataManager_errorHandler);
		ApplicationGlobals.dataManager.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dataManager_errorHandler);
		
		ApplicationGlobals.dataManager.dataPath = "application.xml";
		
		// do not re-order
		ApplicationGlobals.tactualObjectDebugger = new TactualObjectDebugger();
		ApplicationGlobals.tactualObjectDebugger.tracker = Tracker.getInstance();
		ApplicationGlobals.tactualObjectDebugger.validationManager = ValidationManager.getInstance();
		
		ApplicationGlobals.aggregator = new SimpleBestFit();
		ApplicationGlobals.aggregator.tracker = Tracker.getInstance();
		ApplicationGlobals.aggregator.validationManager = ValidationManager.getInstance();
		
		ApplicationGlobals.tracker = Tracker.getInstance();
		ApplicationGlobals.tracker.validationManager = ValidationManager.getInstance();
		
		ApplicationGlobals.validationManager = ValidationManager.getInstance();
	}

    //--------------------------------------------------------------------------
    //
    //  Stage Events
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
	private static function application_addedToStageHandler(event:Event):void
	{
		initializeStageDependantPathways();
		ApplicationGlobals.application.removeEventListener(Event.ADDED_TO_STAGE, application_addedToStageHandler);
	}
    /**
     * @private
     */
	private static function application_resizeHandler(event:Event):void
	{
		var application:Object = ApplicationGlobals.application;
		
		CONFIG::LICENSE_MANAGER
		{
		if (_countdownTimer)
		{
			_countdownTimer.x = application.width - _countdownTimer.width - 20;
			_countdownTimer.y = application.height - _countdownTimer.height - 15;
		}
		}
	}
	
    //--------------------------------------------------------------------------
    //
    //  Data Manager Events
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
	private static function dataManager_completeHandler(event:Event):void
	{
		var touchCore:XMLList = ApplicationGlobals.dataManager.touchCore;
		if(!touchCore)
		{
			throw new ArgumentError("Application.xml must have <TouchCore></TouchCore>");
		}
		else
		if(!touchCore.InputTypes)
		{
			throw new ArgumentError("Application.xml must have <InputTypes></InputTypes>");
		}
		else
		if(!touchCore.DataInput)
		{
			throw new ArgumentError("Application.xml must have <DataInput></DataInput>");
		}
		
		// establish the tracker's params
		if(touchCore.TrackerSettings)
		{
			ApplicationGlobals.tracker.frequency = touchCore.TrackerSettings.Frequency;
			ApplicationGlobals.tracker.ghostTolerance = touchCore.TrackerSettings.GhostTolerance;
		}
		
		var inputTypes:InputTypes = new InputTypes(touchCore.InputTypes);
		
		// establish the simulator
		if(touchCore.Degradation != "never")
		{
			var simulator:Object = inputTypes["Simulator"];
			if(!simulator)
			{
				throw new Error("Application.xml must have a defined simulator if degradation is desired!");
			}

			ApplicationGlobals.simulator = new Simulator();
			ApplicationGlobals.simulator.settings = XmlConfigurator.Create
			(
			 	simulator.clsSettings,
				XML(touchCore.DataInput[simulator.xml.Settings].toXMLString())
			);
			ApplicationGlobals.simulator.validationManager = ApplicationGlobals.validationManager;
			ApplicationGlobals.simulator.tracker = ApplicationGlobals.tracker;
			ApplicationGlobals.simulator.bloom();
		}
		
		var inputProvider:*;

		// establish the data input provider
		if(touchCore.InputProvider != "")
		{
			var inputType:Object = inputTypes[touchCore.InputProvider];
			if(!inputType)
			{
				throw new ArgumentError
				(
					"Application.xml must use a defined InputProvider. '" +
					touchCore.InputProvider +
					"' was not found!"
				);
			}
			
			inputProvider = new inputType.cls();
			inputProvider.settings = XmlConfigurator.Create
			(
				inputType.clsSettings,
				XML(touchCore.InputSettings[inputType.xml.Settings].toXMLString())
			);

			if(inputProvider as SystemHook)
			inputProvider.validationManager = ApplicationGlobals.validationManager;
			inputProvider.tracker = ApplicationGlobals.tracker;
			
			ApplicationGlobals.trackerInputProvider = inputProvider;
		}
		
		// setup input provider swapping
		if(touchCore.InputProvider && touchCore.Degradation == "auto")
		{
			ApplicationGlobals.trackerInputProvider.addEventListener(DataProviderEvent.ERROR, inputProvider_errorHandler);
			ApplicationGlobals.trackerInputProvider.addEventListener(DataProviderEvent.ESTABLISHED, inputProvider_establishedHandler);
		}
		
		// setup the debug mode
		if(touchCore.Debug == "true")
		{
			ApplicationGlobals.tactualObjectDebugger.start();
		}
		
		// start the data input provider
		if(ApplicationGlobals.trackerInputProvider)
		{
			ApplicationGlobals.trackerInputProvider.bloom();
		}
		
		CONFIG::LICENSE_MANAGER
		{
		var licenseManager:LicenseManager = LicenseManager.getInstance();
		
		licenseManager.addEventListener(LicenseManagerEvent.VALIDATION_COMPLETE, licenseManager_validationCompleteHandler);
		licenseManager.validateKey(touchCore.LicenseKey ? touchCore.LicenseKey : "");
		licenseManager.validateKey
		(
			!StringUtil.isEmpty(touchCore.LicenseKey) ? touchCore.LicenseKey :
			""
		);
		
		var splashScreen:SplashScreen = new SplashScreen(licenseManager.productID);
		//var splashScreen:SplashScreenOE = new SplashScreenOE(licenseManager.productID);
		}
	}
	
    /**
     * @private
     */
	private static function dataManager_errorHandler(event:IOErrorEvent):void
	{
		ApplicationGlobals.dataManager.data = ApplicationSettings.Settings;
		dataManager_completeHandler(null);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Input Provider Events
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
	private static function inputProvider_errorHandler(event:DataProviderEvent):void
	{
		ApplicationGlobals.simulator.start();
	}
	
    /**
     * @private
     */
	private static function inputProvider_establishedHandler(event:DataProviderEvent):void
	{
		ApplicationGlobals.simulator.stop();
	}
	
    //--------------------------------------------------------------------------
    //
    //  Config: License Manager - Events
    //
    //--------------------------------------------------------------------------
    
	CONFIG::LICENSE_MANAGER
	{
	private static function licenseManager_validationCompleteHandler(event:LicenseManagerEvent):void
	{
		if(event.productMode == ProductMode.KILL)
		{
			ApplicationGlobals.tracker.clear();
			ApplicationGlobals.tracker.cripple();
		}
		else
		if(
		   event.productMode == ProductMode.UNREGISTERED ||
		   event.productMode == ProductMode.TRIAL
		   )
		{
			var countdownDuration:uint = event.productMode == ProductMode.UNREGISTERED ? 900000 : 3600000 ;
			var countdownText:String = event.productMode == ProductMode.UNREGISTERED ?
				"Unregistered (visit GestureWorks.com for a free license key) - " :
				//"Unregistered (visit OpenExhibits.org for a free license key) - " :
				"Trial Mode - " ;
			
			_countdownTimer = new CountdownTimer();
			_countdownTimer.duration = countdownDuration;
			_countdownTimer.prefix = countdownText;
			
			_countdownTimer.start();
			
			_countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,
			function(event:TimerEvent):void
			{
				ApplicationGlobals.tracker.clear();
				ApplicationGlobals.tracker.cripple();
			});
			

			ApplicationGlobals.application.stage.addChild(_countdownTimer);
			application_resizeHandler(null);
		}

		var licenseManager:LicenseManager = LicenseManager.getInstance();
		licenseManager.removeEventListener(LicenseManagerEvent.VALIDATION_COMPLETE, licenseManager_validationCompleteHandler);
	}
	}
}

}