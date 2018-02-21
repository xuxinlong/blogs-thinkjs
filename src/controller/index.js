const Base = require('./base.js');

module.exports = class extends Base {
  indexAction() {
  	console.log('controller: ');
    return this.display();
  }
};
