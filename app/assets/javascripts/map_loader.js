//= require leaflet/dist/leaflet
//= require leaflet.markercluster/dist/leaflet.markercluster
//= require map

$(document).on("turbolinks:before-cache", App.Map.destroy);
