#!/usr/bin/env python3

import os

modes = ["AgnosticD", "GitOps", "Custom_Playbook", "Validation"]
wrapper_welcome_msg = "Welcome to ocp workload wrapper"
wrapper_continue_msg = "Wrapper will ask few question to proceed further. To continue type y [y/n]"


def wrapper_openshift_inputs():
    global w_ocp_cluster_api, w_ocp_cluster_user, w_ocp_cluster_token, w_ocp_cluster_password
    w_ocp_cluster_api = input("Provide OpenShift cluster API: ")
    w_ocp_cluster_user = input("Provide OpenShift cluster Username: ")
    w_ocp_cluster_token = input("Provide OpenShift cluster User's Token [For password hit enter]: ")
    if not w_ocp_cluster_token:
        w_ocp_cluster_password = input("Provide OpenShift cluster User's Password: ")


def wrapper_agnosticd_inputs():
    global w_agd_git_repo, w_agd_git_version, w_agd_variables_file_path
    w_agd_git_repo = input("Provide AgnosticD repository [Default: redhat-cop/agnosticd]: ")
    w_agd_git_version = input("Provide repository version (tag or branch) [Default: development]: ")
    w_agd_variables_file_path = input("Provide Variables file path: ")


def wrapper_argocd_inputs():
    global w_argocd_gir_url
    w_argocd_gir_url = input("Provide ArgoCD git repository URL: ")


def wrapper_custom_playbook_inputs():
    global w_custom_playbook_git_url
    w_custom_playbook_git_url = input("Provide git repository URL for custom playbook: ")


def wrapper_virtualenv():
    if not os.path.isfile("/tmp/wrapper/bin/activate"):
        os.system("python3 -m venv /tmp/wrapper")
        os.system("source /tmp/wrapper/bin/activate")
        os.system("python3 -m pip install -U pip")
        os.system("python3 -m pip install -r requirements.txt")
        os.system("deactivate")
        os.system("source /tmp/wrapper/bin/activate")
    else:
        os.system("source /tmp/wrapper/bin/activate")


def wrapper_processor():
    global modes
    print()
    w_ocp_cluster_status = input("Do you have up and running OpenShift Cluster? [y/n]: ")
    if w_ocp_cluster_status == "y":
        wrapper_openshift_inputs()
        print()
        choice = input("Select the mode to run OpenShift workload:\n" + "\n".join(f"{i+1}. {mode}" for i, mode in enumerate(modes)) + "\n")
        mode = modes[int(choice) - 1]
        if mode == "AgnosticD":
            wrapper_agnosticd_inputs()
            wrapper_virtualenv()
        elif mode == "GitOps":
            wrapper_argocd_inputs()
        elif mode == "Custom_Playbook":
            wrapper_custom_playbook_inputs()
    else:
        print("\nYou should have up and running OpenShift Cluster to setup and run wrapper\n")
        exit(2)


def main():
    global wrapper_welcome_msg, wrapper_continue_msg
    os.system("clear")
    print(f"\n{wrapper_welcome_msg}\n")
    w_continue = input(f"{wrapper_continue_msg}: ")
    if w_continue == "y":
        wrapper_processor()
    else:
        print("\nSorry to see you quitting soon.\n")


if __name__ == "__main__":
    main()
