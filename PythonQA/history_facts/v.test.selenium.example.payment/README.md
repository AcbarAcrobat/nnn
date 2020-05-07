# Example async test suites: v.test.selenium.example.payment

  * Full example and requirements for run suite you can see in full [TeamCity Build Configuration QA Part {# Default CI/CD Step 5 #} ](  ansible/.teamcity/VortexPci_CiCdChain/pluginData/metaRunners/VortexPci_CiCdChain_5qaRunningTestSuiteFromPythonQA1.xml)

  * Example part of TeamCity Run Suite Step, where runline is ```python3 -m pytest -p no:cacheprovider --direction %ANSIBLE_ENVIRONMENT% --session $session_token_result``` in runner task:
  
  ```
       
    python3 -m pytest -p no:cacheprovider --direction %ANSIBLE_ENVIRONMENT% --session $session_token_result

    echo "End"]]></param>
              <param name="teamcity.step.mode" value="default" />
              <param name="use.custom.script" value="true" />
            </parameters>
          </runner>
        </build-runners>
        <requirements />
      </settings>
    </meta-runner>

  ```