if [ -z "$CONCOURSE_URL" ]; then
	echo "CONCOURSE_URL is unset! Exiting..."
	return 1
fi

# this script requires that we eval "$(bbl print-env)" first.
# (make sure that has been done)
if [ -z "$CREDHUB_CLIENT" ]; then
	echo "CREDHUB_CLIENT unset!  Please run:"
	echo "   eval \"$(bbl print-env)\""
	return 1
fi

# login to the BOSH director Credhub using info from bbl
echo "Connecting to Credhub on BOSH Director...."
credhub login

# figure out the path for the vars we want
# (this depends on what we used as our BBL_ENVIRONMENT_NAME)
SECRET_PATH=$(credhub find -n concourse_to_credhub_secret | grep name | awk '{print $NF}')
CA_PATH=$(credhub find -n atc_ca | grep name | awk '{print $NF}')

# read the CA certificate and client secret from the BOSH director's Credhub
echo "Reading environment details from Credhub on BOSH Director...."
SECRET=$(credhub get -n $SECRET_PATH | grep value | awk '{print $NF}')
CERT=$(credhub get -n $CA_PATH -k certificate)

# reset Credhub environment variables to point at the Concourse Credhub
unset CREDHUB_PROXY
export CREDHUB_SERVER="$CONCOURSE_URL:8844"
export CREDHUB_CLIENT=concourse_to_credhub
export CREDHUB_SECRET=$SECRET
export CREDHUB_CA_CERT=$CERT

echo "Connecting to Concourse Credhub..."
credhub login
