#!/bin/bash -e

# see https://quarkus.io/guides/infinispan-client-guide#quarkus-infinispan-client_configuration
function set_infinispan_props() {
    local infinispan_props=""

    if [[ "${INFINISPAN_USEAUTH}" == "true" ]] && [[ -z "${INFINISPAN_USERNAME}"  || -z "${INFINISPAN_PASSWORD}" ]]; then
        echo "[ERROR] Flag INFINISPAN_USEAUTH set to true, but no username or password informed. Please use INFINISPAN_USERNAME and INFINISPAN_PASSWORD variables to set the right credentials."
        exit 1
    fi

    if [ -z "${INFINISPAN_USERNAME}" ]; then
        if [ ! -z "${INFINISPAN_USEAUTH}" ]; then
            INFINISPAN_USEAUTH="false"
        fi
    fi
 
    if [ ! -z "${INFINISPAN_USERNAME}" ]; then infinispan_props=$(echo "${infinispan_props} -Dquarkus.infinispan-client.auth-username=${INFINISPAN_USERNAME}"); INFINISPAN_USEAUTH="true"; fi
    if [ ! -z "${INFINISPAN_PASSWORD}" ]; then infinispan_props=$(echo "${infinispan_props} -Dquarkus.infinispan-client.auth-password=${INFINISPAN_PASSWORD}"); fi
    if [ ! -z "${INFINISPAN_USEAUTH}" ]; then infinispan_props=$(echo "${infinispan_props} -Dquarkus.infinispan-client.use-auth=${INFINISPAN_USEAUTH}"); fi
    if [ ! -z "${INFINISPAN_AUTHREALM}" ]; then infinispan_props=$(echo "${infinispan_props} -Dquarkus.infinispan-client.auth-realm=${INFINISPAN_AUTHREALM}"); fi
    if [ ! -z "${INFINISPAN_SASLMECHANISM}" ]; then infinispan_props=$(echo "${infinispan_props} -Dquarkus.infinispan-client.sasl-mechanism=${INFINISPAN_SASLMECHANISM}"); fi

    echo $infinispan_props
}

