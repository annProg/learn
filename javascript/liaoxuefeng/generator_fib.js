function* fib(max) {
	var 
		t,
		a=0,
		b=1,
		n=1;
	while(n<max) {
		yield a;
		t=a+b;
		a=b;
		b=t;
		n++;
	}
	return a;
}

for (var x of fib(5)) {
	console.log(x);
}
