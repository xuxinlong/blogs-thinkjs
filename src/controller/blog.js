const Base = require('./base.js');
const article = require('./article/index.js');

module.exports = class extends Base {
  async articleAction() {
    // console.log(this.ctx.request, this.body);
    var user_id;
    if (this.ctx.request.header.cookie) {
      user_id = this.checkCookie(this.getCookie('blog_token'));
    }

    var params = this[this.ctx.request.method.toLowerCase()]();
    params.user_id = user_id;
    var data = await this.getHandle(article, params);
    this.body.data = data
    return;
  }
};
