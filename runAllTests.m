import matlab.unittest.TestRunner;
import matlab.unittest.plugins.DiagnosticsOutputPlugin;
import sltest.plugins.MATLABTestCaseIntegrationPlugin;
import sltest.plugins.TestManagerResultsPlugin;
import sltest.plugins.ToTestManagerLog;
import sltest.plugins.ModelCoveragePlugin;
import sltest.plugins.coverage.CoverageMetrics;
import sltest.plugins.coverage.ModelCoverageReport;
import sltest.testmanager.importResults;
import sltest.plugins.coverage.ModelCoverageReport;
import matlab.unittest.plugins.codecoverage.CoberturaFormat;
import matlab.unittest.TestSuite;
import matlab.unittest.plugins.TestReportPlugin;
import matlab.automation.streams.ToFile;
import matlab.unittest.Verbosity;
import matlab.unittest.plugins.XMLPlugin;
import matlab.unittest.plugins.TestReportPlugin;
import matlab.unittest.plugins.CodeCoveragePlugin;
import matlab.unittest.plugins.codecoverage.CoverageReport;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

addpath(genpath('Test_files'));

suite = testsuite(pwd, 'IncludeSubfolders', true);

[~,~] = mkdir('matlabTestArtifacts');

runner = TestRunner.withTextOutput('OutputDetail', Verbosity.Detailed );
runner.addPlugin(TestReportPlugin.producingHTML('testReport'));
runner.addPlugin(TAPPlugin.producingVersion13(ToFile('matlabTestArtifacts/taptestresults.tap')));
runner.addPlugin(XMLPlugin.producingJUnitFormat('matlabTestArtifacts/junittestresults.xml'));
runner.addPlugin(TestReportPlugin.producingPDF('mjreport.pdf');
runner.addPlugin(TAPPlugin.producingVersion13(ToFile('mjreport.tap'))
runner.addPlugin(CodeCoveragePlugin.forFolder({'Test_folder'}, 'IncludingSubfolders', true, 'Producing', CoverageReport('covReport', ...
   'MainFile','index.html')));

results = runner.run(suite);

%proj = openProject('Matlab_Jenkins.prj');
%open_system('wiper.slx');
%open_system('Wiper_Harness.slx');
%sltestmgr;

testfile = fullfile('Matlab_Jenkins_Automated.mldatx'); %Importing the mldatx file
sltest.testmanager.view; %Viewing the Test Manager
sltest.testmanager.load(testfile); %Loading the Test file to Test Manager
suite = testsuite('Matlab_Jenkins_Automated.mldatx'); % Creating a Suite
%mj = TestRunner.withNoPlugins; %Creating a Test Runner

%Adding Test Manager Results to the MATLAB Test Report.
tmr = TestManagerResultsPlugin; 
addPlugin(runner,tmr) %Adding Test Manager Report Generator plugin to runner

%Running the Tests
result = run(runner,suite);

%Initializing Model Coverage Results for Continuous Integration
con_test = sltest.testmanager.TestFile('Test_files\AutopilotTestFile.mldatx');
apsuite = testsuite(con_test.FilePath);

%Using the Same Test Runner for Continuous Integration.
cmet = CoverageMetrics('Decision',true); %Including the Coverage Metrics - Decision

%Setting the Coverage Result Properties. Generating the xml files
rptfile = 'mj.xml';
rpt = CoberturaFormat(rptfile)

%Create a model coverage plugin. The plugin collects the coverage metrics and produces the Cobertura format report.
mcp = ModelCoveragePlugin('Collecting',cmet,'Producing',rpt)

%Adding Coverage to the Test Runner
addPlugin(runner,mcp)

% Turn off command line warnings:
warning off Stateflow:cdr:VerifyDangerousComparison
warning off Stateflow:Runtime:TestVerificationFailed

%Running the Tests
Results = run(runner,apsuite)

%Reenable warnings
warning on Stateflow:cdr:VerifyDangerousComparison
warning on Stateflow:Runtime:TestVerificationFailed

% Generate Zip files
% zip('covReport.zip','covReport');
nfailed = nnz([results.Failed]);
assert(nfailed == 0, [num2str(nfailed) ' test(s) failed.']);
