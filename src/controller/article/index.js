module.exports = {
	async list(params) {
		var param = params[0];
		var user_id = param.user_id;
		var type = param.type;
		var blogs = this.think.model('blogs');
		var options = {};
		if (type) {
			options.type = type;
		}
		if (user_id) {
			options.user_id = user_id;
		} else {
			options.type = 1;
		}
		let data = await blogs.where(options).select();
		// console.log('list: ', data);
		for (var i = 0, item; item = data[i++];) {
			item.isAuther = (item.user_id == user_id);
		}
		return data;
	},
	async list_public(params) {
		var blogs = this.think.model('blogs');
		var options = { type: 1};
		let data = await blogs.where(options).select();
		return data;
	},
	async add(params) {
		var user_id = params[0];
		var blogs = this.think.model('blogs');

		let data = await blogs.add(params[0]);
		return data;
	},
	async update(params, parent) {
		var param = params[0],
			data = {},
			blogs = this.think.model('blogs'),
			art = await blogs.where({ id: param.blog_id }).find();

		if (param.user_id.toString() === art.user_id.toString()) {
			data = await blogs.where({id: param.blog_id}).update({title: param.title, text: param.text});
		} else {
			parent.body.code = 10500;
			parent.body.msg = '您没有权限编辑这边文章';
			data = {};
		}
		return data;
	},
	async delete(params) {
		var param = params[0];
		var blogs = this.think.model('blogs');
		// console.log('delete: ', param);
		let data = await blogs.where({id: param.blog_id}).delete();
		return data;
	},
	async detail(params) {
		var param = params[0],
			blogs = this.think.model('blogs'),
			user = this.think.model('user');

		let data = await blogs.where({ id: param.id }).find();
		let user_info = await user.where({ id: data.user_id }).find();
		data.isAuther = (data.user_id == param.user_id);
		return {
			'detail': data,
			'user_info': {
				'id': user_info.id,
				'phone': user_info.phone,
				'name': user_info.name
			}
		};
	},
	async detail_public(params) {
		var param = params[0],
			blogs = this.think.model('blogs'),
			user = this.think.model('user');

		let data = await blogs.where({ id: param.id }).find();
		let user_info = await user.where({ id: data.user_id }).find();
		return {
			'detail': data,
			'user_info': {
				'id': user_info.id,
				'phone': user_info.phone,
				'name': user_info.name
			}
		};
	}
};