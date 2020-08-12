# Notebookコンテナ(vcp, user)を作成するDockerfile
# 共通部分(vcp, user)

# digestでイメージを指定済み
# hadolint ignore=DL3007
#FROM niicloudoperation/notebook:latest@sha256:0ef08db97dbdbdc2931eb4960b0533ec811d302d440440a51388be642c5c151a as notebook_common
# docker login が必要
FROM jxta/niicloudoperationnotebook:20200812

USER root
# python3 path
ENV PATH /opt/conda/bin:/notebooks/notebook/vcpsdk/cli:$PATH
# PYTHONPATH for notebook
ENV PYTHONPATH=/notebooks/notebook/vcpsdk
# jessieはアーカイブ済みなので、jessie-updateのurを削除する
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  cron \
  fonts-vlgothic \
  ldap-utils\
  less \
  rsync \
  tcptraceroute \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# netaddr==0.7.19 netifaces==0.10.5
RUN /opt/conda/bin/conda install -y nbconvert jsonschema simplejson ruamel.yaml netaddr netifaces
COPY vcpcli_requirements.txt .
RUN /opt/conda/bin/python -m pip install --ignore-installed PyYAML -r vcpcli_requirements.txt

# for runtime directory
RUN mkdir -p "/home/$NB_USER/.local/share/jupyter/runtime"
RUN chown -R "$NB_USER:$NB_GROUP" "/home/$NB_USER/.local/share/jupyter"

# install ca certificate of VCP Manager
COPY tokyo_ca.crt chiba_ca.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates
ENV REQUESTS_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

# setup supervisor for jupyter
RUN pip install supervisor
RUN mkdir /etc/supervisor
COPY supervisord.conf /etc/supervisor/
COPY supervisor_jupyter.conf /etc/supervisor/conf.d/jupyter.ini

# JupyterPassword change script
# /notebooks/notebook
RUN chown "$NB_USER" .
RUN mkdir tools
COPY chpasswd.sh tools

ENV GIT_EDITOR vi

# gitのブランチ名、補間
COPY git-prompt /etc/

# ENTRYPOINT ["/opt/conda/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# VCPでのJupyter Notebook固有の設定
# Jupyter Notebook内のユーザとグループ
ENV NB_USER jovyan
ENV NB_GROUP users

ENV PATH /opt/conda/bin:/notebooks/notebook/vcpsdk/cli:$PATH

# jupyter notebook config にvcp用の設定を追加
COPY vcp_add_config.py /tmp
RUN cat /tmp/vcp_add_config.py >> /home/$NB_USER/.jupyter/jupyter_notebook_config.py

# custom css の設定
COPY custom.css /home/$NB_USER/.jupyter/custom/custom.css.vcp
RUN cat /home/$NB_USER/.jupyter/custom/custom.css.vcp >> /home/$NB_USER/.jupyter/custom/custom.css
RUN chown $NB_USER:$NB_GROUP /home/$NB_USER/.jupyter/custom/custom.css

#RUN chown -R $NB_USER:$NB_GROUP /notebooks/notebook
#ARG NB_USER=jovyan
#ARG NB_UID=1000
#ENV USER ${NB_USER}
#ENV NB_UID ${NB_UID}
#ENV HOME /home/${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
