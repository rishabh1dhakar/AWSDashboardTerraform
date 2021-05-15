###############
# help function
###############
print_help() {
    echo "Usage: $0 [option...] {plan|apply}" >&2
    echo
    echo "   -h, --help           show this help text"
    echo "   -a, --accounts       please provide a list of accounts in which to do terraform apply "
    echo "   -t, --tf_dir         please provide the directory in which to do a terraform apply"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

cleanup() {
    echo "Cleanup terraform folder files in directory $tf_dir"
    cd $tf_dir
    echo "Current path is: `pwd`"
    rm -rf .terraform && rm -f .terraform.lock.hcl && rm -f terraform.tfstate*
}

tfinit() {
   awsume -u
   eval $(awsume -s $a.AWSAdministratorAccess)
   echo "Running terraform init in $tf_dir"
   terraform init -backend-config=$PROJECT_SRC_ROOT/backend-config/$a/backend.tfvars
}

tfplan() {
  awsume -u
  eval $(awsume -s $a.AWSAdministratorAccess)
  echo "Running terraform plan in $tf_dir for account $a"
  cd $tf_dir
  terraform plan -var-file=$PROJECT_SRC_ROOT/backend-config/$a/config.tfvars
}


tfapply() {
  awsume -u
  eval $(awsume -s $a.AWSAdministratorAccess)
  echo "Running terraform apply with auto-approve in $tf_dir for account $a"
  cd $tf_dir
  terraform apply -var-file=$PROJECT_SRC_ROOT/backend-config/$a/config.tfvars -auto-approve
}

plan() {
    for a in `cat $accounts`;
  do
     cleanup
     tfinit
     tfplan
  done
}

apply() {
    for a in `cat $accounts`;
  do
     cleanup
     tfinit
     tfapply
  done
}

################################
# Check if parameters options  #
# are given on the commandline #
################################
while :
do
    case "$1" in
      -a | --accounts)
          if [ $# -ne 0 ]; then
            accounts="$2"
          fi
          shift 2
          ;;
      -h | --help)
          print_help
          exit 0
          ;;
      -t | --tf_dir)
          tf_dir="$2"
           shift 2
           ;;

      --) # End of all options
          shift
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          ## or call function display_help
          exit 1
          ;;
      *)  # No more options
          break
          ;;
    esac
done

###############################################
# Check whether we are doing tf plan or apply #
###############################################
case "$1" in
  plan)
    plan
    ;;
  apply)
    apply
    ;;
  *)
#    echo "Usage: $0 [option...] {plan|apply}" >&2
    print_help
    exit 1
    ;;
esac