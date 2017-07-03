var empty = {};
console.log(empty.toString);
console.log(empty.toString());
console.log(Object.getPrototypeOf({}) == Object.prototype);
console.log(Object.getPrototypeOf(Object.prototype));
console.log(Object.getPrototypeOf([]));
console.log(Array.prototype);

var protoRabbit = {speak:function(line){
	console.log("The " + this.type + " rabbit says '" + line + "'")
	}
};

var killerRabbit = Object.create(protoRabbit);
killerRabbit.type = "killer";
killerRabbit.speak("SKREEEE!");

function Rabbit(type) {
	this.type = type;
}

var killerRabbit = new Rabbit("killer");
var blackRabbit = new Rabbit("black");
console.log(blackRabbit.type);
console.log(Object.getPrototypeOf(killerRabbit));
console.log(Object.getPrototypeOf(Rabbit));

console.log(Rabbit.prototype);

Rabbit.prototype.speak = function(line) {
	console.log("The " + this.type + " rabbit says '" + line + "'");
}

blackRabbit.speak("Doom...");

