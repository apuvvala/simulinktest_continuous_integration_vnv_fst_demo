import matlab.unittest.TestRunner

try
    % Create a suite of daily tests
    suite = testsuite('NoiseCancellation.mldatx');
    
    % Report file
    reportFile = fullfile(getenv('WORKSPACE'), 'TestReport.pdf');    
    
    % Create and configure a TestRunner    
    runner = TestRunner.withTextOutput;        
    runner.addPlugin(TestManagerReportPlugin(reportFile)); % why not!
    
    % Run tests
    results = runner.run(suite);
    
    display(results);
catch e
    disp(getReport(e, 'extended'));    
    exit(1);
end

exit;
