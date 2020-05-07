# Example async test suites: v.test.selenium.example.voting

  * Example TeamCity Run Suite Step, where runline is ```./behave-parallel.py -p 3 -D agent --tags %TestSuiteName%``` in runner task:
  
  ```
        <runner id="RunBehaveTests" name="Behave GUI" type="simpleRunner">
            <parameters>
            <param name="script.content" value="bash -c &quot;./behave-parallel.py -p 3 -D agent --tags %TestSuiteName%&quot;" />
            <param name="teamcity.build.workingDir" value="PythonQA/%TestFolderName%" />
            <param name="teamcity.step.mode" value="default" />
            <param name="use.custom.script" value="true" />
            </parameters>
        </runner>
  ```