import http from "http";
import url from "url";

const PORT = process.env.PORT || 5000;

const routes = {
  "/api/health": () => ({ ok: true, service: "powernet-backend" }),
  "/api/version": () => ({ version: "0.1.0-mock" }),
  "/api/tariffe": () => ({ c1: 2.0, c2: 1.5 }),
  "/api/ha/config": () => ({ ok: true, message: "HA mock config salvata" }),
  "/api/ha/states": () => ([
    { entity_id: "sensor.acqua_app1_total", state: "123", attributes: { friendly_name: "App 1", unit_of_measurement: "m³" }},
    { entity_id: "sensor.acqua_app2_total", state: "456", attributes: { friendly_name: "App 2", unit_of_measurement: "m³" }}
  ])
};

const server = http.createServer((req,res)=>{
  const { pathname } = url.parse(req.url,true);
  res.setHeader("Content-Type","application/json");
  if (routes[pathname]) {
    return res.end(JSON.stringify(routes[pathname]()));
  }
  res.statusCode = 404;
  res.end(JSON.stringify({ ok:false, error:"not_found", path: pathname }));
});

server.listen(PORT, ()=> console.log(`✅ Powernet backend mock avviato su porta ${PORT}`));
