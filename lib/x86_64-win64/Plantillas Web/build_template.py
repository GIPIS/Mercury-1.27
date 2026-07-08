# -*- coding: utf-8 -*-
# Generador de Plantilla01.html para EMAC Mercury
# Ejecutar: python build_template.py
#
# Genera una plantilla con hasta MAX_CANALES cards numeradas secuencialmente.
# Mercury reemplaza #CANALn# con valores reales via GenerarReporteWeb.
# Los placeholders que quedan sin reemplazar se ocultan via JS.

MAX_CANALES = 36   # Canales totales: 0..35 (cubre analogicos + digitales)
MAX_VC = 4         # Valores calculados: VC 0..3

CSS = """
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: "Segoe UI", system-ui, -apple-system, sans-serif;
      background: #0a0f1e; color: #e2e8f0;
      min-height: 100vh; display: flex; flex-direction: column;
    }
    body::before {
      content: ""; position: fixed; inset: 0;
      background: radial-gradient(ellipse at 20% 20%,rgba(30,64,175,.25) 0%,transparent 50%),
                  radial-gradient(ellipse at 80% 80%,rgba(15,118,110,.2) 0%,transparent 50%);
      z-index: 0; pointer-events: none;
    }
    .container { position:relative; z-index:1; max-width:1100px; margin:0 auto; padding:24px 16px; width:100%; }
    .header { display:flex; align-items:center; justify-content:space-between; margin-bottom:32px; padding-bottom:20px; border-bottom:1px solid rgba(255,255,255,.08); }
    .header-left { display:flex; align-items:center; gap:16px; }
    .logo-badge { width:48px; height:48px; border-radius:12px; background:linear-gradient(135deg,#1d4ed8,#0891b2); display:flex; align-items:center; justify-content:center; font-size:24px; }
    .header h1 { font-size:1.5rem; font-weight:700; color:#f1f5f9; letter-spacing:-.02em; }
    .header h1 span { color:#38bdf8; }
    .header-subtitle { font-size:.8rem; color:#64748b; margin-top:2px; }
    .status-badge { display:flex; align-items:center; gap:8px; border-radius:999px; padding:6px 14px; font-size:.78rem; transition:all .3s; }
    .status-online { background:rgba(34,197,94,.1); border:1px solid rgba(34,197,94,.25); color:#4ade80; }
    .status-offline { background:rgba(239,68,68,.1); border:1px solid rgba(239,68,68,.25); color:#f87171; }
    .status-dot { width:7px; height:7px; border-radius:50%; }
    .status-online .status-dot { background:#4ade80; animation:pulse 2s infinite; }
    .status-offline .status-dot { background:#f87171; }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.3} }
    .section-title { font-size:.75rem; font-weight:600; text-transform:uppercase; letter-spacing:.1em; color:#475569; margin-bottom:12px; }
    .cards-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:16px; margin-bottom:24px; }
    .card { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08); border-radius:16px; padding:20px; position:relative; overflow:hidden; transition:border-color .2s,transform .2s; }
    .card:hover { border-color:rgba(56,189,248,.35); transform:translateY(-2px); }
    .card::before { content:""; position:absolute; top:0; left:0; right:0; height:2px; border-radius:16px 16px 0 0; }
    .card-icon { font-size:1.8rem; margin-bottom:10px; display:block; }
    .card-label { font-size:.72rem; font-weight:600; text-transform:uppercase; letter-spacing:.08em; color:#64748b; margin-bottom:6px; }
    .card-value { font-size:1.35rem; font-weight:700; color:#f1f5f9; line-height:1.2; word-break:break-word; }
    .calc-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(220px,1fr)); gap:12px; margin-bottom:28px; }
    .calc-card { background:rgba(255,255,255,.025); border:1px solid rgba(255,255,255,.05); border-radius:12px; padding:14px 18px; display:flex; align-items:center; gap:14px; }
    .calc-icon { font-size:1.4rem; flex-shrink:0; }
    .calc-label { font-size:.72rem; color:#64748b; margin-bottom:2px; }
    .calc-value { font-size:1rem; font-weight:600; color:#cbd5e1; }
    .footer { margin-top:auto; padding-top:20px; border-top:1px solid rgba(255,255,255,.06); display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:8px; }
    .footer-equipo { font-size:.8rem; color:#475569; }
    .footer-equipo strong { color:#94a3b8; }
    .footer-fecha { font-size:.78rem; color:#475569; }
    @media(max-width:600px){ .header{flex-direction:column;align-items:flex-start;gap:12px} .cards-grid{grid-template-columns:repeat(2,1fr)} }
"""

GRAD = [
    "#1d4ed8,#38bdf8", "#0891b2,#34d399", "#d97706,#fbbf24", "#7c3aed,#a78bfa",
    "#be123c,#fb7185", "#15803d,#4ade80", "#4338ca,#818cf8", "#0e7490,#22d3ee",
    "#4d7c0f,#a3e635", "#b91c1c,#fca5a5", "#0369a1,#7dd3fc", "#6d28d9,#c4b5fd",
    "#a16207,#fde047", "#047857,#6ee7b7", "#1e40af,#93c5fd", "#9f1239,#fda4af",
]

card_css = ""
for i in range(MAX_CANALES):
    g = GRAD[i % len(GRAD)]
    card_css += f"    .c{i}::before{{background:linear-gradient(90deg,{g})}}\n"

# Emojis
E_WIND    = "\U0001F4A8"
E_THERMO  = "\U0001F321\uFE0F"
E_DROP    = "\U0001F4A7"
E_COMPASS = "\U0001F9ED"
E_RAIN    = "\U0001F327\uFE0F"
E_SUN     = "\u2600\uFE0F"
E_BREEZE  = "\U0001F32C\uFE0F"
E_WAVE    = "\U0001F30A"
E_MICRO   = "\U0001F52C"
E_SPLASH  = "\U0001F4A6"
E_FLASK   = "\U0001F9EA"
E_HERB    = "\U0001F33F"
E_BAT     = "\U0001F50B"
E_ZAP     = "\u26A1"
E_VIBR    = "\U0001F4F3"
E_CHART   = "\U0001F4CA"
E_ABACUS  = "\U0001F9EE"
E_UP      = "\U0001F4C8"
E_DOWN    = "\U0001F4C9"
E_CLOCK   = "\U0001F550"

UNIT_MAP_JS = f'''
var UNIT_MAP = {{
  "km/h":{{icon:"{E_WIND}",label:"Vel. Viento"}},"m/s":{{icon:"{E_WIND}",label:"Vel. Viento"}},
  "cm/s":{{icon:"{E_WIND}",label:"Vel. Corriente"}},"kn":{{icon:"{E_WIND}",label:"Vel. Viento"}},
  "kt":{{icon:"{E_WIND}",label:"Vel. Viento"}},
  "\\u00b0c":{{icon:"{E_THERMO}",label:"Temperatura"}},"degc":{{icon:"{E_THERMO}",label:"Temperatura"}},
  "c":{{icon:"{E_THERMO}",label:"Temperatura"}},"k":{{icon:"{E_THERMO}",label:"Temperatura"}},
  "%rh":{{icon:"{E_DROP}",label:"Humedad"}},"%hr":{{icon:"{E_DROP}",label:"Humedad"}},
  "\\u00b0":{{icon:"{E_COMPASS}",label:"Dir. Viento"}},"deg":{{icon:"{E_COMPASS}",label:"Dir. Viento"}},
  "mm":{{icon:"{E_RAIN}",label:"Precipitaci\\u00f3n"}},"l/m2":{{icon:"{E_RAIN}",label:"Precipitaci\\u00f3n"}},
  "w/m2":{{icon:"{E_SUN}",label:"Radiaci\\u00f3n"}},"lux":{{icon:"{E_SUN}",label:"Radiaci\\u00f3n"}},
  "hpa":{{icon:"{E_BREEZE}",label:"Presi\\u00f3n"}},"mbar":{{icon:"{E_BREEZE}",label:"Presi\\u00f3n"}},
  "pa":{{icon:"{E_BREEZE}",label:"Presi\\u00f3n"}},"m":{{icon:"{E_WAVE}",label:"Nivel"}},
  "cm":{{icon:"{E_WAVE}",label:"Nivel"}},"ms/cm":{{icon:"{E_MICRO}",label:"Conductividad"}},
  "us/cm":{{icon:"{E_MICRO}",label:"Conductividad"}},"mg/l":{{icon:"{E_SPLASH}",label:"Ox. Disuelto"}},
  "ph":{{icon:"{E_FLASK}",label:"pH"}},"ntu":{{icon:"{E_SPLASH}",label:"Turbidez"}},
  "v":{{icon:"{E_BAT}",label:"Voltaje"}},"mv":{{icon:"{E_BAT}",label:"Voltaje"}},
  "a":{{icon:"{E_ZAP}",label:"Corriente"}},"ma":{{icon:"{E_ZAP}",label:"Corriente"}},
  "psu":{{icon:"{E_WAVE}",label:"Salinidad"}}
}};
var CARDINAL = /^(N|S|E|W|NE|NW|SE|SW|NNE|ENE|ESE|SSE|SSW|WSW|WNW|NNW)$/i;
'''

JS_LOGIC = '''
function getSensorInfo(raw) {
  var um = raw.match(/\\[([^\\]]*)\\]/);
  var unit = um ? um[1].trim().toLowerCase() : "";
  if (raw.indexOf("#CANAL") !== -1 || raw.indexOf("#VC") !== -1) return {empty:true};
  var vp = um ? raw.substring(0, raw.indexOf("[")).trim() : raw.trim();
  if (vp === "" || vp === " ") return {empty:true};
  if (um && um[1].trim() === "") return {empty:true};
  if (CARDINAL.test(vp)) return {icon:"''' + E_COMPASS + '''",label:"Dir. Viento",empty:false};
  if (unit === "") return {icon:"''' + E_CHART + '''",label:null,empty:false};
  if (UNIT_MAP[unit]) return {icon:UNIT_MAP[unit].icon,label:UNIT_MAP[unit].label,empty:false};
  return {icon:"''' + E_CHART + '''",label:null,empty:false};
}
var cards = document.querySelectorAll(".cards-grid .card");
for (var i=0; i<cards.length; i++) {
  var c = cards[i], ve = c.querySelector(".card-value");
  if (!ve) continue;
  var info = getSensorInfo(ve.textContent||"");
  if (info.empty) { c.style.display="none"; continue; }
  c.querySelector(".card-icon").textContent = info.icon;
  var le = c.querySelector(".card-label"), ch = c.getAttribute("data-channel")||"";
  le.textContent = info.label ? ch+" \\u00b7 "+info.label : ch;
}
var ccs = document.querySelectorAll(".calc-grid .calc-card");
for (var i=0; i<ccs.length; i++) {
  var v = ccs[i].querySelector(".calc-value");
  if (!v) continue;
  var t = v.textContent||"";
  if (t.indexOf("#VC")!==-1 || t.trim()==="") ccs[i].style.display="none";
}
// Ocultar secciones vacias
(function(){
  var grids = [document.getElementById("cards-grid"), document.querySelector(".calc-grid")];
  var titles = document.querySelectorAll(".section-title");
  for (var g=0; g<grids.length; g++) {
    if (!grids[g]) continue;
    var items = grids[g].children, any=false;
    for (var j=0; j<items.length; j++) if (items[j].style.display!=="none"){any=true;break;}
    if (!any) { grids[g].style.display="none"; if(titles[g]) titles[g].style.display="none"; }
  }
})();
// Estado de conexion
(function(){
  var b=document.getElementById("status-badge"), f=document.querySelector(".footer-fecha");
  if(!b||!f) return;
  var t=f.textContent||"", p=t.split("Actualizado:");
  if(p.length<2){b.className="status-badge status-offline";b.querySelector(".status-text").textContent="Sin datos";return;}
  var fs=p[1].trim();
  if(fs.indexOf("#FECHA#")!==-1){b.className="status-badge status-offline";b.querySelector(".status-text").textContent="Sin datos";return;}
  var m=fs.match(/(\\d{1,2})[\\/\\-](\\d{1,2})[\\/\\-](\\d{4})\\s+(\\d{1,2}):(\\d{2}):(\\d{2})/);
  if(!m){b.className="status-badge status-online";b.querySelector(".status-text").textContent="En l\\u00ednea";return;}
  var d=new Date(parseInt(m[3]),parseInt(m[2])-1,parseInt(m[1]),parseInt(m[4]),parseInt(m[5]),parseInt(m[6]));
  var diff=(new Date().getTime()-d.getTime())/1000;
  if(diff>300){b.className="status-badge status-offline";b.querySelector(".status-text").textContent="Sin datos recientes";}
  else{b.className="status-badge status-online";b.querySelector(".status-text").textContent="En l\\u00ednea";}
})();
'''

# Cards HTML
cards_html = ""
for i in range(MAX_CANALES):
    cards_html += f'    <div class="card c{i}" data-channel="Canal {i}"><span class="card-icon">{E_CHART}</span><div class="card-label">Canal {i}</div><div class="card-value">#CANAL{i}#</div></div>\n'

calc_icons = [E_ABACUS, E_UP, E_DOWN, E_ZAP]
calc_html = ""
for i in range(MAX_VC):
    calc_html += f'    <div class="calc-card"><span class="calc-icon">{calc_icons[i%4]}</span><div><div class="calc-label">Parametro {i+1}</div><div class="calc-value">#VC{i}#</div></div></div>\n'

html = f"""<!DOCTYPE html>
<html lang="es">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="refresh" content="#T#">
  <meta http-equiv="PRAGMA" content="NO-CACHE">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EMAC Mercury - #NOMBRE#</title>
  <style>{CSS}
{card_css}</style>
</head>
<body>
<div class="container">
  <header class="header">
    <div class="header-left">
      <div class="logo-badge">{E_WAVE}</div>
      <div><h1>EMAC <span>Mercury</span></h1><div class="header-subtitle">Sistema de Monitoreo Ambiental</div></div>
    </div>
    <div class="status-badge status-online" id="status-badge"><span class="status-dot"></span><span class="status-text">En l\u00ednea</span></div>
  </header>
  <div class="section-title">Canales de Medicion Activos</div>
  <div class="cards-grid" id="cards-grid">
{cards_html}  </div>
  <div class="section-title">Valores Calculados</div>
  <div class="calc-grid">
{calc_html}  </div>
  <footer class="footer">
    <div class="footer-equipo">Equipo: <strong>#NOMBRE#</strong></div>
    <div class="footer-fecha">{E_CLOCK} Actualizado: #FECHA#</div>
  </footer>
</div>
<script>
{UNIT_MAP_JS}
{JS_LOGIC}
</script>
</body>
</html>
"""

with open("Plantilla01.html", "w", encoding="utf-8") as f:
    f.write(html)
print("Plantilla generada OK")
