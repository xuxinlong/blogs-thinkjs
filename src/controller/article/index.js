module.exports = {
    async list(params) {
    	var user_id = params[0];
    	user_id = 1;
        var blogs = this.think.model('blogs');
        let data = await blogs.where({user_id: user_id}).select();
        return data;
    },
    async add(params) {
    	var user_id = params[0];
        var blogs = this.think.model('blogs');

        let data = await blogs.add(params[0]);
        return data;
    },
    async detail(params) {
        params = params[0];
        var blogs = this.think.model('blogs');

        let data = await blogs.where({id: params.id}).find();
        return data;
    },
};