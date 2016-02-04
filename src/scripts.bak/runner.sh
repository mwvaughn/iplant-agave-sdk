#!/bin/bash
# 
# runner.sh
# 
# author: dooley@tacc.utexas.edu
#
# Main processing logic for the scripts
#set -x
# Run it {{{

# Uncomment this line if the script requires root privileges.
# [[ $UID -ne 0 ]] && die "You need to be root to run this script"

# If either credential is missing, force interactive login
#if [ -n "$access_token" ]; then
if [ -n "$apikey" ] || [ -n "$apisecret" ] || [ -n "$apisecret" ] || [ -n "$apisecret" ];
then
	#echo "apikey '$apikey' is not null"
	interactive=1
#elif [ -n "$apisecret" ]; then
	#echo "apisecret '$apisecret' is not null"
#	interactive=1
#elif [ -n "$username" ]; then
	#echo "username '$username' is not null"
#	interactive=1
#elif [ -n "$password" ]; then
	#echo "password '$password' is not null"
#	interactive=1
else
	#echo "Loooking for stored credentials"
	# Otherwise use the cached credentials if available
	if [ "$disable_cache" -ne 1 ]; then
		if [ -f "$HOME/.agave" ]; then
			#echo "Found for stored credentials"
			tokenstore=`cat ~/.agave`
			jsonval apisecret "${tokenstore}" "apisecret" 
			jsonval apikey "${tokenstore}" "apikey" 
			jsonval username "${tokenstore}" "username" 
			jsonval access_token "${tokenstore}" "access_token"
			jsonval refresh_token "${tokenstore}" "refresh_token"
		fi
	fi
	
	if [ -z "$access_token" ]; then
		interactive=1
	fi
fi

if ((interactive)); then
  prompt_options
fi

# Adjust the service url for development
filter_service_url

# Force a trailing slash if they didn't specify one in the custom url
hosturl=${hosturl%/}
hosturl="$hosturl/"

# Delegate logic from the `main` function
authheader=$(get_auth_header)
main

# This has to be run last not to rollback changes we've made.
safe_exit

# }}}
