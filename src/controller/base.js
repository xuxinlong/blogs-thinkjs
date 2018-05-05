module.exports = class extends think.Controller {
	// 在具体的 Action 执行之前执行
  __before() {
  	// console.log('__before: ', this.ctx.request, this.body);
  	// console.log('__before: ', this.ctx.request.header);
  	this.body = {
      code: 0,
      data: '',
      msg: 'ok'
  	}
		// 判断用户是否登录
    var user_id;
    if (this.ctx.request.header['x-access-token']) {
      user_id = this.checkCookie(this.ctx.request.header['x-access-token']);
    }
    if (!user_id) {
	    this.body.code = 12011;
	    this.body.msg = 'Not logged on';
    }
  }

  // 在具体的 Action 执行之后执行
  __after() {
  	console.log('__after');
  }

  // 获取cookie
	getCookie(name) {
	  const reg = new RegExp(`(^| )${name}=([^;]*)(;|$)`);
	  const arr = this.ctx.request.header.cookie.match(reg);
	  if (arr) {
	    return (arr[2]);
	  }
	  return null;
	}

	// 校验cookie
	checkCookie(token) {
		var user_id;
		if (token && token === this.cookie(token.split('-')[0])) {
			user_id = Number(token.split('-')[0]);
		}
		return user_id;
	}

	// 分配对应的处理函数
  async getHandle(_module) {
    var route = this.ctx.request.url.split('/'),
      handle = _module;
     // console.log('route: ', route);
     // console.log('handle: ', handle);
    for (var i = 3, len = route.length; i < len; i++) {
      handle = handle[route[i]];
    }
    var data = await handle(Array.prototype.slice.call(arguments, 1), this);
    return data;
  }
};
