import { useRef } from 'react'
import MonacoEditor, { OnMount } from '@monaco-editor/react'
import type { editor } from 'monaco-editor'

interface Props {
  value: string
  onChange: (value: string) => void
  language?: string
  readOnly?: boolean
  height?: string
}

export default function Editor({
  value,
  onChange,
  language = 'python',
  readOnly = false,
  height = '240px',
}: Props) {
  const editorRef = useRef<editor.IStandaloneCodeEditor | null>(null)

  const handleMount: OnMount = (editor) => {
    editorRef.current = editor
    editor.focus()
  }

  return (
    <div className="rounded-xl overflow-hidden border border-quest-border">
      <div className="flex items-center gap-2 px-4 py-2 bg-[#1e1e2e] border-b border-quest-border">
        <div className="w-3 h-3 rounded-full bg-red-500/70" />
        <div className="w-3 h-3 rounded-full bg-yellow-500/70" />
        <div className="w-3 h-3 rounded-full bg-green-500/70" />
        <span className="ml-2 text-xs text-quest-muted font-mono">{language}</span>
      </div>
      <MonacoEditor
        height={height}
        language={language}
        value={value}
        onChange={(v) => onChange(v ?? '')}
        onMount={handleMount}
        theme="vs-dark"
        options={{
          minimap: { enabled: false },
          fontSize: 14,
          fontFamily: "'JetBrains Mono', 'Fira Code', monospace",
          lineNumbers: 'on',
          scrollBeyondLastLine: false,
          wordWrap: 'on',
          readOnly,
          padding: { top: 12, bottom: 12 },
          overviewRulerLanes: 0,
          hideCursorInOverviewRuler: true,
          renderLineHighlight: 'gutter',
          scrollbar: { verticalScrollbarSize: 4, horizontalScrollbarSize: 4 },
          suggest: { showSnippets: true },
          quickSuggestions: { other: true, comments: false, strings: false },
        }}
      />
    </div>
  )
}
