FROM jxta/vcp_client:20190826-ssl
RUN pip install --no-cache notebook
ENV HOME=/tmp
