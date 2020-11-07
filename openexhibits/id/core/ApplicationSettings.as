////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ApplicationSettings.as
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

public class ApplicationSettings
{


	/*CONFIG::FLASH_10
	{
	public static var Settings:XML =
    <Application>
        <TouchCore>	
            <!-- Begin Aggregator Types -->
            <AggregatorTypes>
            </AggregatorTypes>
            <!-- End Aggregator Types -->
        
            <!-- Begin Filter Types -->
            <FilterTypes>
            </FilterTypes>
            <!-- End Filter Types -->
            
            <!-- Begin Input Types -->
            <InputTypes>
                <Type name="Flosc">
                    <Package>id.data.flosc</Package>
                    <Class>Flosc</Class>
                    <Settings>FloscSettings</Settings>
                </Type>
                <Type name="Simulator">
                    <Package>id.data.simulator</Package>
                    <Class>Simulator</Class>
                    <Settings>SimulatorSettings</Settings>
                </Type>
            </InputTypes>
            <!-- End Input Types -->
        
            <!-- Begin Aggregator Settings -->
            <AggregatorSettings>
            </AggregatorSettings>
            <!-- End Aggregator Settings -->
            
            <!-- Begin Filter Settings -->
            <FilterSettings>
                <NoiseFilter>
                    <Histogram>
                        <width></width>
                        <height></height>
                        <backFrameCount></backFrameCount>
                        <forwardFrameCount></forwardFrameCount>
                    </Histogram>
                    
                    <Spacial>true</Spacial>
                    <Temporal>true</Temporal>
                </NoiseFilter>
            </FilterSettings>
            <!-- End Filter Settings -->
        
            <!-- Begin Input Settings -->
            <InputSettings>
                <FloscSettings>
                    <Host>127.0.0.1</Host>
                    <Port>3000</Port>
                    
                    <AutoReconnect>true</AutoReconnect>
                    
                    <EnforceSize>false</EnforceSize>
                    <Width>1280</Width>
                    <Height>710</Height>
                </FloscSettings>
                <NativeSettings />
                <SimulatorSettings/>
            </InputSettings>
            <!-- End Input Settings -->
            
            <!-- Begin Tracker Settings -->
            <TrackerSettings>
                <Frequency>61</Frequency>
                <GhostTolerance>10</GhostTolerance>
            </TrackerSettings>
            <!-- End Tracker Settings -->
            
            <Aggregator></Aggregator>
            <Filter></Filter>
            <InputProvider>Flosc</InputProvider>
            
            <Clustering>1</Clustering> <!-- 0 | 1 | 2 -->
            <Degradation>auto</Degradation> <!-- always | auto | never -->
            <Debug>true</Debug>
            
            <LicenseKey></LicenseKey>
        </TouchCore>
        
        <TouchPhysics>
        </TouchPhysics>
        
        <TouchLib>
        </TouchLib>
        
    </Application>
	}*/
	
	//CONFIG::FLASH_10_1
	//{
	public static var Settings:XML =
    <Application>
        <TouchCore>	
            <!-- Begin Aggregator Types -->
            <AggregatorTypes>
            </AggregatorTypes>
            <!-- End Aggregator Types -->
        
            <!-- Begin Filter Types -->
            <FilterTypes>
            </FilterTypes>
            <!-- End Filter Types -->
            
            <!-- Begin Input Types -->
            <InputTypes>
                <Type name="Flosc">
                    <Package>id.data.flosc</Package>
                    <Class>Flosc</Class>
                    <Settings>FloscSettings</Settings>
                </Type>
                <Type name="Native">
                    <Package>id.data.native</Package>
                    <Class>Native</Class>
                    <Settings>NativeSettings</Settings>
                </Type>
                <Type name="Simulator">
                    <Package>id.data.simulator</Package>
                    <Class>Simulator</Class>
                    <Settings>SimulatorSettings</Settings>
                </Type>
            </InputTypes>
            <!-- End Input Types -->
        
            <!-- Begin Aggregator Settings -->
            <AggregatorSettings>
            </AggregatorSettings>
            <!-- End Aggregator Settings -->
            
            <!-- Begin Filter Settings -->
            <FilterSettings>
                <NoiseFilter>
                    <Histogram>
                        <width></width>
                        <height></height>
                        <backFrameCount></backFrameCount>
                        <forwardFrameCount></forwardFrameCount>
                    </Histogram>
                    
                    <Spacial>true</Spacial>
                    <Temporal>true</Temporal>
                </NoiseFilter>
            </FilterSettings>
            <!-- End Filter Settings -->
        
            <!-- Begin Input Settings -->
            <InputSettings>
                <FloscSettings>
                    <Host>127.0.0.1</Host>
                    <Port>3000</Port>
                    
                    <AutoReconnect>true</AutoReconnect>
                    
                    <EnforceSize>false</EnforceSize>
                    <Width>1280</Width>
                    <Height>710</Height>
                </FloscSettings>
                <NativeSettings />
                <SimulatorSettings/>
            </InputSettings>
            <!-- End Input Settings -->
            
            <!-- Begin Tracker Settings -->
            <TrackerSettings>
                <Frequency>61</Frequency>
                <GhostTolerance>10</GhostTolerance>
            </TrackerSettings>
            <!-- End Tracker Settings -->
            
            <Aggregator></Aggregator>
            <Filter></Filter>
            <InputProvider>Native</InputProvider>
            
            <Clustering>1</Clustering> <!-- 0 | 1 | 2 -->
            <Degradation>auto</Degradation> <!-- always | auto | never -->
            <Debug>true</Debug>
            
            <LicenseKey></LicenseKey>
        </TouchCore>
        
        <TouchPhysics>
        </TouchPhysics>
        
        <TouchLib>
        </TouchLib>
        
    </Application>
	//}

}

}