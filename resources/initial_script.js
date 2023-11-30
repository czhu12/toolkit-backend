kit.text(`
# Welcome to Toolkit!
Checkout the [docs](/s/docs) to get started.
`)
const inputText = kit.input("Type in something!");
kit.text("You entered: " + inputText, {key: "text-entered-1"});