module.exports = class extends think.Model {
	get_article_info() {
        const user = this.model('user');
		console.log('model: getArticleInfo');
	}
};
