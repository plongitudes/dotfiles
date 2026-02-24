function clickCloseButton() {
    // grab matching elements
    var elements = document.getElementsByClassName("btn-close i i-close tab-focus");

    // slice to an Array
    elements = Array.prototype.slice.call(elements);

    if(!elements.length) return;
    elements.forEach(function(btn) {
        btn.click();
    });
}

// Select the target element to observe
//const elements = document.getElementById("myElement");
var elements = document.getElementsByClassName("btn-close i i-close tab-focus");

// Create a new MutationObserver instance with a callback function
const observer = new MutationObserver(callback);

// Define the callback function to handle mutations
function callback(mutationsList, observer) {
  // Loop through the mutationsList to process each mutation
  for (let mutation of mutationsList) {
    // Check the type of mutation
    if (mutation.type === "childList") {
      console.log("A child node has been added or removed.");
      // Handle child node changes here
    } else if (mutation.type === "attributes") {
      console.log("Attributes of the target element have been modified.");
      // Handle attribute changes here
    }
  }
}

// Configure the MutationObserver options
const config = { childList: true, attributes: true };

// Start observing the target element
observer.observe(elements, config);
