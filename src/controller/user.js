const Base = require('./base.js');
const user = require('./user/index.js');

module.exports = class extends Base {
	async userAction() {
		var params = this[this.ctx.request.method.toLowerCase()]();
		if (this.ctx.request.header['x-access-token']) {
			params.user_id = this.checkCookie(this.ctx.request.header['x-access-token']) || '';
		}
		var data = await this.getHandle(user, params);
		var noWrapUrl = ['/user/user/login_public'];
		if (params.action === 'config' || noWrapUrl.indexOf(this.ctx.request.url) > -1) {
			this.body = data;
			return;
		}
		this.body.data = data;
		return;
	}
};
