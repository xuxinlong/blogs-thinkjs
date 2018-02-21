module.exports = class extends think.Model {
	get_articlei_nfo() {
        const user = this.model('user');
		console.log('model: getArticleInfo');
	}
};
