import { useRef } from 'react'
import MonacoEditor, { OnMount, Monaco } from '@monaco-editor/react'
import type { editor } from 'monaco-editor'

interface Props {
  value: string
  onChange: (value: string) => void
  language?: string
  readOnly?: boolean
  height?: string
  onCtrlEnter?: (value: string) => void
}

export default function Editor({
  value,
  onChange,
  language = 'python',
  readOnly = false,
  height = '240px',
  onCtrlEnter,
}: Props) {
  const editorRef = useRef<editor.IStandaloneCodeEditor | null>(null)
  const monacoRef = useRef<Monaco | null>(null)

  const handleMount: OnMount = (editor, monaco) => {
    editorRef.current = editor
    monacoRef.current = monaco
    if (!readOnly) {
      editor.focus()
      if (onCtrlEnter) {
        editor.addCommand(
          monaco.KeyMod.CtrlCmd | monaco.KeyCode.Enter,
          () => onCtrlEnter(editor.getValue())
        )
      }
    }
  }

  return (
    <div className="rounded-xl overflow-hidden border border-quest-border">
      <div className="flex items-center gap-2 px-4 py-2 bg-[#1e1e2e] border-b border-quest-border">
        <div className="w-3 h-3 rounded-full bg-red-500/70" />
        <div className="w-3 h-3 rounded-full bg-yellow-500/70" />
        <div className="w-3 h-3 rounded-full bg-green-500/70" />
        <span className="ml-2 text-xs text-quest-muted font-mono">{language}</span>
        <div className="ml-auto flex items-center gap-1">
          {!readOnly && (
            <button
              onClick={() => {
                if (editorRef.current) {
                  editorRef.current.getAction('editor.action.formatDocument')?.run()
                }
              }}
              className="text-xs text-quest-muted hover:text-quest-text transition-colors px-2 py-0.5 rounded hover:bg-white/10"
              title="Format code (Alt+Shift+F)"
            >
              ⎇ Format
            </button>
          )}
          <button
            onClick={() => {
              navigator.clipboard.writeText(value)
            }}
            className="text-xs text-quest-muted hover:text-quest-text transition-colors px-2 py-0.5 rounded hover:bg-white/10"
            title="Copy code"
          >
            📋
          </button>
        </div>
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
