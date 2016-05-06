from flask.ext.httpauth import HTTPBasicAuth
from .errors import forbidden
from . import api


auth = HTTPBasicAuth()

@auth.verify_password
def verify_password(email,password):
	if email == '':
		g.current_user = AnonymousUser()
		return True
	user = User.query.filter_by(email=email).first()
	if not user:
		return False
	g.current_user = user
	return user.verify_password(password)

@api.before_request
@auth.login_required
def before_request():
	if not g.current_user.is_annonymous and not g.current_user.confirmed:
		return forbidden('需要认证')
