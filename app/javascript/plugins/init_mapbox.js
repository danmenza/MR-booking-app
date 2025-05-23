import mapboxgl from 'mapbox-gl';
const initMapbox = () => {
    const mapElement = document.getElementById('map');
    const fitMapToMarkers = (map, markers) => {
        const bounds = new mapboxgl.LngLatBounds();
        markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
        map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
    };
    const addMarkersToMap = (map, markers) => {
        markers.forEach((marker) => {
            const popup = new mapboxgl.Popup().setText(marker.name);
            new mapboxgl.Marker({
                    color: '#c9cac7'
                })
                .setLngLat([marker.lng, marker.lat])
                .setPopup(popup)
                .addTo(map);
        });
    };
    if (mapElement) { // only build a map if there's a div#map to inject into
        mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
        const map = new mapboxgl.Map({
            container: 'map',
            style: 'mapbox://styles/dan-menza/cl02p7qpj00k016kdmpr2lgg4'
        });
        const markers = JSON.parse(mapElement.dataset.markers);
        markers.forEach((marker) => {
            new mapboxgl.Marker()
                .setLngLat([marker.lng, marker.lat])
                .addTo(map);
        });
        fitMapToMarkers(map, markers);
        addMarkersToMap(map, markers);
    }
};
export { initMapbox };