const Base = require('./base.js');
const article = require('./article/index.js');

module.exports = class extends Base {
  async getHandle(_module) {
    var route = this.ctx.request.url.split('/'),
      handle = _module;
    for (var i = 3, len = route.length; i < len; i++) {
      handle = handle[route[i]];
    }
    var data = await handle(Array.prototype.slice.call(arguments, 1));
    return data;
  }
  async articleAction() {
    var params = this[this.ctx.request.method.toLowerCase()]();
    var body = await this.getHandle(article, params);
    this.body = body;
    return;
  }
};
