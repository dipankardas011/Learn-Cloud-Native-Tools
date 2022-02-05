(function () {

  if (document.getElementById('globe')) {

    // Gen random paths
    const N_PATHS = 20;
    const MAX_POINTS_PER_LINE = 10000;
    const MAX_STEP_DEG = 1;
    const MAX_STEP_ALT = 0.0035;
    const WRAPPER = document.querySelector('#globe');
    const GLOBE_ELEM = document.createElement("div");
    const gData = [...Array(N_PATHS).keys()].map(() => {
      let lat = (Math.random() - 0.5) * 90;
      let lng = (Math.random() - 0.5) * 360;
      let alt = 0;

      return [[lat, lng, alt], ...[...Array(Math.round(Math.random() * MAX_POINTS_PER_LINE)).keys()].map(() => {
        lat += (Math.random() * 2 - 1) * MAX_STEP_DEG;
        lng += (Math.random() * 2 - 1) * MAX_STEP_DEG;
        alt += (Math.random() * 2 - 1) * MAX_STEP_ALT;
        alt = Math.max(0, alt);

        return [lat, lng, alt];
      })];
    });

    WRAPPER.appendChild(GLOBE_ELEM);

    const globe = Globe()
      .globeImageUrl('https://unpkg.com/three-globe/example/img/earth-dark.jpg')
      .bumpImageUrl('https://unpkg.com/three-globe/example/img/earth-topology.png')
      .backgroundColor('#000')
      .atmosphereColor('rgb(61,144,206)')
      .pathsData(gData)
      .pathColor(() => ['rgba(61,144,206,0.6)', 'rgba(195,63,205,0.6)'])
      .pathDashLength(0.01)
      .pathDashGap(0.004)
      .pathDashAnimateTime(100000)
      .pathPointAlt(pnt => pnt[2])
      .width(WRAPPER.clientWidth)
      .height(WRAPPER.clientHeight)
      (GLOBE_ELEM);

    // Add auto-rotation
    globe.controls().autoRotate = true;
    globe.controls().autoRotateSpeed = 0.6;

    // remove user interaction
    globe.controls().enabled = false;

    // zoom out to ensure everything is in viewport
    globe.controls().object.zoom = 1;

    window.addEventListener('resize', function () {
      globe.width(WRAPPER.clientWidth);
      globe.height(WRAPPER.clientHeight);
    });


  }

})();
