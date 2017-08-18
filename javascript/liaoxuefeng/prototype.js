function Student(name) {
	this.name = name;
}

Student.prototype.hello = function() {console.log("Hello, " + this.name + "!");};

var xiaoming = new Student('小明');
console.log(xiaoming.prototype);
console.log(Object.getPrototypeOf(xiaoming));
console.log(Student.prototype);
console.log(xiaoming.__proto__);
