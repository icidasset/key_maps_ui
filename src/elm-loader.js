var node = document.querySelector(".elm-container");
var authTokenKey = "authToken";

// Setup Elm app
var app = Elm.Main.embed(node, { authToken: localStorage.getItem(authTokenKey) });

// Ports
app.ports.storeAuthToken.subscribe(function(authToken) {
  localStorage.setItem(authTokenKey, authToken);
});
