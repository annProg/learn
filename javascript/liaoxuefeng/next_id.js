function* next_id() {
	var a=1;
	while(a<101)
	{
		yield a;
		a++;
	}
	return a;
}

function closure_next_id() {
	var id=1;
	return function() {
		return id++;
	}
}

var f = closure_next_id();
console.log(f());
console.log(f());
console.log(f());
console.log(f());
console.log(f());
console.log(f());
