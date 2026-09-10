export type DecisionStatus = 'EXECUTE' | 'CLARIFY' | 'REFUSE'

export interface AnswerPackage {
  status: DecisionStatus
  trace_id: string
  title: string
  message: string
  metric_id?: string
  definition?: string
  result?: unknown
  sql?: string
  join_path: string[]
  evidence: Array<Record<string, string>>
  assumptions: string[]
  alternatives: Array<Record<string, string>>
  validation: Record<string, unknown>
}

export async function ask(question: string, persona: string): Promise<AnswerPackage> {
  const apiUrl = import.meta.env.VITE_API_URL ?? 'http://localhost:8000'
  const response = await fetch(`${apiUrl}/api/ask`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ question, persona }),
  })
  if (!response.ok) throw new Error('The analytics service could not answer this question.')
  return response.json() as Promise<AnswerPackage>
}
