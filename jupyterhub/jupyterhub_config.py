c = get_config()

c.JupyterHub.authenticator_class = 'jupyterhub.auth.PAMAuthenticator'
c.Authenticator.admin_users = {'jupyter'}
c.Authenticator.allowed_users = {'jupyter'}
c.LocalAuthenticator.create_system_users = True
c.Spawner.default_url = '/lab'
c.Spawner.args = ['--NotebookApp.iopub_data_rate_limit=1.0e10']
