// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// import * as bootstrap from "bootstrap"
import "bootstrap"
import "cocoon-js";

// Initialize Cocoon
document.addEventListener('turbo:load', () => {
  Cocoon.init();
});


$(document).on('turbolinks:load', function () { alert("turbolinks on load event works") })
