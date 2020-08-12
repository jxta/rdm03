# add by vcp
# 本ファイルは Jupyter Notebookの .jupyter/jupyter_notebook_config.py
# の末尾に追記される

# Disable cross-site-request-forgery protection
c.NotebookApp.disable_check_xsrf = True  # noqa: cは定義済み
c.NotebookApp.allow_origin = "*"  # noqa: cは定義済み

import os

if "SUBDIR" in os.environ:  # noqa: osはimport済み
    subdir = os.environ["SUBDIR"]  # noqa: osはimport済み
    c.NotebookApp.base_url = "/%s/" % (subdir)  # noqa: cは定義済み
    c.NotebookApp.base_project_url = "/%s/" % (subdir)  # noqa: cは定義済み
    c.NotebookApp.webapp_settings = {  # noqa: cは定義済み
        "static_url_prefix": "/%s/static/" % (subdir)
    }  # noqa: cは定義済み
