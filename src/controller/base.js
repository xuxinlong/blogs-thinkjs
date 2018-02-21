module.exports = class extends think.Controller {
  __before() {
  	console.log('__before');
  }
  // 在具体的 Action 执行之后执行
  __after() {
  	console.log('__after');
  }
};
