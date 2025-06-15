// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {};

Hooks.CameraInit = {
  mounted() {
    const video = document.getElementById("camera-feed");
    const canvas = document.getElementById("camera-canvas");
    const context = canvas.getContext("2d");

    // Start camera
    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
      navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
        video.srcObject = stream;
        video.play();
      });
    }

    // Auto-capture every 3 seconds, but pause if modal is up
    this.interval = setInterval(() => {
      const pauseAutoCapture = this.el.getAttribute("data-pause-auto-capture") === "true";
      console.log("pauseAutoCapture:", this.el.getAttribute("data-pause-auto-capture"));
      if (!pauseAutoCapture && video.readyState === 4) {
        context.drawImage(video, 0, 0, canvas.width, canvas.height);
        const dataUrl = canvas.toDataURL("image/jpeg");
        this.pushEvent("auto_capture", { image: dataUrl });
      }
    }, 3000);
  },
  destroyed() {
    clearInterval(this.interval);
  }
};

Hooks.RecogModalAutoClose = {
  mounted() {
    this.timer = setInterval(() => {
      this.pushEvent("decrement_recog_modal_timer", {});
    }, 1000);
    this.closeTimeout = setTimeout(() => {
      this.pushEvent("close_recog_modal", {});
    }, 5000);
  },
  destroyed() {
    clearInterval(this.timer);
    clearTimeout(this.closeTimeout);
  }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
});

topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

liveSocket.connect();
window.liveSocket = liveSocket;

