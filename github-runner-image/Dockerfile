FROM ubuntu:18.04
# set the github runner version
# ARG RUNNER_VERSION="2.286.1"
# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y unzip git && useradd -m docker
# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN apt-get install -y curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash
RUN apt-get install -y nodejs
RUN apt update \
    && apt install -y ca-certificates openssh-client \
       wget curl iptables supervisor \
    && rm -rf /var/lib/apt/list/*
# cd into the user directory, download and unzip the github actions runner
RUN RUNNER_VERSION=$(curl -sL https://api.github.com/repos/actions/runner/releases/latest | jq -r ".tag_name" | sed 's/v//g') \
    && cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh
# copy over the start.sh script
COPY start.sh start.sh
# make the script executable
RUN chmod +x start.sh
# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
#USER docker
# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]