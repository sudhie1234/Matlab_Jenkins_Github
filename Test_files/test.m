import matlab.unittest.TestRunner;
import matlab.unittest.plugins.DiagnosticsOutputPlugin;
import sltest.plugins.MATLABTestCaseIntegrationPlugin;
import sltest.plugins.TestManagerResultsPlugin;
import sltest.plugins.ToTestManagerLog;
import sltest.plugins.ModelCoveragePlugin;
import sltest.plugins.coverage.CoverageMetrics;
import sltest.plugins.coverage.ModelCoverageReport;
import sltest.plugins.coverage.ModelCoverageReport
import matlab.unittest.plugins.codecoverage.CoberturaFormat;
import matlab.unittest.TestSuite;
import matlab.unittest.plugins.TestReportPlugin;
import matlab.unittest.Verbosity;
import matlab.unittest.plugins.XMLPlugin;
import matlab.unittest.plugins.TestReportPlugin;
import matlab.unittest.plugins.CodeCoveragePlugin;
import matlab.unittest.plugins.codecoverage.CoverageReport;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

proj = openProject('Matlab_Jenkins.prj');
open_system('wiper.slx');
open_system('Wiper_Harness.slx');
sltestmgr; 
testFile = sltest.testmanager.load('Matlab_Jenkins_Automated.mldatx'); 
testSuite = getTestSuiteByName(testFile,'Test Scenarios'); 
testCase = getTestCaseByName(testSuite,'Test_Case1'); 
resultObj = run(testCase);

runner = TestRunner.withTextOutput('OutputDetail', Verbosity.Detailed );
runner.addPlugin(TestReportPlugin.producingHTML('testReport'));
runner.addPlugin(TAPPlugin.producingVersion13(ToFile('matlabTestArtifacts/taptestresults.tap')));
runner.addPlugin(XMLPlugin.producingJUnitFormat('matlabTestArtifacts/junittestresults.xml'));
runner.addPlugin(TestReportPlugin.producingPDF('mjreport.pdf');
runner.addPlugin(TAPPlugin.producingVersion13(ToFile('mjreport.tap'))
runner.addPlugin(CodeCoveragePlugin.forFolder({'Test_folder'}, 'IncludingSubfolders', true, 'Producing', CoverageReport('covReport', ...
   'MainFile','index.html')));

results = runner.run(suite);
