// Frontend demo minimale (mock) – React 18 UMD + Babel in-browser
const {useState, useMemo, useEffect} = React;

function App(){
  const [tab, setTab] = useState('dashboard');
  const [health, setHealth] = useState(null);

  useEffect(()=>{
    fetch('/api/health').then(r=>r.json()).then(setHealth).catch(()=>setHealth({ok:false}));
  },[]);

  return (
    <div className="min-h-screen">
      <header className="sticky top-0 bg-white border-b px-4 py-3 flex items-center gap-3">
        <span className="text-xl font-bold">Powernet – Letture Remote</span>
        <nav className="ml-auto flex gap-2">
          {['dashboard','condomini','impostazioni'].map(k=> (
            <button key={k} onClick={()=>setTab(k)}
              className={`px-3 py-1.5 rounded ${tab===k?'bg-blue-600 text-white':'bg-slate-100'}`}>{k}</button>
          ))}
        </nav>
      </header>

      <main className="max-w-5xl mx-auto p-4 space-y-4">
        <div className="text-sm text-slate-600">Backend: {health? (health.ok? 'OK':'offline') : '…'}</div>
        {tab==='dashboard' && <Dashboard/>}
        {tab==='condomini' && <Condomini/>}
        {tab==='impostazioni' && <Impostazioni/>}
      </main>

      <footer className="text-center py-6 text-xs text-slate-500">© Powernet Srl</footer>
    </div>
  );
}

function Card({title, children}){
  return (
    <section className="bg-white rounded-2xl shadow p-4 border">
      <h3 className="font-semibold mb-2">{title}</h3>
      {children}
    </section>
  );
}

function Dashboard(){
  return (
    <div className="grid sm:grid-cols-3 gap-4">
      {['Condomìni','Unità','Anomalie'].map((l,i)=>(
        <Card key={l} title={l}>
          <div className="text-2xl font-bold">{[2,4,0][i]}</div>
        </Card>
      ))}
    </div>
  );
}

function Condomini(){
  const [tariffe,setTariffe]=React.useState({});
  useEffect(()=>{ fetch('/api/tariffe').then(r=>r.json()).then(setTariffe).catch(()=>{}); },[]);
  return (
    <Card title="Condomìni">
      <div className="text-sm">Tariffe mock: {JSON.stringify(tariffe)}</div>
      <p className="text-xs text-slate-500 mt-2">UI completa disponibile nella versione app React del progetto.</p>
    </Card>
  );
}

function Impostazioni(){
  const [cfg,setCfg]=useState({url:'',token:''});
  function salva(){ alert('Mock: salvataggio eseguito'); }
  return (
    <Card title="Integrazione Home Assistant (mock)">
      <div className="grid md:grid-cols-2 gap-3">
        <div><label className="block text-sm">URL HA</label><input value={cfg.url} onChange={e=>setCfg({...cfg,url:e.target.value})} className="mt-1 w-full border rounded p-2" placeholder="https://ha.example.it"/></div>
        <div><label className="block text-sm">Token</label><input value={cfg.token} onChange={e=>setCfg({...cfg,token:e.target.value})} className="mt-1 w-full border rounded p-2" placeholder="eyJ..." /></div>
      </div>
      <button onClick={salva} className="mt-3 px-3 py-2 rounded bg-blue-600 text-white">Salva</button>
    </Card>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App/>);
