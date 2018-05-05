const Base = require('./base.js');
const user = require('./user/index.js');

module.exports = class extends Base {
	async userAction() {
    var params = this[this.ctx.request.method.toLowerCase()]();
    var data = await this.getHandle(user, params);
    this.body.data = data;
    return;
  }
};
