function fib(max) {
	var
		t,
		a=0,
		b=1,
		arr = [0,1];
	while (arr.length < max) {
		t = a+b;
		a = b;
		b = t;
		arr.push(t);
	}
	return arr;
}

console.log(fib(0));
console.log(fib(1));
console.log(fib(2));
console.log(fib(5));
