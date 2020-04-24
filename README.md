# Welcome, to Vortex

Primary Ansible code base

## What it is:

  * Terraform-free ansible realization of Dynamic Infrastructure development/management/deployment with full IaC support via Ansible Cloud API modules.
  
  * Ready to use, just add your services and declare infrastructure.
  
  * Simple to understand.
  
  * Multimple ways to use a many roles, zones, clusters, networks.
  
  * K8 & Docker Swarm support - you can have a multiple clusters in one environment or have multiple virtual environments on one virtual cloud placement.
  
  * Easy template for build, bootstrap, develop, deploy and test your infrastructure.
  
  * Have a TeamCity ready to import configuration with full process with simple CI/CD/QA pipeline.

## Working with virtual and cloud environments, bootstraping and managing.

  * Basicly, we have a three types of environments except localhost development type - standalone, minimal and pci. You can create you special one and select your options for you time. Firstaful, we create and bootstrap environment, wrappers for that you can find in https://github.com/westsouthnight/vortex/tree/master/ansible/scripts/wrappers/init
  
    * Go to ansible folder in cloned repository, -
    
    ```
      cd ./ansible
    ```
    
    * Try run the wrapper as example, -
    
    ```
      ./scripts/wrappers/init/\!_stand-pci.sh
    ```
    
    * TeamCity or other CI/CD/QA running tool just run wrappers to execute a some step of pipeline with ```type_of_run``` equals ```true```, for local runing/debugging/understanding you can run each wrapper with value ```print_only``` in  ```type_of_run``` parameter.
  
  * We split processes for managing your bussines product lifecycle to two steps - 
    
    * Build and validate infrastructure - only if you use a api cloud adapter for support full dynamic environment way. If  use the baremetal adapter you must to create infrastructure itself and declare necessary nodes information to static template.
    
    * Deploy pipeline - 
    
    ```
        1. Prepare CI
      
        2. Build and Push Docker images - Build your software and necessary backend/database/services images for able to work your own software.
      
        3. Validate Deployment and Deploy - Deploy to Docker Swarm / K8 / Standalone updated manifests, perform DB migrations.
      
        4. Update the Backend DNS & Web-Server (nginx) configurations - update DNS & webserver configurations and check some list of backend services like monitoring, ntp, etc.
        
    ```
  * You can customize each part of pipeline, playbooks and roles.

## Principial workflow

- DIRECTORY STRUCTURE FOR DYNAMIC INVENTORIES, DESCRIBES BASICAL CALL FLOW 

  ````
     ./root_dir/-----------------------------------------------------------|--------------------------------------------------------------|   
               |      DIRECTORY STRUCTURE FOR DYNAMIC INVENTORIES          |                                                              |   
               |___________________________________________________________|                                                              |   
               |          ###################                                                                                             |                              
           |---|    # API INVENTORY   |> 0z-cloud/ -|                                                                                     |   
           |                          |             |> products/\!_{{ cloud_type }}/{{ ansible_product }}/{{ ansible_environment }}       |   
      |----|                          |                                                                                                   |   
      |----> ansible/inventories/ -|> *                                                                                                   |   
      |-------|                       |             |> {{ ansible_product }}/{{ ansible_environment }}                                    |   
              |     # GET INVENTORY   |> products/ -|                                                                                     |   
              |-----|     ###################                                                                                             |   
                    |    |                                                                                                                |                                          
                    |    |-||----------------||------------------------||---------------------------||------------------------------------|   
                    |     |-|   INVENTORIES   | 1. Declare product as: |  2. Select Cloud Type       |  3. Select the inventory           |              
                    |      \|                 |                        |                             |                                    |   
                    |       [-----------------]     ansible_product    |     aws/azure/do/ali        |  production / develop / stage      |   
                    |       |_________________|                        |     vsphere/bare/vbox       |                                    |   
                    |        \_______________/-------------------------|-----------------------------|------------------------------------/                                
                    |______                                                               
                        |  \.services         # Folder contains child folders with Dockerfiles your private services, which develop there.                                                                                    
                        |__                                                     
                        |  \.docs             # Folder for placing Dockerfiles services with you documentation - api, etc.                                                
                        |__    
                        |  \.dockerfiles      # Folder with Dockerfiles for backends and frontends, like DBs, Webservers, other stuff.
                        |__   
                        |  \.git              # Git history.
                        |__   
                        |  \.local            # Local exchange folder for some tasks, store crypted creds and other runtime data.
                        |__   
                        |  \.teamcity         # CI/CD Implementation with already tuned pipelines and settings, just change and start.
                        |__   
                        |  \.PythonQA         # Example automation testing suite, which you can place tests for you services on CI/CD.
                        |__
                        |  \Dockerfile        # Ansible service Dockerfile if you want use docker for run ansible.
                        |__
                        |  \mk_new_env.sh     # Helper for create new enviroments, products from presented configuration. 
                        |__
                           \docker.sh         # Local development environment builder and runner.


- ZeroCloud configuration flow inside and only on ansible calls
```
    |-# ##############################################################################################################
    /0z-cloud/ 
            |
            |-/products/ 
                    | 
                    |-/\!_{{ cloud_type }}/ 
                                          |
                                          |-/{{ ansible_product }}/{{ ansible_environment }}/
                                                                                            |                       
    |---------------------------------------------------------------------------------------|
    |
    |-/bootstrap_vms/
    |           |-# Inventory used for cloud bootstrap usage from localhost: 
    |           |
    |           |   calling to cloud providers for check, create,      
    |           |   modify nodes and get facts from hosts by api    
    |           |
    |           |-/inventory
    |           |
    |               ###############################################################################################
    |           |
    |           |
    |           |-/group_vars
    |               
    |-#############################################################################################################
    |        |      
    |-/v.py  |-# Script v.py used as Dynamic Inventory driver as default for all calls from external tasks.               
    |        |
    |        |             
    |-/r.py  |-# Script r.py used as Dynamic Inventory driver as extra type for all calls from external tasks.           
    |        | # 
    |        | # As examples -
    |        | # 
    |        | # 1. One to multiple as parent:
    |        | # 
    |        | #    We have a one primary inventory, on some product, some cloud type provider as total, - 
    |        | # 
    |        | #    one compute environment, - {{ ansible_environment }} == 'production'
    |        | # 
    |        | #    But wants to placement multiple virtual environments on same Datacenter to same VMs environment
    |        | # 
    |        | #    All linked environments, which we wants to add as childs like virtual, looks and works by the symlinks way.
    |        | # 
    |        | #    Lets do like for example, two childs of primary - developemnt and stage environments, 
    |        | # 
    |        | #    1.1 Create the new folders in api cloud inventory - 
    |        | #
    |        | #     /0z-cloud/products/\!_{{ cloud_type }}/{{ ansible_product }}/developemnt/ 
    |        | #     /0z-cloud/products/\!_{{ cloud_type }}/{{ ansible_product }}/stage/ 
    |        | # 
    |        | #    1.2 Create symlinks from parent primary cloud dynamic environment to his new childs -
    |        | # 
    |        | #        1.2.0  mkdir /0z-cloud/products/\!_{{ cloud_type }}/{{ ansible_product }}/stage/ 
    |        | #        1.2.1  cd ./0z-cloud/products/\!_{{ cloud_type }}/{{ ansible_product }}/stage/ 
    |        | #        1.2.2  ln -s stage/v.py ./production/r.py 
    |        | #        1.2.3  ln -s stage/bootstrap_vms ./production/bootstrap_vms 
    |        | #            
    |        | #    1.3 Copy the target inventory from parent to new, firstaful create a target inventories localtions -
    |        | #            
    |        | #        1.3.0  mkdir ./products/{{ ansible_product }}/stage 
    |        | #        1.3.1  cp -R ./products/{{ ansible_product }}/production/* ./products/{{ ansible_product }}/{{ new_environment }}/ 
    |        | # 
    |        | #    1.4 Done, now change the domain names and ports settings on your new cloud target childs from production environments, and deploy!
    |        | #


# USAGE DYNAMIC CLOUD INVENTORIES

  * Making new inventories from scratch, with examples and describsions about why we need that and for what

  
  ./\!_mk_new_env.sh production vortex bare symlink bare setta vortex
  
Necessary input values to select your way to create a new environment, product, scale, or during some migrate or update to your infrastracure.

  - (1) inventory:    Parent inventory is must to be a specified, which be a donor for new inventory

  - (2) product:      Parent product is must to be a specified, which be a donor for new cloud config

  - (3) type cloud:   Parent cloud type is must to be a specified, like { vsphere / alicloud / bare / etc }

  - (4) run type:     Type of spawning the scratcher, from other repo, ways for choice { clone / symlink }

  - (5) type cloud:   Target cloud type is must to be a specified, like { vsphere / alicloud / bare / etc }

  - (6) inventory:    Target inventory is must to be a specified, which be a result of new inventory for cloud location

  - (7) product:      Target product is must to be a specified, which be a result for new cloud location

  - (!) INFO JUST FOR READ IMPORTANT AGAIN:

    We have two basical types of inventories - 

      I. Dynamic ```bootstrap inventory``` prefilled for create the instances - 

        ```inventories/0z-cloud/products```.
       
        0z-cloud:

          - inventory start point of your cloud - very simple way to work
          - inventory - cloud bootstrap and check or validate your cloud infrastructure.
          - availiable in two types of run - api or baremetal. 
          - contain dict and variables which you wants about infrastructure

      II. Target Inventory after ```bootstrap inventory``` which contains settings needed after bootstrap the instances - 

        ```inventories/products``` + {{ ansible_product }} + {{ ansible_environment }}

        basic concept:

          - {{ ansible_product }} firsteful created like abstract to follow in repository, like distributed float availiability zone.
          - As single point of improve, start the abstract, which communicate all different solutions by one way. 
          - can be a template or like a mixed point off decision, where we have a completely data to manage our business processes.
          - For every day progress, - import from zero to excellent. 
          - Total completely the tasks for developing, building, testing, merge and deploying your perfect software CI/CD/QA process.
          - Use a conception to distribute or realocate / replicate / add, or chage a parts of your local or multi-dc configuration
          - Part new or full new, ansible_product, and be a child or be a parent. 
          - We can mix on flyed local metric reasons some configurations and deployments, and also not presented and fully like RnD.
          - Possibled usage path, can give go you understand, presented in few magic examples, so, i very happy you at here. 
          - lest go.


