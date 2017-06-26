classdef TestManagerReportPlugin  < matlab.unittest.plugins.TestRunnerPlugin
    %TestManagerReportPlugin Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Report;
    end
   
    methods
        function p = TestManagerReportPlugin(reportFile)
            p.Report = reportFile;
        end
    end
    
    methods (Access = protected)
        function runTestSuite(plugin, pluginData)
            sltest.testmanager.clearResults;
            
            runTestSuite@matlab.unittest.plugins.TestRunnerPlugin(...
                plugin, pluginData);
            
            % Extract the most recent results from the Test Manager
            resultSets = sltest.testmanager.getResultSets;
            currentResults = resultSets((end-numel(pluginData.TestSuite)+1):end);
            
            % Coarsely check consistency of currentResults and resultSets
            assert(sum([currentResults.NumPassed]) == sum([pluginData.TestResult.Passed]), ...
                'Inconsistent extraction of results')
            
            % Create report - pass in array of results as input to create
            % one report            
            
            sltest.testmanager.report( currentResults, ...
                plugin.Report, ...
                'IncludeTestResults', 0); % include all results
            
        end
    end
end

