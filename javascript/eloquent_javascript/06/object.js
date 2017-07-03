var rabbit = {};
rabbit.speak = function(line) {
	console.log("The rabbit says '" + line + "'");
}
rabbit.speak("I'm alive");

function speak(line) {
	console.log("The " + this.type + "rabbit says '" + line + "'");
}
var whiteRabbit = {type:"white", speak:speak};
var fatRabbit = {type:"fat", speak:speak};
whiteRabbit.speak("Oh my ears and whiskers," + "hot late it's getting!");
fatRabbit.speak("I could sure sue a carrot right now.");

speak.apply(fatRabbit, ["Burp!"]);
speak.call({type:"old"}, "Oh my.");
speak.call(whiteRabbit, "I test call");
