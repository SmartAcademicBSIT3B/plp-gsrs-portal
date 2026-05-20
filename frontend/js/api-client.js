(function (w) {
  var explicitBase = (w.__API_BASE_URL__ || "").trim();
  var storedBase = "";
  try {
    storedBase = (w.localStorage.getItem("apiBaseUrl") || "").trim();
  } catch (_err) {
    storedBase = "";
  }

  var base = explicitBase || storedBase;
  if (!base) {
    base = "/backend";
  }

  base = base.replace(/\/+$/, "");

  w.getApiBaseUrl = function () {
    return base;
  };

  w.apiUrl = function (path) {
    var normalized = String(path || "");
    if (!normalized.startsWith("/")) {
      normalized = "/" + normalized;
    }
    return base + normalized;
  };

  w.apiFetch = function (path, options) {
    var requestOptions = options ? Object.assign({}, options) : {};
    if (!requestOptions.credentials) {
      requestOptions.credentials = "include";
    }
    return w.fetch(w.apiUrl(path), requestOptions);
  };
})(window);
