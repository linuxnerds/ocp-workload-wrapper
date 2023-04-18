#!/usr/bin/env bash
# Author: 
#   - Mitesh The Mouse, mitsharm@redhat.com
#   - Tyrell Reddy, treddy@redhat.com
#   - Prakhar Srivastava, psrivast@redhat.com
# Team: APAC-DemoLISHERS
# License: GPLv3
# Version: 0.1

wrapper_openshift_inputs() {
    read -p "Provide OpenShift cluster API: " w_ocp_cluster_api
    read -p "Provide OpenShift cluster Username: " w_ocp_cluster_user
    read -p "Provide OpenShift cluster User's Token [For password hit enter]: " w_ocp_cluster_token
    if [ ${#w_ocp_cluster_token} -eq 0 ]; then
        read -p "Provide OpenShift cluster User's Password: " w_ocp_cluster_password
    fi
}

wrapper_agnosticd_inputs() {
    read -p "Provide AgnosticD repository [Default: redhat-cop/agnosticd]: " w_agd_git_repo
    read -p "Provide repository version (tag or branch) [Default: development]: " w_agd_git_version
    read -p "Provide Variables file path: " w_agd_variables_file_path
    # if [ ${#w_agd_variables_file_path} -eq 0 ]; then
        # printf "\n%s\n\n" "Variables file path can't be empty"
        # exit 2
    # fi
}

wrapper_argocd_inputs() {
    read -p "Provide ArgoCD git repository URL: " w_argocd_gir_url
}

wrapper_custom_playbook_inputs() {
    read -p "Provide git repository URL for custom playbook: " w_custom_playbook_git_url
}

# w_agnosticd_processor() {


# }
wrapper_virtualenv() {
    if [ ! -f /tmp/wrapper/bin/activate ]; then
        sudo -- bash -c '
        python3 -m venv /tmp/wrapper;
        source /tmp/wrapper/bin/activate;
        python3 -m pip install -U pip;
        python3 -m pip install -r requirements.txt
        deactivate'
        source /tmp/wrapper/bin/activate
    else
        source /tmp/wrapper/bin/activate
    fi
}


modes=(AgnosticD GitOps  Custom_Playbook Validation)
wrapper_welcome_msg="Welcome to ocp workload wrapper"
wrapper_continue_msg="Wrapper will ask few question to proceed further
To continue type y [y/n]"
wrapper_processor() {
    printf "\n"
    read -n 1 -p "Do you have up and running OpenShift Cluster? [y/n]: " w_ocp_cluster_status;  printf "\n"
    if [ "${w_ocp_cluster_status}" == "y" ]; then
        wrapper_openshift_inputs
        printf "\n"
        PS3="Select the mode to run OpenShift workload [Enter Number]: "
        select mode in ${modes[*]}
        do
            case ${mode} in
                AgnosticD)
                    wrapper_agnosticd_inputs
                    wrapper_virtualenv
                    ;;
                GitOps) 
                    wrapper_argocd_inputs
                    ;;
                Custom_Playbook) 
                    wrapper_custom_playbook_inputs
                    ;;
            esac
            break
        done
    else
        printf "\n%s\n\n" "You should have up and running OpenShift Cluster to setup and run wrapper"
        exit 2
    fi
}

main() {
    clear
    printf "\n%s\n\n" "${wrapper_welcome_msg}"
    read -n 1 -p "${wrapper_continue_msg}: " w_continue ; printf "\n"
    if [ "${w_continue}" == "y" ]; then
        wrapper_processor
    else
        printf "\n%s\n\n" "Sorry to see you quitting soon."
    fi
}

main
         