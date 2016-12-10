var node = document.querySelector(".elm-container");
var authTokenKey = "authToken";

// Config
var config = JSON.parse(
  document.querySelector(".config").innerHTML
);

// Setup Elm app
var app = Elm.Main.embed(
  node,
  { authToken: localStorage.getItem(authTokenKey)
  , pathToRoot: config.pathToRoot
  }
);

// Ports
app.ports.storeAuthToken.subscribe(function(authToken) {
  localStorage.setItem(authTokenKey, authToken);
});

app.ports.askForConfirmation.subscribe(function(message) {
  app.ports.confirm.send(!!window.confirm(message));
});
