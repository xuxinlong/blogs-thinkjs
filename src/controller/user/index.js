module.exports = {
	async login(params, parent) {
		var data = { 'code': 10500, 'data': '', 'msg': '系统错误' },
			config = {
				timeout: 30 * 24 * 3600
			},
			param = params[0],
			user = this.think.model('user');
		var user_info = await user.where({'phone': param.phone}).find();
		if (user_info) {
			// 用户存在
			if (user_info.password === param.password) {
				// 输入用户密码正确
				data.msg = '密码正确';
				data.code = 0;
				data.data = user_info;
				parent.cookie(user_info.id.toString(), user_info.id.toString() + '-' + Date.now(), config);

				data.data = { 'token': parent.cookie(user_info.id.toString()), 'config': config };
				console.log('cookie: ', parent.cookie(user_info.id.toString()));
			} else {
				data.msg = '密码不正确';
			}
		} else {
			data.msg = '用户不存在'
		}
		console.log(user_info);
		// let data = await blogs.where({user_id: user_id}).select();
		return data;
	},
};