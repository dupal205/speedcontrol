let CallBack = {}

window.addEventListener("message", function(event) {
    const nui = event.data;
    if (typeof(nui.type) !== "string") {
        console.error("[domiNUI] type Not Allow");
        return;
    }
    const function_run = CallBack[nui.type];
    if (typeof(function_run) !== "function") {
        console.error("[domiNUI] Type Callback Not Found");
        return;
    }
    function_run(nui);
});