import matlab.unittest.TestRunner
import matlab.unittest.plugins.XMLPlugin
import matlab.unittest.plugins.TAPPlugin
import matlab.unittest.plugins.ToFile
import matlab.unittest.plugins.TestReportPlugin

jenkins_workspace = getenv('WORKSPACE');
try
    % Pick up local tests
    suite1 = testsuite();
    suite2 = testsuite(fullfile(matlabroot, 'test', 'toolbox', 'stm', 'matlabunit', 'testdata', 'testfolder'));
    suite3 = testsuite(fullfile(matlabroot, 'test', 'toolbox', 'stm', 'matlabunit', 'testdata', 'testfolder', 'iterations'));
    suite4 = testsuite(fullfile(matlabroot, 'test', 'toolbox', 'stm', 'matlabunit', 'testdata', 'testfolder', 'tags'));
    
    suite = [suite1 suite2 suite3 suite4];
    
    xmlResultsFile = fullfile(jenkins_workspace, 'JUnitResults.xml');
    tapResultsFile = fullfile(jenkins_workspace, 'TAPResults.tap');
    %reportFile = fullfile(jenkins_workspace, 'TestReport.pdf');
    
    % Create and configure the runner
    runner = TestRunner.withTextOutput('Verbosity',3);
    artifactsFolder = fullfile(jenkins_workspace, 'artifacts');
    mkdir(artifactsFolder);
    runner.ArtifactsRootFolder = artifactsFolder;    
    runner.addPlugin(TAPPlugin.producingVersion13(ToFile(tapResultsFile)));
    runner.addPlugin(XMLPlugin.producingJUnitFormat(xmlResultsFile));
    %runner.addPlugin(TestManagerReportPlugin(reportFile));
    
    % Add the MATLAB Unit TestReportPlugin
    % pdf
    pdfFile = fullfile(jenkins_workspace, 'TestReport.pdf');
    runner.addPlugin(TestReportPlugin.producingPDF(pdfFile));
    
    % html
    htmlFolder = fullfile(jenkins_workspace, 'testresults');
    runner.addPlugin(TestReportPlugin.producingHTML(htmlFolder,...
        'IncludingCommandWindowText', true,  'IncludingPassingDiagnostics', true));    
    results = runner.run(suite);
catch e
    disp(getReport(e, 'extended'));
    exit(1);
end
