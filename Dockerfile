FROM ubuntu:focal
ARG username
RUN apt-get update && \
    apt-get install curl -y && \
    apt-get install wget -y && \
    apt-get install git -y && \
    apt-get install ansible -y && \
    apt-get install sudo -y && \
    apt-get install sshpass -y && \
    apt-get install vim -y && \
    apt-get install rsync -y && \
    apt-get install build-essential -y && \
    apt-get install make -y && \
    apt-get install iproute2 -y && \
    apt-get install bash -y && \
    apt-get install zsh -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-3.1
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn
RUN useradd -m -s /bin/zsh ${username} && \
    usermod -aG sudo ${username} 
WORKDIR /home/${username}
ADD .ssh /home/${username}/.ssh
RUN chown ${username}:${username} /home/${username}/.ssh && \
    chown ${username}:${username} /home/${username}/.ssh/* && \
    chmod 644 /home/${username}/.ssh/* && \
    chmod 600 /home/${username}/.ssh/id_*
USER ${username}
RUN mkdir ~/source
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash && \
    sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' ~/.zshrc
RUN echo "export NVM_DIR=\"\$HOME/.nvm\"" >> ~/.zshrc && \
    echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\"" >> ~/.zshrc && \
    echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \\. \"\$NVM_DIR/bash_completion\"" >> ~/.zshrc
