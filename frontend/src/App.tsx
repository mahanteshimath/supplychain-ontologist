import { FormEvent, useState } from 'react'
import { ArrowUpRight, CheckCircle2, CircleAlert, Database, GitBranch, ShieldCheck } from 'lucide-react'
import { AnswerPackage, ask } from './api'

const examples = [
  'What was Acme on-time delivery in Q1 2026?',
  'What is our supplier health score?',
  'How many days of inventory do we have for PRT-A100?',
]

function App() {
  const [question, setQuestion] = useState('')
  const [persona, setPersona] = useState('procurement')
  const [answer, setAnswer] = useState<AnswerPackage | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  async function submit(event: FormEvent) {
    event.preventDefault()
    if (!question.trim()) return
    setLoading(true)
    setError('')
    try {
      setAnswer(await ask(question, persona))
    } catch (requestError) {
      setError(requestError instanceof Error ? requestError.message : 'Request failed.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <main className="shell">
      <header className="topbar">
        <div className="brand"><span className="brand-mark">A</span><span>ARB<span>ITER</span></span></div>
        <div className="status"><span className="status-dot" /> Governed analytics <span className="status-divider" /> Snowflake semantic layer</div>
      </header>

      <section className="hero-grid">
        <div className="intro">
          <p className="eyebrow">SUPPLY CHAIN CONTROL ROOM</p>
          <h1>Ask the number.<br /><em>Get the definition.</em></h1>
          <p className="lede">A governed conversational layer for the moments when one business question has too many technically correct answers.</p>
          <div className="signal-row"><span><ShieldCheck size={16} /> Definitions are versioned</span><span><Database size={16} /> Snowflake-backed</span></div>
        </div>
        <aside className="architecture-note">
          <span className="note-kicker">LIVE CONTRACT</span>
          <strong>Agents bind intent.<br />Semantic views own truth.</strong>
          <div className="note-flow"><span>Intent</span><i>→</i><span>Metric</span><i>→</i><span>Evidence</span></div>
        </aside>
      </section>

      <section className="workspace">
        <div className="workspace-head"><div><p className="eyebrow">CONVERSATIONAL ANALYTICS</p><h2>What do you need to know?</h2></div><label>PERSONA<select value={persona} onChange={(event) => setPersona(event.target.value)}><option value="planning">Planning</option><option value="procurement">Procurement</option><option value="logistics">Logistics</option><option value="general">General</option></select></label></div>
        <form className="question-box" onSubmit={submit}><textarea value={question} onChange={(event) => setQuestion(event.target.value)} placeholder="Try: What was Acme on-time delivery in Q1 2026?" rows={3} /><button disabled={loading} aria-label="Ask Arbiter">{loading ? 'Working' : <><span>Ask Arbiter</span><ArrowUpRight size={18} /></>}</button></form>
        <div className="examples">{examples.map((example) => <button key={example} onClick={() => setQuestion(example)}>{example}</button>)}</div>
        {error && <div className="error"><CircleAlert size={18} /> {error}</div>}
      </section>

      {answer && <section className={`answer answer-${answer.status.toLowerCase()}`}><div className="answer-top"><div><span className="decision"><CheckCircle2 size={16} /> {answer.status}</span><h2>{answer.title}</h2><p>{answer.message}</p></div><span className="trace">TRACE {answer.trace_id}</span></div>{answer.definition && <div className="answer-grid"><article><span className="label">GOVERNED DEFINITION</span><p className="definition">{answer.definition}</p></article><article><span className="label">VALIDATION</span><p>{String(answer.validation.status ?? 'Pending')}</p><span className="label">JOIN PATH</span><p className="path">{answer.join_path.join(' → ')}</p></article></div>}{answer.sql && <details><summary>View generated query plan</summary><pre>{answer.sql}</pre></details>}</section>}

      <footer><span>Arbiter / governed supply chain intelligence</span><span>Local API + PostgreSQL + Snowflake semantic views</span></footer>
    </main>
  )
}

export default App
