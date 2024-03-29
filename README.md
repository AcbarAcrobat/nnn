# Welcome, to Vortex
    
## Repository statements:
  ```
  * Terraform-free ansible realization of Dynamic Infrastructure development/management/deployment 
  * Full IaC support via Ansible Cloud API modules.
  * Ready to use, just add your services and declare infrastructure.
  * Simple to understand solution template provides complete CI/CD/QA.
  * Multimple ways to use a many roles, zones, clusters, networks.
  * K8 & Docker Swarm support - you can have a multiple clusters in one environment.
  * You can have multiple virtual environments on one virtual cloud infrastructure placement.
  * Easy template for build, bootstrap, develop, deploy and test your infrastructure.
  * Have a TeamCity ready to import configuration with full process with simple CI/CD/QA pipeline.
  * Network balancer included - keepalived.
  * PCI DSS Compliance initial support modules.
  * Firewall zero-in inside based on Shorewall.
  * Many other stuff like rabbitmq/tarantool/redis/etc clusters.
  * GlusterFS as NFS shared storage.
  * Provides single point in development process.
  * All configurations fully generated - for local development and environments.
  * You can use different CI/CD tools for use, - TeamCity, Jenkins, Gitlab-CI, etc.
  * Storing builded docker images possible to different registries - gitlab, registryv2, nexus, etc.
  ```

## Readme's links:

- [Ansible](ansible/)
- [Roles](ansible/roles/)
- [Inventories](ansible/inventories/)
- [CI/CD PCI DSS Usage](ansible/CI/documentation/)
- [How to add a New Service](ansible/CI/documentation/NEW_SERVICE.md)
- [Network Maps](ansible/CI/documentation/PCI/network_maps/)
- [CI/CD Agents Debugger](ansible/!_tests/)
- [API Inventory Ansible Adapters](ansible/!_root_playbooks/)
- [In-Repository Vault Storage](ansible/.files/)

## QA Suites for templating own QA solution 

- [QA Example 1 - Payment](PythonQA/history_facts/v.test.selenium.example.payment/)
- [QA Example 2 - Voting](PythonQA/history_facts/v.test.selenium.example.voting/)
- [(WIP) Warrior Way - Guidline](PythonQA/)

## Folders info must to read

- [Dockerfiles](dockerfiles/README.md)
- [Services](services/README.md)

## Two basical types of inventories

Dynamic Inventory (API INVENTORY), called 0z-cloud:

     - Zero Inventory start point of your cloud - very simple way to work.
     - Zero Inventory - cloud bootstrap and check or validate your cloud infrastructure.
     - Contain prefilled/prepared template for create the instances.
     - Availiable in two types of run - api or baremetal. 
     - Contains dict and variables which you wants about infrastructure.
     - In API type used as template.
     
Target Inventory (GET INVENTORY), resulting inventory: 

     - Result of generation the API INVENTORY, contains all needed for ansible works.
     - Placed in inventories/products/{{ ansible_product }}/{{ ansible_environment }}
     - No stored in repository.

## Principial workflow

### Directory structure for dynamic inventories, describes basical call flow

![Directory_structure](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/repo_images/vortex_work_map.png)

### ZeroCloud configuration flow inside and only on ansible calls

![Api_flow_dynamic_inventories](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/repo_images/vortex_api_generate_flow.png)


## Working with virtual and cloud environments, bootstraping and managing

  * Basicly, we have a three types of environments except localhost development type - standalone, minimal and pci. You can create you special one and select your options for you time. Firstaful, we create and bootstrap environment, wrappers for that you can find in https://github.com/westsouthnight/vortex/tree/master/ansible/scripts/wrappers/init
  
    * Go to ansible folder in cloned repository, -
    
    ```
      cd ./ansible
    ```
    
    * Try run the wrapper as example, -
    
    ```
      ./scripts/wrappers/init/\!_stand-pci.sh
    ```

    ![stand_pci.sh](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/repo_images/stand_pci.png)
    
    * TeamCity or other CI/CD/QA running tool just run wrappers to execute a some step of pipeline with ```type_of_run``` equals ```true```, for local runing/debugging/understanding you can run each wrapper with value ```print_only``` in  ```type_of_run``` parameter. Please read the configuration in folder ```.teamcity``` for more understud.

  * We split processes for managing your bussines product lifecycle to two steps - 
    
    * Build and validate infrastructure - only if you use a api cloud adapter for support full dynamic environment way. If  use the baremetal adapter you must to create infrastructure itself and declare necessary nodes information to static template.
    
    * Deploy pipeline:
    
        * Prepare CI 
     
        * Build and Push Docker images - Build your software and necessary backend/database/services images for able to work your own software.
    
           ```
           ./\!_all_services_builder.sh
        
           ```
      ![services_builder.png](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/repo_images/services_builder.png)
    
        * Validate Deployment and Deploy - Deploy to Docker Swarm / K8 / Standalone updated manifests, perform DB migrations.

           ```
           ./\!_all_services_deployer.sh
           
           ```
      ![services_deployer.png](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/repo_images/services_deployer.png)

        * Update the Backend DNS & Web-Server (nginx) configurations - update DNS & webserver configurations and check some list of backend services like monitoring, ntp, etc.
        
           ```
           ./\!_all_services_internal.sh
        
           ```
      ![services_internal.png](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/repo_images/services_internal.png)

        * Run the QA part of pipeline - running your custom QA test suites. You must enable that part of pipeline by itself because default state of feature is disabled.
        
           ```
           ./\!_0z-quality_assurance.sh
        
           ```
      ![services_qa.png](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/repo_images/services_qa.png)

  * You can customize each part of pipeline, playbooks and roles.

## Examples of usage the inventories childs - 

### One to multiple, where one as a parent:

   We have a one primary inventory, on some product, some cloud type provider as total, - 

            one compute environment, - {{ ansible_environment }} == 'production'

   But wants to placement multiple virtual environments on same Datacenter to same VMs environment

   All linked environments, which we wants to add as childs like virtual, looks and works by the symlinks way.

   Lets do like for example, two childs of primary - developemnt and stage environments, 

   * Create the new folders in api cloud inventory - 

            ./0z-cloud/products/\!_{{ cloud_type }}/{{ ansible_product }}/developemnt/ 
            ./0z-cloud/products/\!_{{ cloud_type }}/{{ ansible_product }}/stage/ 

   * Create symlinks from parent primary cloud dynamic environment to his new childs -

            mkdir ./0z-cloud/products/\!_{{ cloud_type }}/{{ ansible_product }}/stage/
            cd ./0z-cloud/products/\!_{{ cloud_type }}/{{ ansible_product }}/stage/
            ln -s ../production/v.py 
            ln -s ../production/bootstrap_vms 

   * Copy the target inventory from parent to new, firstaful create a target inventories localtions -
            
            mkdir ./products/{{ ansible_product }}/stage 
            cp -R ./products/{{ ansible_product }}/production/* ./products/{{ ansible_product }}/{{ new_environment }}/ 

   * Done, now change the domain names and ports settings on your new cloud target childs from production environments, and deploy!

### Create new environment (api and target) by cloning some as parent:

  * Makes new inventories from scratch, with examples and describsions about why we need that and for what
        
         ./\!_mk_new_env.sh production vortex bare symlink bare setta vortex

  * Necessary input values to select your way to create a new environment, product, scale, or during some migrate or update to your infrastracure.

        1. inventory:    Parent inventory is must to be a specified, which be a donor for new inventory

        2. product:      Parent product is must to be a specified, which be a donor for new cloud config

        3. type cloud:   Parent cloud type is must to be a specified, like { vsphere / alicloud / bare / etc }

        4. run type:     Type of spawning the scratcher, from other repo, ways for choice { clone / symlink }

        5. type cloud:   Target cloud type is must to be a specified, like { vsphere / alicloud / bare / etc }

        6. inventory:    Target inventory is must to be a specified, which be a result of new inventory for cloud location

        7. product:      Target product is must to be a specified, which be a result for new cloud location

## It's not a joke, you can use shared devops cloud infrastructure as warplace, join us!

  * Road Warrior Environment is shared and avaliabled for testing any thing from that repo.

  * Just clone, cd and run! Like for example -

```
git clone https://github.com/westsouthnight/vortex/tree/master
cd votex/ansible
./scripts/wrappers/init/\!_stand-k8s.sh beta vortex westsouthnight '9101hfaubvu*@Q' true print_only bare
```

  * Be careful with your hands - think before start doing! Follow by a white rabbit, and good luck! ;)
 
