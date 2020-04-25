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
    
    * Deploy pipeline:
    
        * Prepare CI 
     
        * Build and Push Docker images - Build your software and necessary backend/database/services images for able to work your own software.
    
           ```
           ./\!_all_services_builder.sh
        
           ```
           
        * Validate Deployment and Deploy - Deploy to Docker Swarm / K8 / Standalone updated manifests, perform DB migrations.

           ```
           ./\!_all_services_deployer.sh
           
           ```
          
        * Update the Backend DNS & Web-Server (nginx) configurations - update DNS & webserver configurations and check some list of backend services like monitoring, ntp, etc.
        
           ```
           ./\!_all_services_internal.sh
        
           ```
    
        * Run the QA part of pipeline - running your custom QA test suites. You must enable that part of pipeline by itself because default state of feature is disabled.
        
           ```
           ./\!_0z-quality_assurance.sh
        
           ```
    
    
  * You can customize each part of pipeline, playbooks and roles.

## Principial workflow

### Directory structure for dynamic inventories, describes basical call flow

![Directory_structure](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/vortex_work_map.png)

### ZeroCloud configuration flow inside and only on ansible calls

![Api_flow_dynamic_inventories](https://github.com/westsouthnight/vortex/blob/master/ansible/CI/vortex_api_generate_flow.png)

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
            ln -s stage/v.py ./production/v.py 
            ln -s stage/bootstrap_vms ./production/bootstrap_vms 

   * Copy the target inventory from parent to new, firstaful create a target inventories localtions -
            
            mkdir ./products/{{ ansible_product }}/stage 
            cp -R ./products/{{ ansible_product }}/production/* ./products/{{ ansible_product }}/{{ new_environment }}/ 

   * Done, now change the domain names and ports settings on your new cloud target childs from production environments, and deploy!

