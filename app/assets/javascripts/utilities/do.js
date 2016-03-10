// A very tiny function for parallel/async function calls with the ability to
// exec functions after a delay
w8mngr.do = function(fn, delay = 0, args = {}) {
  if (fn instanceof Function) {
    window.setTimeout(fn(args), delay)
  } else {
    console.log("You must pass a function to w8mngr.do(Function, delay, args = {})")
  }
}
