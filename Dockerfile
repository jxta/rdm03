# Notebookコンテナ(vcp, user)を作成するDockerfile
# 共通部分(vcp, user)

# digestでイメージを指定済み
# hadolint ignore=DL3007
#FROM niicloudoperation/notebook:latest@sha256:0ef08db97dbdbdc2931eb4960b0533ec811d302d440440a51388be642c5c151a as notebook_common
# docker login が必要
FROM jxta/niicloudoperationnotebook:20200812

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
